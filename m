From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 6 Jan 2017 14:09:52 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: fix deadlocks when taking
 inode lock at vfs entry points
In-Reply-To: <1483630262-22227-3-git-send-email-zren@suse.com>
References: <1483630262-22227-1-git-send-email-zren@suse.com>
	<1483630262-22227-3-git-send-email-zren@suse.com>
Message-ID: <dbf37786-9620-77fe-c500-881fdd455964@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Ren <zren@suse.com>, ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, ghe@suse.com, junxiao.bi@oracle.com, linux-kernel@vger.kernel.org

Hi Eric,


On 17/1/5 23:31, Eric Ren wrote:
> Commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
> results in a deadlock, as the author "Tariq Saeed" realized shortly
> after the patch was merged. The discussion happened here
> (https://oss.oracle.com/pipermail/ocfs2-devel/2015-September/011085.html).
>
> The reason why taking cluster inode lock at vfs entry points opens up
> a self deadlock window, is explained in the previous patch of this
> series.
>
> So far, we have seen two different code paths that have this issue.
> 1. do_sys_open
>       may_open
>        inode_permission
>         ocfs2_permission
>          ocfs2_inode_lock() <=== take PR
>           generic_permission
>            get_acl
>             ocfs2_iop_get_acl
>              ocfs2_inode_lock() <=== take PR
> 2. fchmod|fchmodat
>      chmod_common
>       notify_change
>        ocfs2_setattr <=== take EX
>         posix_acl_chmod
>          get_acl
>           ocfs2_iop_get_acl <=== take PR
>          ocfs2_iop_set_acl <=== take EX
>
> Fixes them by adding the tracking logic (in the previous patch) for
> these funcs above, ocfs2_permission(), ocfs2_iop_[set|get]_acl(),
> ocfs2_setattr().
As described cases above, shall we just add the tracking logic only for 
set/get_acl()?

Thanks,
Joseph
>
> Signed-off-by: Eric Ren <zren@suse.com>
> ---
>   fs/ocfs2/acl.c  | 39 ++++++++++++++++++++++++++++++++++-----
>   fs/ocfs2/file.c | 44 ++++++++++++++++++++++++++++++++++----------
>   2 files changed, 68 insertions(+), 15 deletions(-)
>
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index bed1fcb..c539890 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -284,16 +284,31 @@ int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>   {
>   	struct buffer_head *bh = NULL;
>   	int status = 0;
> -
> -	status = ocfs2_inode_lock(inode, &bh, 1);
> +	int arg_flags = 0, has_locked;
> +	struct ocfs2_holder oh;
> +	struct ocfs2_lock_res *lockres;
> +
> +	lockres = &OCFS2_I(inode)->ip_inode_lockres;
> +	has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
> +	if (has_locked)
> +		arg_flags = OCFS2_META_LOCK_GETBH;
> +	status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
>   	if (status < 0) {
>   		if (status != -ENOENT)
>   			mlog_errno(status);
>   		return status;
>   	}
> +	if (!has_locked)
> +		ocfs2_add_holder(lockres, &oh);
> +
>   	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
> -	ocfs2_inode_unlock(inode, 1);
> +
> +	if (!has_locked) {
> +		ocfs2_remove_holder(lockres, &oh);
> +		ocfs2_inode_unlock(inode, 1);
> +	}
>   	brelse(bh);
> +
>   	return status;
>   }
>   
> @@ -303,21 +318,35 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
>   	struct buffer_head *di_bh = NULL;
>   	struct posix_acl *acl;
>   	int ret;
> +	int arg_flags = 0, has_locked;
> +	struct ocfs2_holder oh;
> +	struct ocfs2_lock_res *lockres;
>   
>   	osb = OCFS2_SB(inode->i_sb);
>   	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
>   		return NULL;
> -	ret = ocfs2_inode_lock(inode, &di_bh, 0);
> +
> +	lockres = &OCFS2_I(inode)->ip_inode_lockres;
> +	has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
> +	if (has_locked)
> +		arg_flags = OCFS2_META_LOCK_GETBH;
> +	ret = ocfs2_inode_lock_full(inode, &di_bh, 0, arg_flags);
>   	if (ret < 0) {
>   		if (ret != -ENOENT)
>   			mlog_errno(ret);
>   		return ERR_PTR(ret);
>   	}
> +	if (!has_locked)
> +		ocfs2_add_holder(lockres, &oh);
>   
>   	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
>   
> -	ocfs2_inode_unlock(inode, 0);
> +	if (!has_locked) {
> +		ocfs2_remove_holder(lockres, &oh);
> +		ocfs2_inode_unlock(inode, 0);
> +	}
>   	brelse(di_bh);
> +
>   	return acl;
>   }
>   
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index c488965..62be75d 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1138,6 +1138,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>   	handle_t *handle = NULL;
>   	struct dquot *transfer_to[MAXQUOTAS] = { };
>   	int qtype;
> +	int arg_flags = 0, had_lock;
> +	struct ocfs2_holder oh;
> +	struct ocfs2_lock_res *lockres;
>   
>   	trace_ocfs2_setattr(inode, dentry,
>   			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
> @@ -1173,13 +1176,20 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>   		}
>   	}
>   
> -	status = ocfs2_inode_lock(inode, &bh, 1);
> +	lockres = &OCFS2_I(inode)->ip_inode_lockres;
> +	had_lock = (ocfs2_is_locked_by_me(lockres) != NULL);
> +	if (had_lock)
> +		arg_flags = OCFS2_META_LOCK_GETBH;
> +	status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
>   	if (status < 0) {
>   		if (status != -ENOENT)
>   			mlog_errno(status);
>   		goto bail_unlock_rw;
>   	}
> -	inode_locked = 1;
> +	if (!had_lock) {
> +		ocfs2_add_holder(lockres, &oh);
> +		inode_locked = 1;
> +	}
>   
>   	if (size_change) {
>   		status = inode_newsize_ok(inode, attr->ia_size);
> @@ -1260,7 +1270,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>   bail_commit:
>   	ocfs2_commit_trans(osb, handle);
>   bail_unlock:
> -	if (status) {
> +	if (status && inode_locked) {
> +		ocfs2_remove_holder(lockres, &oh);
>   		ocfs2_inode_unlock(inode, 1);
>   		inode_locked = 0;
>   	}
> @@ -1278,8 +1289,10 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>   		if (status < 0)
>   			mlog_errno(status);
>   	}
> -	if (inode_locked)
> +	if (inode_locked) {
> +		ocfs2_remove_holder(lockres, &oh);
>   		ocfs2_inode_unlock(inode, 1);
> +	}
>   
>   	brelse(bh);
>   	return status;
> @@ -1321,20 +1334,31 @@ int ocfs2_getattr(struct vfsmount *mnt,
>   int ocfs2_permission(struct inode *inode, int mask)
>   {
>   	int ret;
> +	int has_locked;
> +	struct ocfs2_holder oh;
> +	struct ocfs2_lock_res *lockres;
>   
>   	if (mask & MAY_NOT_BLOCK)
>   		return -ECHILD;
>   
> -	ret = ocfs2_inode_lock(inode, NULL, 0);
> -	if (ret) {
> -		if (ret != -ENOENT)
> -			mlog_errno(ret);
> -		goto out;
> +	lockres = &OCFS2_I(inode)->ip_inode_lockres;
> +	has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
> +	if (!has_locked) {
> +		ret = ocfs2_inode_lock(inode, NULL, 0);
> +		if (ret) {
> +			if (ret != -ENOENT)
> +				mlog_errno(ret);
> +			goto out;
> +		}
> +		ocfs2_add_holder(lockres, &oh);
>   	}
>   
>   	ret = generic_permission(inode, mask);
>   
> -	ocfs2_inode_unlock(inode, 0);
> +	if (!has_locked) {
> +		ocfs2_remove_holder(lockres, &oh);
> +		ocfs2_inode_unlock(inode, 0);
> +	}
>   out:
>   	return ret;
>   }
