From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Jul 2010 13:08:37 +0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2/dlm: Add message
 DLM_QUERY_HBREGION
In-Reply-To: <1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-7-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100729050837.GC2591@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

>  static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
>  				   void **ret_data)
>  {
> @@ -1233,6 +1437,15 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
>  	set_bit(dlm->node_num, dlm->domain_map);
>  	spin_unlock(&dlm->spinlock);
>  
> +	/* Support for global heartbeat was added in 1.1 */
> +	if (dlm_protocol.pv_major >= 1 && dlm_protocol.pv_minor > 0) {
> +		status = dlm_send_hbregions(dlm, ctxt->yes_resp_map);
> +		if (status) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +	}
> +

How does the version number grows? Is it possible from 1.1 to 2.0?
If that's possible, should it be

+	if (dlm_protocol.pv_major > 1 || dlm_protocol.pv_minor > 0) {

regards,
wengang.

>  	dlm_send_join_asserts(dlm, ctxt->yes_resp_map);
>  
