From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 28 Oct 2008 10:24:38 +0800
Subject: [Ocfs2-devel] [PATCH 09/13] ocfs2: Take ocfs2_xattr_bucket
 structures off of the stack.
In-Reply-To: <1225156828-32189-10-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
	<1225156828-32189-10-git-send-email-joel.becker@oracle.com>
Message-ID: <490677E6.7050004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> The ocfs2_xattr_bucket structure is a nice abstraction, but it is a bit
> large to have on the stack.  Just like ocfs2_path, let's allocate it
> with a ocfs2_xattr_bucket_new() function.
> 
> We can now store the inode on the bucket, cleaning up all the other
> bucket functions.  While we're here, we catch another place or two that
> wasn't using ocfs2_read_xattr_bucket().
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>


> @@ -2042,6 +2074,18 @@ int ocfs2_xattr_set(struct inode *inode,
>  	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
>  		return -EOPNOTSUPP;
>  
> +	xis.bucket = ocfs2_xattr_bucket_new(inode);
> +	if (!xis.bucket) {
> +		mlog_errno(-ENOMEM);
> +		return -ENOMEM;
> +	}
xis is used for xattr search in inode, so we don't need to allocate bucket.
> +	xbs.bucket = ocfs2_xattr_bucket_new(inode);
> +	if (!xbs.bucket) {
> +		ocfs2_xattr_bucket_free(xbs.bucket);
> +		mlog_errno(-ENOMEM);
> +		return -ENOMEM;
> +	}
can we allocate this only when we really need this? that means we may 
allocate it in ocfs2_create_index_block(when we create a new one) and 
ocfs2_xattr_index_block_find if there is some buckets exist?

Regards,
Tao
