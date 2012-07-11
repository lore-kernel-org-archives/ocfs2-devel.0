From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 11 Jul 2012 01:51:21 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: break useless while loop
In-Reply-To: <1341989396-19598-1-git-send-email-junxiao.bi@oracle.com>
References: <1341989396-19598-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20120711085120.GE30630@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 11, 2012 at 02:49:56PM +0800, Junxiao Bi wrote:
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 005261c..1fadc39 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -1888,8 +1888,10 @@ ok:
>  			 * up nodes that this node contacted */
>  			while ((nn = find_next_bit (mle->response_map, O2NM_MAX_NODES,
>  						    nn+1)) < O2NM_MAX_NODES) {
> -				if (nn != dlm->node_num && nn != assert->node_idx)
> +				if (nn != dlm->node_num && nn != assert->node_idx) {
>  					master_request = 1;
> +					break;
> +				}

	Seems like this will save a tiny bit of CPU in the assert master
handler.  Sunil, can you see any problem?

Joel

>  			}
>  		}
>  		mle->master = assert->node_idx;
> -- 
> 1.7.9.5
> 

-- 

"To announce that there must be no criticism of them president, or
 that we are to stand by the president, right or wrong, is not only
 unpatriotic and servile, but is morally treasonable to the American
 public."
	- Theodore Roosevelt

			http://www.jlbec.org/
			jlbec at evilplan.org
