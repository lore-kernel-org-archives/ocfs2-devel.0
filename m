From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 28 Jul 2010 09:47:53 -0700
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2/dlm: Add message
	DLM_QUERY_HBREGION
In-Reply-To: <20100728162157.GA3411@laptop.jp.oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
	<20100728162157.GA3411@laptop.jp.oracle.com>
Message-ID: <4C505F39.2090706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for your review.

On 07/28/2010 09:21 AM, Wengang Wang wrote:
> Hi Sunil,
>
> Why don't we merge the two new message to the existing DLM_QUERY_JOIN_MSG?
> Because it will become too large?
>    

The two structures are very different. I see no advantage in us merging
the two. Note that these messages are sent only during join. So saving
a message round trip is not worth it.... especially if it means having one
larger message.

> On 10-07-23 16:55, Sunil Mushran wrote:
>    
>>
>> +static int dlm_match_hbregions(struct dlm_ctxt *dlm,
>> +			       struct dlm_query_hbregion *qhb)
>> +{
>> +	char *local = NULL, *remote = qhb->qhb_hbregions;
>> +	char *l, *r;
>> +	int localnr, i, j, foundit;
>> +	int status = 0;
>> +
>> +	if (!o2hb_global_heartbeat_active()) {
>> +		if (qhb->qhb_numregions) {
>> +			mlog(ML_ERROR, "Domain %s: Joining node %d has global "
>> +			     "heartbeat enabled but local node %d does not\n",
>> +			     qhb->qhb_domain, qhb->qhb_node, dlm->node_num);
>> +			status = -EINVAL;
>> +		}
>> +		goto bail;
>> +	}
>> +
>> +	if (o2hb_global_heartbeat_active()&&  !qhb->qhb_numregions) {
>> +		mlog(ML_ERROR, "Domain %s: Local node %d has global "
>> +		     "heartbeat enabled but joining node %d does not\n",
>> +		     qhb->qhb_domain, dlm->node_num, qhb->qhb_node);
>> +		status = -EINVAL;
>> +		goto bail;
>> +	}
>> +
>> +	r = remote;
>> +	for (i = 0; i<  qhb->qhb_numregions; ++i) {
>> +		mlog(ML_NOTICE, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);
>> +		r += O2HB_MAX_REGION_NAME_LEN;
>> +	}
>> +
>> +	local = kmalloc(sizeof(qhb->qhb_hbregions), GFP_KERNEL);
>> +	if (!local) {
>> +		status = -ENOMEM;
>> +		goto bail;
>> +	}
>> +
>> +	localnr = o2hb_get_all_regions(local, O2NM_MAX_HBREGIONS);
>> +
>> +	/* compare local regions with remote */
>> +	l = local;
>> +	for (i = 0; i<  localnr; ++i) {
>> +		foundit = 0;
>> +		r = remote;
>> +		for (j = 0; j<= qhb->qhb_numregions; ++j) {
>> +			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
>> +				foundit = 1;
>> +				break;
>> +			}
>> +			r += O2HB_MAX_REGION_NAME_LEN;
>> +		}
>> +		if (!foundit) {
>> +			status = -EINVAL;
>> +			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
>> +			     "in local node %d but not in joining node %d\n",
>> +			     qhb->qhb_domain, O2HB_MAX_REGION_NAME_LEN, l,
>> +			     dlm->node_num, qhb->qhb_node);
>> +			goto bail;
>> +		}
>> +		l += O2HB_MAX_REGION_NAME_LEN;
>> +	}
>> +
>> +	/* compare remote with local regions */
>> +	r = remote;
>> +	for (i = 0; i<  qhb->qhb_numregions; ++i) {
>> +		foundit = 0;
>> +		l = local;
>> +		for (j = 0; j<  localnr; ++j) {
>> +			if (!memcmp(r, l, O2HB_MAX_REGION_NAME_LEN)) {
>> +				foundit = 1;
>> +				break;
>> +			}
>> +			l += O2HB_MAX_REGION_NAME_LEN;
>> +		}
>> +		if (!foundit) {
>> +			status = -EINVAL;
>> +			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
>> +			     "in joining node %d but not in local node %d\n",
>> +			     qhb->qhb_domain, O2HB_MAX_REGION_NAME_LEN, r,
>> +			     qhb->qhb_node, dlm->node_num);
>> +			goto bail;
>> +		}
>> +		r += O2HB_MAX_REGION_NAME_LEN;
>> +	}
>>      
> Why need to compare again? just checking "qhb->qhb_numregions == localnr" is not
> fine?
>    

Say the remote has hbregions A and B and local has C and A. We want
all the regions to match. And they can be presented in any order. I am just
going with brute force for now. Remember we allow a max of 16 regions.

>> +
>> +bail:
>> +	kfree(local);
>> +
>> +	return status;
>> +}
>> +
>> +static int dlm_send_hbregions(struct dlm_ctxt *dlm, unsigned long *node_map)
>> +{
>> +	struct dlm_query_hbregion *qhb = NULL;
>> +	int status, ret = 0, i;
>> +	char *p;
>> +
>> +	if (find_next_bit(node_map, O2NM_MAX_NODES, 0)>= O2NM_MAX_NODES)
>> +		goto bail;
>> +
>> +	qhb = kmalloc(sizeof(struct dlm_query_hbregion), GFP_KERNEL);
>> +	if (!qhb) {
>> +		ret = -ENOMEM;
>> +		mlog_errno(ret);
>> +		goto bail;
>> +	}
>> +
>> +	memset(qhb, 0, sizeof(struct dlm_query_hbregion));
>> +
>> +	qhb->qhb_node = dlm->node_num;
>> +	qhb->qhb_namelen = strlen(dlm->name);
>> +	memcpy(qhb->qhb_domain, dlm->name, qhb->qhb_namelen);
>> +	/* if local hb, the numregions will be zero */
>> +	if (o2hb_global_heartbeat_active())
>> +		qhb->qhb_numregions = o2hb_get_all_regions(qhb->qhb_hbregions,
>> +							   O2NM_MAX_HBREGIONS);
>> +
>> +	p = qhb->qhb_hbregions;
>> +	for (i = 0; i<  qhb->qhb_numregions; ++i, p += O2HB_MAX_REGION_NAME_LEN)
>> +		mlog(ML_NOTICE, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, p);
>> +
>> +	i = -1;
>> +	while ((i = find_next_bit(node_map, O2NM_MAX_NODES,
>> +				  i + 1))<  O2NM_MAX_NODES) {
>> +		if (i == dlm->node_num)
>> +			continue;
>> +
>> +		mlog(ML_NOTICE, "Sending hbregion to node %d\n", i);
>> +
>>      
> Is this(also the aboves and the belows) NOTICE log needed?
> Guessing you were using them for debug purpose :-P
>    

Yes, it is for debugging for now.

> regards,
> wengang.
>    
>> +		ret = o2net_send_message(DLM_QUERY_HBREGION, DLM_MOD_KEY, qhb,
>> +					 sizeof(struct dlm_query_hbregion),
>> +					 i,&status);
>>      
