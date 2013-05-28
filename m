From: xiaowei.hu <xiaowei.hu@oracle.com>
Date: Tue, 28 May 2013 14:12:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: resend master request when lost
 connection with someone
In-Reply-To: <50D55A91.3090809@huawei.com>
References: <50D55A91.3090809@huawei.com>
Message-ID: <51A44ACD.3000703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I reviewed this patch , it did could fix a temp lost connection problem, 
but a few questions:

1. since we don't need to know the node numbers of down nodes, if simply 
replace the down_nodemap[BITS_TO_LONGS(O2NM_MAX_NODES)], with a int 
named for example mreq_msg_send_fail ?

2.since the final work is to return -EAGAIN, the resend all master 
requests. How about we simply do this?:

  	while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
  		ret = dlm_do_master_request(res, mle, nodenum);
-		if (ret < 0)
+		if (ret < 0) {
  			mlog_errno(ret);
+			wait_on_recovery = 1;
+			msleep(DLM_NODE_DEATH_WAIT_MAX);
+			goto redo_request;
+		}

Am I missing something?

Thanks,
Xiaowei

On 12/22/2012 03:00 PM, Xue jiufei wrote:
>    Function dlm_get_lock_resource() sends master request to all nodes in
> domain_map and waits for their responses when the node(say nodeA) doesn't
> known who the master is.
>    When nodeA sends the master request, it happened that network of
> nodeB down for a while, and then restore. The master request
> from nodeA does not reach nodeB. NodeA may wait again and again in
> dlm_wait_for_lock_mastery() and never returns.
>    This patch resend the mater request when a node lost connection with
> some other nodes.
>
> Signed-off-by: xuejiufei <xuejiufei@huawei.com>
> ---
>   fs/ocfs2/dlm/dlmmaster.c |   41 +++++++++++++++++++++++++++++++++++------
>   1 files changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index c491f97..2a99a95 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -106,7 +106,7 @@ static int dlm_do_master_request(struct dlm_lock_resource *res,
>   static int dlm_wait_for_lock_mastery(struct dlm_ctxt *dlm,
>   				     struct dlm_lock_resource *res,
>   				     struct dlm_master_list_entry *mle,
> -				     int *blocked);
> +				     int *blocked, int *retry, int host_down);
>   static int dlm_restart_lock_mastery(struct dlm_ctxt *dlm,
>   				    struct dlm_lock_resource *res,
>   				    struct dlm_master_list_entry *mle,
> @@ -712,6 +712,8 @@ struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
>   	unsigned int hash;
>   	int tries = 0;
>   	int bit, wait_on_recovery = 0;
> +	int retry = 0;
> +	unsigned long down_nodemap[BITS_TO_LONGS(O2NM_MAX_NODES)];
>   
>   	BUG_ON(!lockid);
>   
> @@ -910,11 +912,25 @@ redo_request:
>   		goto wait;
>   
>   	ret = -EINVAL;
> -	dlm_node_iter_init(mle->vote_map, &iter);
> +	if (!retry)
> +		dlm_node_iter_init(mle->vote_map, &iter);
> +	else {
> +		mlog(0, "%s:%.*s: retrying, send master request to maybe down node\n",
> +				dlm->name, res->lockname.len, res->lockname.name);
> +		dlm_node_iter_init(down_nodemap, &iter);
> +	}
> +	memset(down_nodemap, 0, sizeof(down_nodemap));
> +
>   	while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
>   		ret = dlm_do_master_request(res, mle, nodenum);
> -		if (ret < 0)
> +		if (ret < 0) {
>   			mlog_errno(ret);
> +			if (dlm_is_host_down(ret)) {
> +				mlog(0, "%s:%.*s: node %u maybe dead, set down_nodemap\n",
> +						dlm->name, res->lockname.len, res->lockname.name, nodenum);
> +				set_bit(nodenum, down_nodemap);
> +			}
> +		}
>   		if (mle->master != O2NM_MAX_NODES) {
>   			/* found a master ! */
>   			if (mle->master <= nodenum)
> @@ -931,9 +947,11 @@ redo_request:
>   
>   wait:
>   	/* keep going until the response map includes all nodes */
> -	ret = dlm_wait_for_lock_mastery(dlm, res, mle, &blocked);
> +	ret = dlm_wait_for_lock_mastery(dlm, res, mle, &blocked, &retry,
> +			find_next_bit(down_nodemap, O2NM_MAX_NODES, 0) < O2NM_MAX_NODES);
>   	if (ret < 0) {
> -		wait_on_recovery = 1;
> +		if (!retry)
> +			wait_on_recovery = 1;
>   		mlog(0, "%s: res %.*s, Node map changed, redo the master "
>   		     "request now, blocked=%d\n", dlm->name, res->lockname.len,
>   		     res->lockname.name, blocked);
> @@ -980,7 +998,7 @@ leave:
>   static int dlm_wait_for_lock_mastery(struct dlm_ctxt *dlm,
>   				     struct dlm_lock_resource *res,
>   				     struct dlm_master_list_entry *mle,
> -				     int *blocked)
> +				     int *blocked, int *retry, int host_down)
>   {
>   	u8 m;
>   	int ret, bit;
> @@ -990,6 +1008,7 @@ static int dlm_wait_for_lock_mastery(struct dlm_ctxt *dlm,
>   recheck:
>   	ret = 0;
>   	assert = 0;
> +	*retry = 0;
>   
>   	/* check if another node has already become the owner */
>   	spin_lock(&res->spinlock);
> @@ -1043,6 +1062,16 @@ recheck:
>   		     res->lockname.name);
>   		goto recheck;
>   	} else {
> +		if (host_down && (m == O2NM_MAX_NODES)) {
> +			mlog(0, "map not changed but some one may lost connection, "
> +					"rechecking\n");
> +			*retry = 1;
> +			spin_unlock(&mle->spinlock);
> +			msleep(DLM_NODE_DEATH_WAIT_MAX);
> +			ret = -EAGAIN;
> +			goto leave;
> +		}
> +
>   		if (!voting_done) {
>   			mlog(0, "map not changed and voting not done "
>   			     "for %s:%.*s\n", dlm->name, res->lockname.len,
