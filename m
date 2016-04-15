From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 15 Apr 2016 17:46:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up unused parameter 'count'
	in o2hb_read_block_input()
In-Reply-To: <5710B73B.8030901@huawei.com>
References: <5710B73B.8030901@huawei.com>
Message-ID: <5710B88E.4080902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/4/15 17:41, piaojun wrote:
> clean up unused parameter 'count' in o2hb_read_block_input().
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  fs/ocfs2/cluster/heartbeat.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index bd15929..a5956c4 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1456,7 +1456,6 @@ static void o2hb_region_release(struct config_item *item)
>  
>  static int o2hb_read_block_input(struct o2hb_region *reg,
>  				 const char *page,
> -				 size_t count,
>  				 unsigned long *ret_bytes,
>  				 unsigned int *ret_bits)
>  {
> @@ -1499,8 +1498,8 @@ static ssize_t o2hb_region_block_bytes_store(struct config_item *item,
>  	if (reg->hr_bdev)
>  		return -EINVAL;
>  
> -	status = o2hb_read_block_input(reg, page, count,
> -				       &block_bytes, &block_bits);
> +	status = o2hb_read_block_input(reg, page, &block_bytes,
> +				       &block_bits);
>  	if (status)
>  		return status;
>  
> 
