From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 02 Sep 2009 09:54:31 +0800
Subject: [Ocfs2-devel] [PATCH 12/14] ocfs2: Let ocfs2_xa_prepare_entry()
	do space checks.
In-Reply-To: <1251448563-12508-13-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-13-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9DD057.3050306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> ocfs2_xattr_set_in_bucket() doesn't need to do its own hacky space
> checking.  Let's let ocfs2_xa_prepare_entry() (via ocfs2_xa_set()) do
> the more accurate work.  Whenever it doesn't have space,
> ocfs2_xattr_set_in_bucket() can try to get more space.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |  239 ++++++++++++++++-------------------------------------
>  1 files changed, 72 insertions(+), 167 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index b4cda7e..e400d64 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
<snip>
> -	free = xh_free_start - header_size - OCFS2_XATTR_HEADER_GAP;
> +	/* Ack, need more space.  Let's try to get another bucket! */
> +
>  	/*
> -	 * We need to make sure the new name/value pair
> -	 * can exist in the same block.
> +	 * We do not allow for overlapping ranges between buckets. And
> +	 * the maximum number of collisions we will allow for then is
> +	 * one bucket's worth, so check it here whether we need to
> +	 * add a new bucket for the insert.
>  	 */
> -	if (xh_free_start % blocksize < need)
> -		free -= xh_free_start % blocksize;
> -
> -	mlog(0, "xs->not_found = %d, in xattr bucket %llu: free = %d, "
> -	     "need = %d, max_free = %d, xh_free_start = %u, xh_name_value_len ="
> -	     " %u\n", xs->not_found,
> -	     (unsigned long long)bucket_blkno(xs->bucket),
> -	     free, need, max_free, le16_to_cpu(xh->xh_free_start),
> -	     le16_to_cpu(xh->xh_name_value_len));
> -
> -	if (free < need ||
> -	    (xs->not_found &&
> -	     count == ocfs2_xattr_max_xe_in_bucket(inode->i_sb))) {
> -		if (need <= max_free &&
> -		    count < ocfs2_xattr_max_xe_in_bucket(inode->i_sb)) {
I just have one concern. Here we used to check whether count == 
ocfs2_xattr_max_xe_in_bucket(inode->i_sb) which make sure 
ocfs2_xattr_entry to be stored only in the first block of a bucket(this 
is a legacy issue before you added ocfs2_xattr_bucket abstraction), so 
now you remove this restriction. Maybe it is ok since now we already 
read the whole bucket and it looks that your current xa_* abstraction 
can handle it. Just want to remind you of it.

Regards,
Tao
