From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 1 Jul 2013 15:59:46 -0700
Subject: [Ocfs2-devel] [RESENT PATCH 3/4] ocfs2: fix a comments typo at
 o2quo_hb_still_up()
In-Reply-To: <51CE5C0A.7030105@oracle.com>
References: <51CE5C0A.7030105@oracle.com>
Message-ID: <20130701225946.GD965@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jun 29, 2013 at 12:01:14PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Fix a comments typo at o2quo_hb_still_up()
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/cluster/quorum.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
> index c19897d..1ec141e 100644
> --- a/fs/ocfs2/cluster/quorum.c
> +++ b/fs/ocfs2/cluster/quorum.c
> @@ -264,7 +264,7 @@ void o2quo_hb_still_up(u8 node)
>  /* This is analogous to hb_up.  as a node's connection comes up we delay the
>   * quorum decision until we see it heartbeating.  the hold will be droped in
>   * hb_up or hb_down.  it might be perpetuated by con_err until hb_down.  if
> - * it's already heartbeating we we might be dropping a hold that conn_up got.
> + * it's already heartbeating we might be dropping a hold that conn_up got.
>   * */
>  void o2quo_conn_up(u8 node)
>  {
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

			http://www.jlbec.org/
			jlbec at evilplan.org
