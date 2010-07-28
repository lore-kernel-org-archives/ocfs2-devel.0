From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Jul 2010 00:21:57 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2/dlm: Add message
 DLM_QUERY_HBREGION
In-Reply-To: <1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100728162157.GA3411@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

Why don't we merge the two new message to the existing DLM_QUERY_JOIN_MSG?
Because it will become too large?

On 10-07-23 16:55, Sunil Mushran wrote:
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/ocfs2_nodemanager.h |    2 +
>  fs/ocfs2/dlm/dlmcommon.h             |   12 ++-
>  fs/ocfs2/dlm/dlmdomain.c             |  222 +++++++++++++++++++++++++++++++++-
>  3 files changed, 234 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/ocfs2_nodemanager.h b/fs/ocfs2/cluster/ocfs2_nodemanager.h
> index 5b9854b..1829c01 100644
> --- a/fs/ocfs2/cluster/ocfs2_nodemanager.h
> +++ b/fs/ocfs2/cluster/ocfs2_nodemanager.h
> @@ -36,4 +36,6 @@
>  /* host name, group name, cluster name all 64 bytes */
>  #define O2NM_MAX_NAME_LEN        64    // __NEW_UTS_LEN
>  
> +#define O2NM_MAX_HBREGIONS	16
> +
>  #endif /* _OCFS2_NODEMANAGER_H */
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index a13292a..2c05138 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -445,7 +445,8 @@ enum {
>  	DLM_LOCK_REQUEST_MSG,	 /* 515 */
>  	DLM_RECO_DATA_DONE_MSG,	 /* 516 */
>  	DLM_BEGIN_RECO_MSG,	 /* 517 */
> -	DLM_FINALIZE_RECO_MSG	 /* 518 */
> +	DLM_FINALIZE_RECO_MSG,	 /* 518 */
> +	DLM_QUERY_HBREGION,	 /* 519 */
>  };
>  
>  struct dlm_reco_node_data
> @@ -727,6 +728,15 @@ struct dlm_cancel_join
>  	u8 domain[O2NM_MAX_NAME_LEN];
>  };
>  
> +struct dlm_query_hbregion {
> +	u8 qhb_node;
> +	u8 qhb_numregions;
> +	u8 qhb_namelen;
> +	u8 pad1;
> +	u8 qhb_domain[O2NM_MAX_NAME_LEN];
> +	u8 qhb_hbregions[O2HB_MAX_REGION_NAME_LEN * O2NM_MAX_HBREGIONS];
> +};
> +
>  struct dlm_exit_domain
>  {
>  	u8 node_idx;
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 2408b9f..3521a00 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -128,10 +128,13 @@ static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
>   * will have a negotiated version with the same major number and a minor
>   * number equal or smaller.  The dlm_ctxt->dlm_locking_proto field should
>   * be used to determine what a running domain is actually using.
> + *
> + * New in version 1.1:
> + *	- Message DLM_QUERY_HBREGION added to support global heartbeat
>   */
>  static const struct dlm_protocol_version dlm_protocol = {
>  	.pv_major = 1,
> -	.pv_minor = 0,
> +	.pv_minor = 1,
>  };
>  
>  #define DLM_DOMAIN_BACKOFF_MS 200
> @@ -142,6 +145,8 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
>  				     void **ret_data);
>  static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  				   void **ret_data);
> +static int dlm_query_hbregion_handler(struct o2net_msg *msg, u32 len,
> +				      void *data, void **ret_data);
>  static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
>  				   void **ret_data);
>  static int dlm_protocol_compare(struct dlm_protocol_version *existing,
> @@ -918,6 +923,205 @@ static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
>  	return 0;
>  }
>  
> +static int dlm_match_hbregions(struct dlm_ctxt *dlm,
> +			       struct dlm_query_hbregion *qhb)
> +{
> +	char *local = NULL, *remote = qhb->qhb_hbregions;
> +	char *l, *r;
> +	int localnr, i, j, foundit;
> +	int status = 0;
> +
> +	if (!o2hb_global_heartbeat_active()) {
> +		if (qhb->qhb_numregions) {
> +			mlog(ML_ERROR, "Domain %s: Joining node %d has global "
> +			     "heartbeat enabled but local node %d does not\n",
> +			     qhb->qhb_domain, qhb->qhb_node, dlm->node_num);
> +			status = -EINVAL;
> +		}
> +		goto bail;
> +	}
> +
> +	if (o2hb_global_heartbeat_active() && !qhb->qhb_numregions) {
> +		mlog(ML_ERROR, "Domain %s: Local node %d has global "
> +		     "heartbeat enabled but joining node %d does not\n",
> +		     qhb->qhb_domain, dlm->node_num, qhb->qhb_node);
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
> +	r = remote;
> +	for (i = 0; i < qhb->qhb_numregions; ++i) {
> +		mlog(ML_NOTICE, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);
> +		r += O2HB_MAX_REGION_NAME_LEN;
> +	}
> +
> +	local = kmalloc(sizeof(qhb->qhb_hbregions), GFP_KERNEL);
> +	if (!local) {
> +		status = -ENOMEM;
> +		goto bail;
> +	}
> +
> +	localnr = o2hb_get_all_regions(local, O2NM_MAX_HBREGIONS);
> +
> +	/* compare local regions with remote */
> +	l = local;
> +	for (i = 0; i < localnr; ++i) {
> +		foundit = 0;
> +		r = remote;
> +		for (j = 0; j <= qhb->qhb_numregions; ++j) {
> +			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
> +				foundit = 1;
> +				break;
> +			}
> +			r += O2HB_MAX_REGION_NAME_LEN;
> +		}
> +		if (!foundit) {
> +			status = -EINVAL;
> +			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
> +			     "in local node %d but not in joining node %d\n",
> +			     qhb->qhb_domain, O2HB_MAX_REGION_NAME_LEN, l,
> +			     dlm->node_num, qhb->qhb_node);
> +			goto bail;
> +		}
> +		l += O2HB_MAX_REGION_NAME_LEN;
> +	}
> +
> +	/* compare remote with local regions */
> +	r = remote;
> +	for (i = 0; i < qhb->qhb_numregions; ++i) {
> +		foundit = 0;
> +		l = local;
> +		for (j = 0; j < localnr; ++j) {
> +			if (!memcmp(r, l, O2HB_MAX_REGION_NAME_LEN)) {
> +				foundit = 1;
> +				break;
> +			}
> +			l += O2HB_MAX_REGION_NAME_LEN;
> +		}
> +		if (!foundit) {
> +			status = -EINVAL;
> +			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
> +			     "in joining node %d but not in local node %d\n",
> +			     qhb->qhb_domain, O2HB_MAX_REGION_NAME_LEN, r,
> +			     qhb->qhb_node, dlm->node_num);
> +			goto bail;
> +		}
> +		r += O2HB_MAX_REGION_NAME_LEN;
> +	}

