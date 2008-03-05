From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 11:12:02 2008
Subject: [Ocfs2-devel] [PATCH 10/12] ocfs2/dlm: Dumps the workqueue
	into a debugfs file
In-Reply-To: <1204678200-26237-11-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
	<1204678200-26237-11-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080305191159.GI799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 04, 2008 at 04:49:58PM -0800, Sunil Mushran wrote:
> This patch dumps all the tasks on the workqueue it can fit in one page
> into a debugfs file. Useful for debugging.
 
> +void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data);
> +void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data);
> +void dlm_assert_master_worker(struct dlm_work_item *item, void *data);
<snip>
> +		if (wi->func == dlm_request_all_locks_worker) {
> +			out += snprintf(db->buf + out, db->len - out,
> +					"RequestAllLocks, "
> +					"recomaster=%d, deadnode=%d\n",
> +					wi->u.ral.reco_master,
> +					wi->u.ral.dead_node);
> +		} else if (wi->func == dlm_mig_lockres_worker) {

	There *has* to be a better way to determine what kind of worker
we have.  De-staticing functions just to compare them is pretty heavy
handed.

Joel

-- 

"Every new beginning comes from some other beginning's end."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
