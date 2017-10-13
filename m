From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 13 Oct 2017 17:20:10 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: cleanup unused func
	declaration and assignment
In-Reply-To: <59E064BB.8000005@huawei.com>
References: <59E064BB.8000005@huawei.com>
Message-ID: <2ddbc43b-f185-56f8-7fbd-936d55ff35aa@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 17/10/13 15:01, piaojun wrote:
> Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

> ---
>  fs/ocfs2/alloc.c             | 2 --
>  fs/ocfs2/cluster/heartbeat.h | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index a177eae..31a416d 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -3585,8 +3585,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
>  		 * The easy case - we can just plop the record right in.
>  		 */
>  		*left_rec = *split_rec;
> -
> -		has_empty_extent = 0;
>  	} else
>  		le16_add_cpu(&left_rec->e_leaf_clusters, split_clusters);
> 
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
