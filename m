From: piaojun <piaojun@huawei.com>
Date: Thu, 12 Apr 2018 09:37:32 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Take inode cluster lock before
 moving reflinked inode from orphan dir
In-Reply-To: <1523475107-7639-1-git-send-email-ashish.samant@oracle.com>
References: <1523475107-7639-1-git-send-email-ashish.samant@oracle.com>
Message-ID: <5ACEB85C.1060403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2018/4/12 3:31, Ashish Samant wrote:
> While reflinking an inode, we create a new inode in orphan directory, then
> take EX lock on it, reflink the original inode to orphan inode and release
> EX lock. Once the lock is released another node could request it in EX mode
> from ocfs2_recover_orphans() which causes downconvert of the lock, on this
> node, to NL mode.
> 
> Later we attempt to initialize security acl for the orphan inode and move
> it to the reflink destination. However, while doing this we dont take EX
> lock on the inode. This could potentially cause problems because we could
> be starting transaction, accessing journal and modifying metadata of the
> inode while holding NL lock and with another node holding EX lock on the
> inode.
> 
> Fix this by taking orphan inode cluster lock in EX mode before
> initializing security and moving orphan inode to reflink destination.
> Use the __tracker variant while taking inode lock to avoid recursive
> locking in the ocfs2_init_security_and_acl() call chain.
> 
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
Acked-by: Jun Piao <piaojun@huawei.com>
> 
> V1->V2:
> Modify commit message to better reflect the problem in upstream kernel.
> ---
>  fs/ocfs2/refcounttree.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index ab156e3..1b1283f 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -4250,10 +4250,11 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
>  static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>  			 struct dentry *new_dentry, bool preserve)
>  {
> -	int error;
> +	int error, had_lock;
>  	struct inode *inode = d_inode(old_dentry);
>  	struct buffer_head *old_bh = NULL;
>  	struct inode *new_orphan_inode = NULL;
> +	struct ocfs2_lock_holder oh;
>  
>  	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
>  		return -EOPNOTSUPP;
> @@ -4295,6 +4296,14 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>  		goto out;
>  	}
>  
> +	had_lock = ocfs2_inode_lock_tracker(new_orphan_inode, NULL, 1,
> +					    &oh);
> +	if (had_lock < 0) {
> +		error = had_lock;
> +		mlog_errno(error);
> +		goto out;
> +	}
> +
>  	/* If the security isn't preserved, we need to re-initialize them. */
>  	if (!preserve) {
>  		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
> @@ -4302,14 +4311,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>  		if (error)
>  			mlog_errno(error);
>  	}
> -out:
>  	if (!error) {
>  		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
>  						       new_dentry);
>  		if (error)
>  			mlog_errno(error);
>  	}
> +	ocfs2_inode_unlock_tracker(new_orphan_inode, 1, &oh, had_lock);
>  
> +out:
>  	if (new_orphan_inode) {
>  		/*
>  		 * We need to open_unlock the inode no matter whether we
> 
