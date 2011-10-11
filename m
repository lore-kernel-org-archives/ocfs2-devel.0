From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 11 Oct 2011 10:35:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Commit transactions in error cases.
In-Reply-To: <201109250913.p8P9DPGZ032059@acsmt356.oracle.com>
References: <201109250913.p8P9DPGZ032059@acsmt356.oracle.com>
Message-ID: <4E947E51.2040401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The first two are ok. Have a comment for the last one.

On 09/25/2011 02:13 AM, Wengang Wang wrote:
> Commit transactions in error cases.
>
> There are three cases found that in error cases, journal transactions are not
> committed nor aborted. We should take care of these case by committing the
> transactions. Otherwise, there would left a journal handle which will lead to
> , in same process context, the comming ocfs2_start_trans() gets wrong credits.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/alloc.c |    2 +-
>   fs/ocfs2/ioctl.c |    3 ++-
>   fs/ocfs2/xattr.c |    2 +-
>   3 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index ed553c6..3165aeb 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5699,7 +5699,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
>   					   OCFS2_JOURNAL_ACCESS_WRITE);
>   	if (ret) {
>   		mlog_errno(ret);
> -		goto out;
> +		goto out_commit;
>   	}
>
>   	dquot_free_space_nodirty(inode,
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index bc91072..5612c3d 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -122,7 +122,7 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>   	if ((oldflags&  OCFS2_IMMUTABLE_FL) || ((flags ^ oldflags)&
>   		(OCFS2_APPEND_FL | OCFS2_IMMUTABLE_FL))) {
>   		if (!capable(CAP_LINUX_IMMUTABLE))
> -			goto bail_unlock;
> +			goto bail_commit;
>   	}
>
>   	ocfs2_inode->ip_attr = flags;
> @@ -132,6 +132,7 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>   	if (status<  0)
>   		mlog_errno(status);
>
> +bail_commit:
>   	ocfs2_commit_trans(osb, handle);
>   bail_unlock:
>   	ocfs2_inode_unlock(inode, 1);
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 81ecf9c..6eb01c5 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2376,12 +2376,12 @@ static int ocfs2_remove_value_outside(struct inode*inode,
>   		}
>
>   		ret = ocfs2_xattr_value_truncate(inode, vb, 0,&ctxt);
> +		ocfs2_commit_trans(osb, ctxt.handle);
>   		if (ret<  0) {
>   			mlog_errno(ret);
>   			break;
>   		}
>
> -		ocfs2_commit_trans(osb, ctxt.handle);
>   		if (ctxt.meta_ac) {
>   			ocfs2_free_alloc_context(ctxt.meta_ac);
>   			ctxt.meta_ac = NULL;

  		ret = ocfs2_xattr_value_truncate(inode, vb, 0,&ctxt);
- 		if (ret<  0) {
- 			mlog_errno(ret);
- 			break;
- 		}

		ocfs2_commit_trans(osb, ctxt.handle);
  		if (ctxt.meta_ac) {
  			ocfs2_free_alloc_context(ctxt.meta_ac);
  			ctxt.meta_ac = NULL;

+ 		if (ret<  0) {
+ 			mlog_errno(ret);
+ 			break;
+ 		}


I don't like the commit_trans() shoe horned. The above reads cleaner imo.
