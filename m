From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 13:25:53 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update atime in splice read if
	necessary.
In-Reply-To: <1245397012-20648-1-git-send-email-tao.ma@oracle.com>
References: <1245397012-20648-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4A3BF451.10000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Tao Ma wrote:
> We should call ocfs2_inode_lock_atime instead of ocfs2_inode_lock
> in ocfs2_file_splice_read like we do in ocfs2_file_aio_read so
> that we can update atime in splice read if necessary.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/file.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 775ac34..95cba48 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2025,7 +2025,7 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
>  				      size_t len,
>  				      unsigned int flags)
>  {
> -	int ret = 0;
> +	int ret = 0, lock_level = 0;
>  	struct inode *inode = in->f_path.dentry->d_inode;
>  
>  	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
> @@ -2036,12 +2036,12 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
>  	/*
>  	 * See the comment in ocfs2_file_aio_read()
>  	 */
> -	ret = ocfs2_inode_lock(inode, NULL, 0);
> +	ret = ocfs2_inode_lock_atime(inode, in->f_vfsmnt, &lock_level);
>  	if (ret < 0) {
>  		mlog_errno(ret);
>  		goto bail;
>  	}
> -	ocfs2_inode_unlock(inode, 0);
> +	ocfs2_inode_unlock(inode, lock_level);
>  
>  	ret = generic_file_splice_read(in, ppos, pipe, len, flags);
>  
>   
