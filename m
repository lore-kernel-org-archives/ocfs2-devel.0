From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 14 Aug 2012 23:37:41 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: break useless while loop
In-Reply-To: <1341989396-19598-1-git-send-email-junxiao.bi@oracle.com>
References: <1341989396-19598-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20120815063741.GB31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 11, 2012 at 02:49:56PM +0800, Junxiao Bi wrote:
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

This patch is now part of the fixes branch of ocfs2.git.

Joel

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
>  			}
>  		}
>  		mle->master = assert->node_idx;
> -- 
> 1.7.9.5
> 

-- 

"I think it would be a good idea."  
        - Mahatma Ghandi, when asked what he thought of Western
          civilization

			http://www.jlbec.org/
			jlbec at evilplan.org
