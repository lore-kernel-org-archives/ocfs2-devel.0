From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 14 May 2013 14:41:40 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: goto out_unlock if
 ocfs2_get_clusters_nocache failed in ocfs2_fiemap
In-Reply-To: <5191D358.1050405@huawei.com>
References: <5191D358.1050405@huawei.com>
Message-ID: <5191DCA4.5080004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/14/2013 02:02 PM, Joseph Qi wrote:
> Last time we found there is lock/unlock bug in ocfs2_file_aio_write, and
> then we did a thorough search for all lock resources in
> ocfs2_inode_info, including rw, inode and open lockres and found this
> bug. My kernel version is 3.0.13, and it is also in the lastest version 3.9.
> In ocfs2_fiemap, once ocfs2_get_clusters_nocache failed, it should goto
> out_unlock instead of out, because we need release buffer head, up read
> alloc sem and unlock inode.
> 
> Cc: stable at vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> 
> ---
>  fs/ocfs2/extent_map.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 1c39efb..2487116 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -790,7 +790,7 @@ int ocfs2_fiemap(struct inode *inode, struct
> fiemap_extent_info *fieinfo,
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Corrupt patch.

After fixing this issue, you can add:
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

>  						 &hole_size, &rec, &is_last);
>  		if (ret) {
>  			mlog_errno(ret);
> -			goto out;
> +			goto out_unlock;
>  		}
> 
>  		if (rec.e_blkno == 0ULL) {
> 
-Jeff
