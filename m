From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Sat, 25 Sep 2010 17:36:38 +0800
Subject: [Ocfs2-devel] [PATCH 13/20] ocfs2/cluster: Track number of
 global heartbeat regions
In-Reply-To: <1284504656-2434-14-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-14-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100925093638.GD3950@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-09-14 15:50, Sunil Mushran wrote:
> In global heartbeat mode, we have a upper limit for the number of active regions.
> This patch adds the facility to track the number of active global heartbeat
> regions and fails to start heartbeat if the number exceeds the maximum.
> 
> Signed-of-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c |   24 ++++++++++++++++++++++--
>  1 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 29b5c70..57c906b 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -62,6 +62,12 @@ static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
>  static LIST_HEAD(o2hb_node_events);
>  static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
>  
> +/*
> + * In global heartbeat, we maintain a series of region bitmaps.
> + * 	- o2hb_region_bitmap allows us to limit the region number to max region.
> + */
> +static unsigned long o2hb_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
> +
>  #define O2HB_DB_TYPE_LIVENODES		0
>  struct o2hb_debug_buf {
>  	int db_type;
> @@ -176,6 +182,7 @@ struct o2hb_region {
>  
>  	/* live node map of this region */
>  	unsigned long		hr_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +	unsigned int		hr_region_num;

I don't remember clear the value for O2NM_MAX_REGIONS, 32? Will
u8 be better than "unsigned int"?

regards,
wengang.
