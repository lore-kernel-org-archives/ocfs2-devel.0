From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Jul 2010 14:49:36 +0800
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2/dlm: Add message
 DLM_QUERY_NODEINFO
In-Reply-To: <1279929322-9276-9-git-send-email-sunil.mushran@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-9-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100729064936.GD2591@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-23 16:55, Sunil Mushran wrote:
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmcommon.h |   17 ++++
>  fs/ocfs2/dlm/dlmdomain.c |  188 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 204 insertions(+), 1 deletions(-)
> 
> +	for (i = 0; i < O2NM_MAX_NODES && !status; ++i) {
> +		local = o2nm_get_node_by_num(i);
> +		remote = NULL;
> +		for (j = 0; j < qn->qn_numnodes; ++j) {
> +			if (qn->qn_nodes[j].ni_nodenum == i) {
> +				remote = &(qn->qn_nodes[j]);
> +				break;
> +			}
> +		}
> +
> +		if (!local && !remote)
> +			continue;
> +
> +		if ((local && !remote) || (!local && remote))
> +			status = -EINVAL;
> +
> +		if (!status &&
> +		    ((remote->ni_nodenum != local->nd_num) ||

ni_nodenum already checked in the for loop.
> +		     (remote->ni_ipv4_port != local->nd_ipv4_port) ||
> +		     (remote->ni_ipv4_address != local->nd_ipv4_address)))
> +			status = -EINVAL;
> +

> +static int dlm_send_nodeinfo(struct dlm_ctxt *dlm, unsigned long *node_map)
> +{
> +	struct dlm_query_nodeinfo *qn = NULL;
> +	struct o2nm_node *node;
> +	int ret = 0, status, count, i;
> +
> +	if (find_next_bit(node_map, O2NM_MAX_NODES, 0) >= O2NM_MAX_NODES)
> +		goto bail;
> +
> +	qn = kmalloc(sizeof(struct dlm_query_nodeinfo), GFP_KERNEL);
> +	if (!qn) {
> +		ret = -ENOMEM;
> +		mlog_errno(ret);
> +		goto bail;
> +	}
> +
> +	memset(qn, 0, sizeof(struct dlm_query_nodeinfo));

Any reason we are not using kzalloc() here and in dlm_send_hbregions()?

> +	for (i = 0, count = 0; i < O2NM_MAX_NODES; ++i) {
> +		node = o2nm_get_node_by_num(i);
> +		if (!node)
> +			continue;
> +		qn->qn_nodes[count].ni_nodenum = node->nd_num;
> +		qn->qn_nodes[count].ni_ipv4_port = node->nd_ipv4_port;
> +

> +static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
> +				      void *data, void **ret_data)
> +{
> +	struct dlm_query_nodeinfo *qn;
> +	struct dlm_ctxt *dlm = NULL;
> +	int locked = 0, status = 0;
> +
> +	qn = (struct dlm_query_nodeinfo *) msg->buf;
> +
> +	mlog(ML_NOTICE, "Node %u queries nodes on domain %s\n",
> +	     qn->qn_nodenum, qn->qn_domain);
> +
> +	status = -EINVAL;

how about remove this line and

+	int locked = 0, status = -EINVAL;

regards,
wengang.
> +
> +	spin_lock(&dlm_domain_lock);
> +	dlm = __dlm_lookup_domain_full(qn->qn_domain, qn->qn_namelen);
> +	if (!dlm) {
> +		mlog(ML_ERROR, "Node %d queried nodes on domain %s before "
> +		     "join domain\n", qn->qn_nodenum, qn->qn_domain);
> +		goto bail;
> +	}
> +
