From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 17:11:36 2008
Subject: [Ocfs2-devel] [PATCH 13/18] ocfs2_dlm: Dumps the workqueue
	into a debugfs file
In-Reply-To: <1203970862-8790-14-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-14-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229011050.GE17860@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:57PM -0800, Sunil Mushran wrote:
> This patch dumps all the tasks on the workqueue it can fit in one page
> into a debugfs file. Useful for debugging.

	Check the warnings from checkpatch.pl.  I'm not sure if they're
worth fixing, but have a look.

Joel

> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/dlm/dlmdebug.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmdebug.h |    1 +
>  2 files changed, 94 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index ffdc976..1864731 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -708,6 +708,7 @@ EXPORT_SYMBOL_GPL(dlm_errname);
>  #define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
>  #define DLM_DEBUGFS_MLE_STATE			"mle_state"
>  #define DLM_DEBUGFS_PURGE_LIST			"purge_list"
> +#define DLM_DEBUGFS_WORK_QUEUE			"work_queue"
>  
>  /* NOTE: This function converts a lockname into a string. It uses knowledge
>   * of the format of the lockname that should be outside the purview of the dlm.
> @@ -829,6 +830,85 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
>  }
>  /* end - util funcs */
>  
> +/* begin - work queue funcs */
> +static int debug_workqueue_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
> +{
> +	struct dlm_work_item *wi;
> +	int out = 0;
> +	unsigned long total = 0;
> +
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Dumping Workqueue for Domain: %s\n", dlm->name);
> +
> +	spin_lock(&dlm->work_lock);
> +	list_for_each_entry(wi, &dlm->work_list, list) {
> +		++total;
> +		if (db->len - out < 100)
> +			continue;
> +		if (wi->func == dlm_request_all_locks_worker) {
> +			out += snprintf(db->buf + out, db->len - out,
> +					"RequestAllLocks, "
> +					"recomaster=%d, deadnode=%d\n",
> +					wi->u.ral.reco_master,
> +					wi->u.ral.dead_node);
> +		} else if (wi->func == dlm_mig_lockres_worker) {
> +			out += snprintf(db->buf + out, db->len - out,
> +					"MigrateLockres,  ");
> +			out += stringify_lockname(wi->u.ml.lockres->lockname.name,
> +						  wi->u.ml.lockres->lockname.len,
> +						  db->buf + out, db->len - out);
> +			out += snprintf(db->buf + out, db->len - out,
> +					"  master=%d\n", wi->u.ml.real_master);
> +		} else if (wi->func == dlm_assert_master_worker) {
> +			out += snprintf(db->buf + out, db->len - out,
> +					"AssertMaster, ");
> +			out += stringify_lockname(wi->u.am.lockres->lockname.name,
> +						  wi->u.am.lockres->lockname.len,
> +						  db->buf + out, db->len - out);
> +			out += snprintf(db->buf + out, db->len - out,
> +					" from=%d, flags=0x%X, ignore=%d\n",
> +					wi->u.am.request_from,
> +					wi->u.am.flags,
> +					wi->u.am.ignore_higher);
> +		} else {
> +			out += snprintf(db->buf + out, db->len - out,
> +					"Unknown, 0x%p\n", wi->func);
> +		}
> +	}
> +	spin_unlock(&dlm->work_lock);
> +
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Total on list: %ld\n", total);
> +
> +	return out;
> +}
> +
> +static int debug_workqueue_open(struct inode *inode, struct file *file)
> +{
> +	struct dlm_ctxt *dlm = inode->i_private;
> +	struct debug_buffer *db;
> +
> +	db = debug_buffer_allocate();
> +	if (!db)
> +		goto bail;
> +
> +	db->len = debug_workqueue_print(dlm, db);
> +
> +	file->private_data = db;
> +
> +	return 0;
> +bail:
> +	return -ENOMEM;
> +}
> +
> +static struct file_operations debug_workqueue_fops = {
> +	.open =		debug_workqueue_open,
> +	.release =	debug_buffer_release,
> +	.read =		debug_buffer_read,
> +	.llseek =	debug_buffer_llseek,
> +};
> +/* end - work queue funcs */
> +
>  /* begin - purge list funcs */
>  static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
>  {
> @@ -1408,6 +1488,17 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
>  		goto bail;
>  	}
>  
> +	/* for dumping the dlm work queue */
> +	dc->debug_workqueue_dentry =
> +			debugfs_create_file(DLM_DEBUGFS_WORK_QUEUE,
> +					    S_IFREG|S_IRUSR,
> +					    dlm->dlm_debugfs_subroot,
> +					    dlm, &debug_workqueue_fops);
> +	if (!dc->debug_workqueue_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
>  	dlm_debug_get(dc);
>  	return 0;
>  
> @@ -1421,6 +1512,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
>  	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
>  
>  	if (dc) {
> +		if (dc->debug_workqueue_dentry)
> +			debugfs_remove(dc->debug_workqueue_dentry);
>  		if (dc->debug_purgelist_dentry)
>  			debugfs_remove(dc->debug_purgelist_dentry);
>  		if (dc->debug_mle_dentry)
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> index ca7bc32..fcc19c8 100644
> --- a/fs/ocfs2/dlm/dlmdebug.h
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -31,6 +31,7 @@ struct dlm_debug_ctxt {
>  	struct dentry *debug_lockres_dentry;
>  	struct dentry *debug_mle_dentry;
>  	struct dentry *debug_purgelist_dentry;
> +	struct dentry *debug_workqueue_dentry;
>  };
>  
>  struct debug_buffer
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

 There are morethings in heaven and earth, Horatio,
 Than are dreamt of in your philosophy.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
