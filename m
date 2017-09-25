From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 25 Sep 2017 18:40:52 +0800
Subject: [Ocfs2-devel] [patch 2/2] ocfs2: clean up some unused func
 declaration
In-Reply-To: <59C5D7D6.9050106@huawei.com>
References: <59C5D7D6.9050106@huawei.com>
Message-ID: <867f4ae0-6f69-be40-d7ec-8e1b06002d55@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Cc Andrew as well.

On 17/9/23 11:41, piaojun wrote:
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

> ---
>  fs/ocfs2/buffer_head_io.h    | 3 ---
>  fs/ocfs2/cluster/heartbeat.h | 2 --
>  2 files changed, 5 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
> index b97bcc6..b1bb70c 100644
> --- a/fs/ocfs2/buffer_head_io.h
> +++ b/fs/ocfs2/buffer_head_io.h
> @@ -28,9 +28,6 @@
> 
>  #include <linux/buffer_head.h>
> 
> -void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
> -			     int uptodate);
> -
>  int ocfs2_write_block(struct ocfs2_super          *osb,
>  		      struct buffer_head  *bh,
>  		      struct ocfs2_caching_info   *ci);
> diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
> index 3ef5137..a9e67ef 100644
> --- a/fs/ocfs2/cluster/heartbeat.h
> +++ b/fs/ocfs2/cluster/heartbeat.h
> @@ -79,10 +79,8 @@ void o2hb_fill_node_map(unsigned long *map,
>  			unsigned bytes);
>  void o2hb_exit(void);
>  int o2hb_init(void);
> -int o2hb_check_node_heartbeating(u8 node_num);
>  int o2hb_check_node_heartbeating_no_sem(u8 node_num);
>  int o2hb_check_node_heartbeating_from_callback(u8 node_num);
> -int o2hb_check_local_node_heartbeating(void);
>  void o2hb_stop_all_regions(void);
>  int o2hb_get_all_regions(char *region_uuids, u8 numregions);
>  int o2hb_global_heartbeat_active(void);
> 
