From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Jul 2010 13:03:07 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2/dlm: Add message
 DLM_QUERY_HBREGION
In-Reply-To: <4C505F39.2090706@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
	<20100728162157.GA3411@laptop.jp.oracle.com>
	<4C505F39.2090706@oracle.com>
Message-ID: <20100729050307.GB2591@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-28 09:47, Sunil Mushran wrote:
> Thanks for your review.
> 
> On 07/28/2010 09:21 AM, Wengang Wang wrote:
> >Hi Sunil,
> >
> >Why don't we merge the two new message to the existing DLM_QUERY_JOIN_MSG?
> >Because it will become too large?
> 
> The two structures are very different. I see no advantage in us merging
> the two. Note that these messages are sent only during join. So saving
> a message round trip is not worth it.... especially if it means having one
> larger message.

Ok.
> 
> >On 10-07-23 16:55, Sunil Mushran wrote:
> >>
> >>+static int dlm_match_hbregions(struct dlm_ctxt *dlm,
> >>+			       struct dlm_query_hbregion *qhb)
> >>+{
> >>+
> >>+	/* compare local regions with remote */
> >>+	l = local;
> >>+	for (i = 0; i<  localnr; ++i) {
> >>+		foundit = 0;
> >>+		r = remote;
> >>+		for (j = 0; j<= qhb->qhb_numregions; ++j) {
> >>+			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
> >>+				foundit = 1;
> >>+				break;
> >>+			}
> >>+			r += O2HB_MAX_REGION_NAME_LEN;
> >>+		}
> >>+		if (!foundit) {
> >>+			status = -EINVAL;
> >>+			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
> >>+			     "in local node %d but not in joining node %d\n",
> >>+			     qhb->qhb_domain, O2HB_MAX_REGION_NAME_LEN, l,
> >>+			     dlm->node_num, qhb->qhb_node);
> >>+			goto bail;
> >>+		}
> >>+		l += O2HB_MAX_REGION_NAME_LEN;
> >>+	}
> >>+
> >>+	/* compare remote with local regions */
> >>+	r = remote;
> >>+	for (i = 0; i<  qhb->qhb_numregions; ++i) {
> >>+		foundit = 0;
> >>+		l = local;
> >>+		for (j = 0; j<  localnr; ++j) {
> >>+			if (!memcmp(r, l, O2HB_MAX_REGION_NAME_LEN)) {
> >>+				foundit = 1;
> >>+				break;
> >>+			}
> >>+			l += O2HB_MAX_REGION_NAME_LEN;
> >>+		}
> >>+		if (!foundit) {
> >>+			status = -EINVAL;
> >>+			mlog(ML_ERROR, "Domain %s: Region '%.*s' registered "
> >>+			     "in joining node %d but not in local node %d\n",
> >>+			     qhb->qhb_domain, O2HB_MAX_REGION_NAME_LEN, r,
> >>+			     qhb->qhb_node, dlm->node_num);
> >>+			goto bail;
> >>+		}
> >>+		r += O2HB_MAX_REGION_NAME_LEN;
> >>+	}
> >Why need to compare again? just checking "qhb->qhb_numregions == localnr" is not
> >fine?
> 
> Say the remote has hbregions A and B and local has C and A. We want
> all the regions to match. And they can be presented in any order. I am just
> going with brute force for now. Remember we allow a max of 16 regions.

Yes, I can see what you are doing there.
But you are comparing twice. I was emphasising "again" :)
The bhregions is like a collection. we say collection A is equal to
collection B, it can mean the number is equal, and all elements in
collection A are all in collection B. So no need to compare each region
again.

Regards,
wengang.
