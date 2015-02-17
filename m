From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 17 Feb 2015 15:30:57 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: remove useless if statement
In-Reply-To: <20150217071350.GA9568@devel.8.8.4.4>
References: <20150217071350.GA9568@devel.8.8.4.4>
Message-ID: <20150217153057.c911fc895051343d69a78423@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, 17 Feb 2015 16:13:50 +0900 Daeseok Youn <daeseok.youn@gmail.com> wrote:

> The Local variable "i" in for loop is always less then
> O2CB_MAP_STABILIZE_COUNT.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  fs/ocfs2/stack_o2cb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index 1724d43..813d726 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -295,8 +295,8 @@ static int o2cb_cluster_check(void)
>  		set_bit(node_num, netmap);
>  		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
>  			return 0;
> -		if (i < O2CB_MAP_STABILIZE_COUNT)
> -			msleep(1000);
> +
> +		msleep(1000);
>  	}

I assume the code was intended to do

	if (i < O2CB_MAP_STABILIZE_COUNT - 1)
		msleep(1000);

to avoid a pointless 1-second delay when the operation times out.
