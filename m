From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 17:33:08 -0800
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: add ocfs2_acl_chmod
In-Reply-To: <1225366931-6454-1-git-send-email-tiger.yang@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225366931-6454-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20081107013308.GK15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 07:42:11PM +0800, Tiger Yang wrote:
> This function use to update acl xattrs when
> file mode was changed.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/acl.c  |   34 ++++++++++++++++++++++++++++++++++
>  fs/ocfs2/acl.h  |    7 +++++++
>  fs/ocfs2/file.c |    8 ++++++++
>  3 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index 584da84..7c7e4d4 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -288,6 +288,40 @@ int ocfs2_check_acl(struct inode *inode, int mask)
>  	return -EAGAIN;
>  }
>  
> +int ocfs2_acl_chmod(handle_t *handle,
> +		    struct inode *inode,
> +		    struct buffer_head *di_bh)
> +{
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct posix_acl *acl, *clone;
> +	int ret;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
> +		return 0;
> +
> +	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, di_bh);
> +	if (IS_ERR(acl) || !acl)
> +		return PTR_ERR(acl);
> +	clone = posix_acl_clone(acl, GFP_KERNEL);
> +	posix_acl_release(acl);
> +	if (!clone)
> +		return -ENOMEM;
> +	ret = posix_acl_chmod_masq(clone, inode->i_mode);
> +	if (!ret)
> +		/*
> +		 * only replace same size acl here, so wouldn't
> +		 * reserve metadata and clusters.
> +		 */
> +		ret = ocfs2_set_acl_handle(handle, inode, di_bh,
> +					   ACL_TYPE_ACCESS, clone,
> +					   NULL, NULL);
> +	posix_acl_release(clone);
> +	return ret;
> +}
> +
>  static size_t ocfs2_xattr_list_acl_access(struct inode *inode,
>  					  char *list,
>  					  size_t list_len,
> diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
> index fef10f1..f7b1df7 100644
> --- a/fs/ocfs2/acl.h
> +++ b/fs/ocfs2/acl.h
> @@ -29,10 +29,17 @@ struct ocfs2_acl_entry {
>  #ifdef CONFIG_OCFS2_FS_POSIX_ACL
>  
>  extern int ocfs2_check_acl(struct inode *, int);
> +extern int ocfs2_acl_chmod(handle_t *, struct inode *, struct buffer_head *);
>  
>  #else /* CONFIG_OCFS2_FS_POSIX_ACL*/
>  
>  #define ocfs2_check_acl NULL
> +static inline int ocfs2_acl_chmod(handle_t *handle,
> +				  struct inode *inode,
> +				  struct buffer_head *di_bh)
> +{
> +	return 0;
> +}
>  
>  #endif /* CONFIG_OCFS2_FS_POSIX_ACL*/
>  
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 5a45b6b..66d5395 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -977,6 +977,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		goto bail_commit;
>  	}
>  
> +	if (attr->ia_valid & ATTR_MODE) {
> +		status = ocfs2_acl_chmod(handle, inode, bh);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail_commit;
> +		}
> +	}
> +
>  	status = ocfs2_mark_inode_dirty(handle, inode, bh);
>  	if (status < 0)
>  		mlog_errno(status);

I think we need to increase the number of credits that the transaction
started for this part of setattr uses.

This should be pretty easy though - the call to ocfs2_start_trans() is right
above here, and it already takes OCFS2_INODE_UPDATE_CREDITS. I'd just use a
'credits' variable and increase it by however many is the maximum that might
be required if the fs is mounted with acls turned on.
	--Mark

--
Mark Fasheh
