From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Jan  9 09:43:30 2008
Subject: [Ocfs2-devel] [PATCH 1/1] Change default value for o2net and
	heartbeat.
In-Reply-To: <20080109025432.GA14956@tma-pc1.cn.oracle.com>
References: <20080109025432.GA14956@tma-pc1.cn.oracle.com>
Message-ID: <478507A8.2080009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks. We need this for 2.6.25.

Tao Ma wrote:
> The default value for o2net and heartbeat have been changed
> in the newest o2cb configure(ocfs2-tools).
> So change it also in kernel.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.h |    2 +-
>  fs/ocfs2/cluster/tcp.h       |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
> index 35397dd..e511339 100644
> --- a/fs/ocfs2/cluster/heartbeat.h
> +++ b/fs/ocfs2/cluster/heartbeat.h
> @@ -35,7 +35,7 @@
>  #define O2HB_LIVE_THRESHOLD	   2
>  /* number of equal samples to be seen as dead */
>  extern unsigned int o2hb_dead_threshold;
> -#define O2HB_DEFAULT_DEAD_THRESHOLD	   7
> +#define O2HB_DEFAULT_DEAD_THRESHOLD	   31
>  /* Otherwise MAX_WRITE_TIMEOUT will be zero... */
>  #define O2HB_MIN_DEAD_THRESHOLD	  2
>  #define O2HB_MAX_WRITE_TIMEOUT_MS (O2HB_REGION_TIMEOUT_MS * (o2hb_dead_threshold - 1))
> diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
> index da880fc..f36f66a 100644
> --- a/fs/ocfs2/cluster/tcp.h
> +++ b/fs/ocfs2/cluster/tcp.h
> @@ -60,8 +60,8 @@ typedef void (o2net_post_msg_handler_func)(int status, void *data,
>  /* same as hb delay, we're waiting for another node to recognize our hb */
>  #define O2NET_RECONNECT_DELAY_MS_DEFAULT	2000
>  
> -#define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	5000
> -#define O2NET_IDLE_TIMEOUT_MS_DEFAULT		10000
> +#define O2NET_KEEPALIVE_DELAY_MS_DEFAULT	2000
> +#define O2NET_IDLE_TIMEOUT_MS_DEFAULT		30000
>  
>  
>  /* TODO: figure this out.... */
>   
