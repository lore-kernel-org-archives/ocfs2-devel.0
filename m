From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 15 Jun 2010 22:00:44 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: check dlm_state under spinlock
In-Reply-To: <201006160409.o5G1dABa012133@acsinet15.oracle.com>
References: <201006160409.o5G1dABa012133@acsinet15.oracle.com>
Message-ID: <4C185A7C.1050601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The lock order in this code causes dead lock, not caused by your patch. 
The lock order in dlm_query_join_handler is

dlm_domain_lock
    ->dlm->spinlock

dead locks with ..

dlm_lockres_put calls dlm_lockres_release while holding dlm->spinlock 
which calls dlm_put which gets dlm_domain_lock. So the spin lock order 
here is
dlm->spinlock
    -> dlm_domain_lock


On 6/15/2010 9:08 PM, Wengang Wang wrote:
> We should check dlm->dlm_state under dlm->spinlock though maybe in this case it
> doesn't hurt.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmdomain.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 6b5a492..ab82add 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -796,7 +796,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  	spin_lock(&dlm_domain_lock);
>  	dlm = __dlm_lookup_domain_full(query->domain, query->name_len);
>  	if (!dlm)
> -		goto unlock_respond;
> +		goto unlock_domain_respond;
>  
>  	/*
>  	 * There is a small window where the joining node may not see the
> @@ -811,7 +811,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  				     "have node %u in its nodemap\n",
>  				     query->node_idx, nodenum);
>  				packet.code = JOIN_DISALLOW;
> -				goto unlock_respond;
> +				goto unlock_domain_respond;
>  			}
>  		}
>  		nodenum++;
> @@ -821,9 +821,9 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  	 * to be put in someone's domain map.
>  	 * Also, explicitly disallow joining at certain troublesome
>  	 * times (ie. during recovery). */
> -	if (dlm && dlm->dlm_state != DLM_CTXT_LEAVING) {
> +	spin_lock(&dlm->spinlock);
> +	if (dlm->dlm_state != DLM_CTXT_LEAVING) {
>  		int bit = query->node_idx;
> -		spin_lock(&dlm->spinlock);
>  
>  		if (dlm->dlm_state == DLM_CTXT_NEW &&
>  		    dlm->joining_node == DLM_LOCK_RES_OWNER_UNKNOWN) {
> @@ -869,10 +869,9 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  				__dlm_set_joining_node(dlm, query->node_idx);
>  			}
>  		}
> -
> -		spin_unlock(&dlm->spinlock);
>  	}
> -unlock_respond:
> +	spin_unlock(&dlm->spinlock);
> +unlock_domain_respond:
>  	spin_unlock(&dlm_domain_lock);
>  
>  respond:
>   
