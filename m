From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 25 Apr 2018 09:11:08 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: clean up redundant function
	declarations
In-Reply-To: <53ffd803-cd24-9947-9191-104861f715ff@huawei.com>
References: <53ffd803-cd24-9947-9191-104861f715ff@huawei.com>
Message-ID: <3608169e-987a-963d-4794-9b88ec5b7468@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/4/24 21:10, Jia Guo wrote:
> The function ocfs2_extend_allocation has been deleted, clean up its
> declaration.
> 
Also change the static function name from __ocfs2_extend_allocation()
to ocfs2_extend_allocation() to be consistent with the corresponding
trace events as well as comments for ocfs2_lock_allocators().

Please add above to description as well. 

> Fixes: 964f14a0d350 ("ocfs2: clean up some dead code")
> 
Redundant blank line here.

> Signed-off-by: Jia Guo <guojia12@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>

> ---
>  fs/ocfs2/file.c | 6 +++---
>  fs/ocfs2/file.h | 2 --
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6ee94bc..2dfec6b 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -563,7 +563,7 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
>  	return ret;
>  }
> 
> -static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
> +static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
>  				     u32 clusters_to_add, int mark_unwritten)
Parameters should be aligned with '('.
For example:
static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
				   u32 clusters_to_add, int mark_unwritten)

>  {
>  	int status = 0;
> @@ -1035,7 +1035,7 @@ int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
>  		clusters_to_add -= oi->ip_clusters;
> 
>  	if (clusters_to_add) {
> -		ret = __ocfs2_extend_allocation(inode, oi->ip_clusters,
> +		ret = ocfs2_extend_allocation(inode, oi->ip_clusters,
>  						clusters_to_add, 0);
Also here.

>  		if (ret) {
>  			mlog_errno(ret);
> @@ -1493,7 +1493,7 @@ static int ocfs2_allocate_unwritten_extents(struct inode *inode,
>  			goto next;
>  		}
> 
> -		ret = __ocfs2_extend_allocation(inode, cpos, alloc_size, 1);
> +		ret = ocfs2_extend_allocation(inode, cpos, alloc_size, 1);
>  		if (ret) {
>  			if (ret != -ENOSPC)
>  				mlog_errno(ret);
> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
> index 1fdc983..7eb7f03 100644
> --- a/fs/ocfs2/file.h
> +++ b/fs/ocfs2/file.h
> @@ -65,8 +65,6 @@ int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
>  			  u64 new_i_size, u64 zero_to);
>  int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
>  		      loff_t zero_to);
> -int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
> -		u32 clusters_to_add, int mark_unwritten);
>  int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
>  int ocfs2_getattr(const struct path *path, struct kstat *stat,
>  		  u32 request_mask, unsigned int flags);
> 

With above concern addressed,
Acked-by: Joseph Qi <jiangqi903@gmail.com>