Why need to compare again? just checking "qhb->qhb_numregions == localnr" is not
fine?

> +
> +bail:
> +	kfree(local);
> +
> +	return status;
> +}
> +
> +static int dlm_send_hbregions(struct dlm_ctxt *dlm, unsigned long *node_map)
> +{
> +	struct dlm_query_hbregion *qhb = NULL;
> +	int status, ret = 0, i;
> +	char *p;
> +
> +	if (find_next_bit(node_map, O2NM_MAX_NODES, 0) >= O2NM_MAX_NODES)
> +		goto bail;
> +
> +	qhb = kmalloc(sizeof(struct dlm_query_hbregion), GFP_KERNEL);
> +	if (!qhb) {
> +		ret = -ENOMEM;
> +		mlog_errno(ret);
> +		goto bail;
> +	}
> +
> +	memset(qhb, 0, sizeof(struct dlm_query_hbregion));
> +
> +	qhb->qhb_node = dlm->node_num;
> +	qhb->qhb_namelen = strlen(dlm->name);
> +	memcpy(qhb->qhb_domain, dlm->name, qhb->qhb_namelen);
> +	/* if local hb, the numregions will be zero */
> +	if (o2hb_global_heartbeat_active())
> +		qhb->qhb_numregions = o2hb_get_all_regions(qhb->qhb_hbregions,
> +							   O2NM_MAX_HBREGIONS);
> +
> +	p = qhb->qhb_hbregions;
> +	for (i = 0; i < qhb->qhb_numregions; ++i, p += O2HB_MAX_REGION_NAME_LEN)
> +		mlog(ML_NOTICE, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, p);
> +
> +	i = -1;
> +	while ((i = find_next_bit(node_map, O2NM_MAX_NODES,
> +				  i + 1)) < O2NM_MAX_NODES) {
> +		if (i == dlm->node_num)
> +			continue;
> +
> +		mlog(ML_NOTICE, "Sending hbregion to node %d\n", i);
> +

Is this(also the aboves and the belows) NOTICE log needed?
Guessing you were using them for debug purpose :-P

regards,
wengang.
> +		ret = o2net_send_message(DLM_QUERY_HBREGION, DLM_MOD_KEY, qhb,
> +					 sizeof(struct dlm_query_hbregion),
> +					 i, &status);
