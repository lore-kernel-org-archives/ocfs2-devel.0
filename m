From: Jensen <shencanquan@huawei.com>
Date: Fri, 28 Jun 2013 09:42:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix issue that ocfs2_setattr()
 does not deal with new_i_size==i_size
In-Reply-To: <51CBEFEA.3010308@huawei.com>
References: <51CBEFEA.3010308@huawei.com>
Message-ID: <51CCE9EC.5090503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It looks good to me.

reviewed-by: Jensen <shencanquan@huawei.com>

On 2013/6/27 15:55, Younger Liu wrote:

> The issue scenario is as following:
> 1. fallocate a large disk space(eg. 30G) with FALLOC_FL_KEEP_SIZE
> for a file whose i_size and disk size are 512(or other size). 
> After executing fallocate, i_size file is still 512, and the disk 
> size became to 30G+512?
> 2. ftruncate the file to new_i_size which equal to inode->i_size.
> After executing ftruncate, disk space does not changes. 
> In other words, i_size file is still 512, and disk size is
> 30G+512. But we want disk size to be 512.
> This does not meet our expectations.
> 
> In order to Solving the issue above, we modified ocfs2_setattr(), 
> if attr->ia_size != i_size_read(inode), It calls 
> ocfs2_truncate_file(), and truncate disk space to attr->ia_size.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> ---
>  fs/ocfs2/alloc.c |    2 +-
>  fs/ocfs2/file.c  |    7 ++-----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index b8a9d87..19837d4 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7126,7 +7126,7 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
>  	if (end > i_size_read(inode))
>  		end = i_size_read(inode);
>  
> -	BUG_ON(start >= end);
> +	BUG_ON(start > end);
>  
>  	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>  	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 793c010..2e405e8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -476,9 +476,6 @@ static int ocfs2_truncate_file(struct inode *inode,
>  
>  	/* lets handle the simple truncate cases before doing any more
>  	 * cluster locking. */
> -	if (new_i_size == le64_to_cpu(fe->i_size))
> -		goto bail;
> -
>  	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>  
>  	ocfs2_resv_discard(&osb->osb_la_resmap,
> @@ -1150,14 +1147,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		goto bail_unlock_rw;
>  	}
>  
> -	if (size_change && attr->ia_size != i_size_read(inode)) {
> +	if (size_change) {
>  		status = inode_newsize_ok(inode, attr->ia_size);
>  		if (status)
>  			goto bail_unlock;
>  
>  		inode_dio_wait(inode);
>  
> -		if (i_size_read(inode) > attr->ia_size) {
> +		if (i_size_read(inode) >= attr->ia_size) {
>  			if (ocfs2_should_order_data(inode)) {
>  				status = ocfs2_begin_ordered_truncate(inode,
>  								      attr->ia_size);
