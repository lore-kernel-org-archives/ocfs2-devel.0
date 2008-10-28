From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 28 Oct 2008 10:44:35 +0800
Subject: [Ocfs2-devel] [PATCH 06/13] ocfs2: Improve
	ocfs2_read_xattr_bucket().
In-Reply-To: <1225156828-32189-7-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
	<1225156828-32189-7-git-send-email-joel.becker@oracle.com>
Message-ID: <49067C93.3050307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> The ocfs2_read_xattr_bucket() function would read an xattr bucket into a
> list of buffer heads.  However, we have a nice ocfs2_xattr_bucket
> structure.  Let's have it fill that out instead.
> 
> In addition, ocfs2_read_xattr_bucket() would initialize buffer heads for
> a bucket that's never been on disk before.  That's confusing.  Let's
> call that functionality ocfs2_init_xattr_bucket().
> 
> The functions ocfs2_cp_xattr_bucket() and ocfs2_half_xattr_bucket() are
> updated to use the ocfs2_xattr_bucket structure rather than raw bh
> lists.  That way they can use the new read/init calls.  In addition,
> they drop the wasted read of an existing target bucket.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  /*
>   * Move half num of the xattrs in old bucket(blk) to new bucket(new_blk).
>   * first_hash will record the 1st hash of the new bucket.
> @@ -3128,7 +3145,7 @@ static int ocfs2_half_xattr_bucket(struct inode *inode,
>  	int ret, i;
>  	u16 count, start, len, name_value_len, xe_len, name_offset;
>  	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
> -	struct buffer_head **s_bhs, **t_bhs = NULL;
> +	struct ocfs2_xattr_bucket s_bucket, t_bucket;
>  	struct ocfs2_xattr_header *xh;
>  	struct ocfs2_xattr_entry *xe;
>  	int blocksize = inode->i_sb->s_blocksize;
snip
> -	t_bhs = kcalloc(blk_per_bucket, sizeof(struct buffer_head *), GFP_NOFS);
> -	if (!t_bhs) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -
> -	ret = ocfs2_read_xattr_bucket(inode, new_blk, t_bhs, new_bucket_head);
> +	/*
> +	 * Even if !new_bucket_head, we're overwriting t_bucket.  Thus,
> +	 * there's no need to read it.
> +	 */
> +	ret = ocfs2_init_xattr_bucket(inode, &t_bucket, new_blk);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out;
>  	}
>  
>  	for (i = 0; i < blk_per_bucket; i++) {
> -		ret = ocfs2_journal_access(handle, inode, t_bhs[i],
> +		ret = ocfs2_journal_access(handle, inode, t_bucket.bu_bhs[i],
>  					   new_bucket_head ?
>  					   OCFS2_JOURNAL_ACCESS_CREATE :
>  					   OCFS2_JOURNAL_ACCESS_WRITE);
I have read the caller of ocfs2_half_xattr_bucket again. In 
ocfs2_extend_xattr_bucket when we want to half the bucket to a 
never-used new bucket within the same cluster(while we always pass 
new_bucket_head=0), do we need to use OCFS2_JOURNAL_ACCESS_CREATE? If 
yes, maybe we have to modify the caller to be more precisely(I can 
handle this based on your patch set). The same goes for 
ocfs2_cp_xattr_bucket.

Regards,
Tao
