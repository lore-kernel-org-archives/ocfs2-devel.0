From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 16:38:43 2008
Subject: [Ocfs2-devel] [PATCH 08/18] ocfs2_dlm: Dump the dlm state in a
	debugfs file
In-Reply-To: <1203970862-8790-9-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-9-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229003746.GK23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:52PM -0800, Sunil Mushran wrote:
> This patch dumps the dlm state (dlm_ctxt) into a debugfs file.
> Useful for debugging.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	Also needs CONFIG_DEBUG_FS handling.

Joel

> ---
>  fs/ocfs2/dlm/dlmcommon.h |    1 +
>  fs/ocfs2/dlm/dlmdebug.c  |  297 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmdebug.h  |   14 ++
>  fs/ocfs2/dlm/dlmdomain.c |    8 ++
>  4 files changed, 320 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 810e9b4..a2cfd61 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -125,6 +125,7 @@ struct dlm_ctxt
>  	atomic_t remote_resources;
>  	atomic_t unknown_resources;
>  
> +	struct dlm_debug_ctxt *dlm_debug_ctxt;
>  	struct dentry *dlm_debugfs_subroot;
>  
>  	/* NOTE: Next three are protected by dlm_domain_lock */
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index baa8e24..83f3ac6 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -704,6 +704,296 @@ const char *dlm_errname(enum dlm_status err)
>  EXPORT_SYMBOL_GPL(dlm_errname);
>  
>  #define DLM_DEBUGFS_DIR				"o2dlm"
> +#define DLM_DEBUGFS_DLM_STATE			"dlm_state"
> +
> +/* begin - utils funcs */
> +static void dlm_debug_free(struct kref *kref)
> +{
> +	struct dlm_debug_ctxt *dc;
> +
> +	dc = container_of(kref, struct dlm_debug_ctxt, debug_refcnt);
> +
> +	kfree(dc);
> +}
> +
> +void dlm_debug_put(struct dlm_debug_ctxt *dc)
> +{
> +	if (dc)
> +		kref_put(&dc->debug_refcnt, dlm_debug_free);
> +}
> +
> +static void dlm_debug_get(struct dlm_debug_ctxt *dc)
> +{
> +	kref_get(&dc->debug_refcnt);
> +}
> +
> +static int stringify_nodemap(unsigned long *nodemap, int maxnodes,
> +			     char *buf, int len)
> +{
> +	int out = 0;
> +	int i = -1;
> +
> +	while ((i = find_next_bit(nodemap, maxnodes, i + 1)) < maxnodes)
> +		out += snprintf(buf + out, len - out, "%d ", i);
> +
> +	return out;
> +}
> +
> +static struct debug_buffer *debug_buffer_allocate(void)
> +{
> +	struct debug_buffer *db = NULL;
> +
> +	db = kzalloc(sizeof(struct debug_buffer), GFP_KERNEL);
> +	if (!db)
> +		goto bail;
> +
> +	db->len = PAGE_SIZE;
> +	db->buf = kmalloc(db->len, GFP_KERNEL);
> +	if (!db->buf)
> +		goto bail;
> +
> +	return db;
> +bail:
> +	if (db)
> +		kfree(db);
> +	return NULL;
> +}
> +
> +static ssize_t debug_buffer_read(struct file *file, char __user *buf,
> +				 size_t nbytes, loff_t *ppos)
> +{
> +	struct debug_buffer *db = file->private_data;
> +
> +	return simple_read_from_buffer(buf, nbytes, ppos, db->buf, db->len);
> +}
> +
> +static loff_t debug_buffer_llseek(struct file *file, loff_t off, int whence)
> +{
> +	struct debug_buffer *db = file->private_data;
> +	loff_t new = -1;
> +
> +	switch (whence) {
> +	case 0:
> +		new = off;
> +		break;
> +	case 1:
> +		new = file->f_pos + off;
> +		break;
> +	}
> +
> +	if (new < 0 || new > db->len)
> +		return -EINVAL;
> +
> +	return (file->f_pos = new);
> +}
> +
> +static int debug_buffer_release(struct inode *inode, struct file *file)
> +{
> +	struct debug_buffer *db = (struct debug_buffer *)file->private_data;
> +
> +	if (db && db->buf)
> +		kfree(db->buf);
> +	if (db)
> +		kfree(db);
> +
> +	return 0;
> +}
> +/* end - util funcs */
> +
> +/* begin - debug state funcs */
> +static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
> +{
> +	int out = 0;
> +	struct dlm_reco_node_data *node;
> +	char *state;
> +	int lres, rres, ures, tres;
> +
> +	lres = atomic_read(&dlm->local_resources);
> +	rres = atomic_read(&dlm->remote_resources);
> +	ures = atomic_read(&dlm->unknown_resources);
> +	tres = lres + rres + ures;
> +
> +	spin_lock(&dlm->spinlock);
> +
> +	switch (dlm->dlm_state) {
> +	case DLM_CTXT_NEW:
> +		state = "New"; break;
> +	case DLM_CTXT_JOINED:
> +		state = "Joined"; break;
> +	case DLM_CTXT_IN_SHUTDOWN:
> +		state = "Shutdown"; break;
> +	case DLM_CTXT_LEAVING:
> +		state = "Leaving"; break;
> +	default:
> +		state = "Unknown"; break;
> +	}
> +
> +	/* Domain: xxxxxxxxxx  Key: 0xdfbac769 */ 
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Domain: %s  Key: 0x%08x\n", dlm->name, dlm->key);
> +
> +	/* Thread Pid: xxx  Node: xxx  State: xxxxx */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Thread Pid: %d  Node: %d  State: %s\n",
> +			dlm->dlm_thread_task->pid, dlm->node_num, state);
> +
> +	/* Number of Joins: xxx  Joining Node: xxx */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Number of Joins: %d  Joining Node: %d\n",
> +		        dlm->num_joins, dlm->joining_node);
> +
> +	/* Domain Map: xx, xx, xx, */
> +	out += snprintf(db->buf + out, db->len - out, "Domain Map: ");
> +	out += stringify_nodemap(dlm->domain_map, O2NM_MAX_NODES,
> +				 db->buf + out, db->len - out);
> +	out += snprintf(db->buf + out, db->len - out, "\n");
> +
> +	/* Live Map: xx, xx, xx, */
> +	out += snprintf(db->buf + out, db->len - out, "Live Map: ");
> +	out += stringify_nodemap(dlm->live_nodes_map, O2NM_MAX_NODES,
> +				 db->buf + out, db->len - out);
> +	out += snprintf(db->buf + out, db->len - out, "\n");
> +
> +	/* Mastered Resources Total: xxx  Locally: xxx  Remotely: xxx  Unknown: xxx */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Mastered Resources Total: %d  Locally: %d  "
> +			"Remotely: %d  Unknown: %d\n",
> +			tres, lres, rres, ures);
> +
> +	/* Empty Lists: Dirty=No  Purge=Yes  PendingASTs=No  PendingBASTs=Yes  Master=No */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Empty Lists: Dirty=%s  Purge=%s  PendingASTs=%s  "
> +			"PendingBASTs=%s  Master=%s\n",
> +			(list_empty(&dlm->dirty_list) ? "Yes" : "No"),
> +			(list_empty(&dlm->purge_list) ? "Yes" : "No"),
> +			(list_empty(&dlm->pending_asts) ? "Yes" : "No"),
> +			(list_empty(&dlm->pending_basts) ? "Yes" : "No"),
> +			(list_empty(&dlm->master_list) ? "Yes" : "No"));
> +
> +	/* Purge Count: xxx  Refs: xxx */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Purge Count: %d  Refs: %d\n", dlm->purge_count,
> +			atomic_read(&dlm->dlm_refs.refcount));
> +
> +	/* Dead Node: xxx */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Dead Node: %d\n", dlm->reco.dead_node);
> +
> +	/* What about DLM_RECO_STATE_FINALIZE? */
> +	if (dlm->reco.state == DLM_RECO_STATE_ACTIVE)
> +		state = "Active";
> +	else
> +		state = "Inactive";
> +
> +	/* Recovery Pid: xxxx  Master: xxx  State: xxxx */
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Recovery Pid: %d  Master: %d  State: %s\n",
> +			dlm->dlm_reco_thread_task->pid,
> +			dlm->reco.new_master, state);
> +
> +	/* Recovery Map: xx, xx, */
> +	out += snprintf(db->buf + out, db->len - out, "Recovery Map: ");
> +	out += stringify_nodemap(dlm->recovery_map, O2NM_MAX_NODES,
> +				 db->buf + out, db->len - out);
> +	out += snprintf(db->buf + out, db->len - out, "\n");
> +
> +	/* Recovery Node State: */
> +	out += snprintf(db->buf + out, db->len - out, "Recovery Node State:\n");
> +	list_for_each_entry(node, &dlm->reco.node_data, list) {
> +		switch (node->state) {
> +			case DLM_RECO_NODE_DATA_INIT:
> +				state = "Init";
> +				break;
> +			case DLM_RECO_NODE_DATA_REQUESTING:
> +				state = "Requesting";
> +				break;
> +			case DLM_RECO_NODE_DATA_DEAD:
> +				state = "Dead";
> +				break;
> +			case DLM_RECO_NODE_DATA_RECEIVING:
> +				state = "Receiving";
> +				break;
> +			case DLM_RECO_NODE_DATA_REQUESTED:
> +				state = "Requested";
> +				break;
> +			case DLM_RECO_NODE_DATA_DONE:
> +				state = "Done";
> +				break;
> +			case DLM_RECO_NODE_DATA_FINALIZE_SENT:
> +				state = "Finalize-Sent";
> +				break;
> +			default:
> +				state = "Bad";
> +				break;
> +		}
> +		out += snprintf(db->buf + out, db->len - out, "\t%u - %s\n",
> +				node->node_num, state);
> +	}
> +
> +	spin_unlock(&dlm->spinlock);
> +
> +	return out;
> +}
> +
> +static int debug_state_open(struct inode *inode, struct file *file)
> +{
> +	struct dlm_ctxt *dlm = inode->i_private;
> +	struct debug_buffer *db = NULL;
> +
> +	db = debug_buffer_allocate();
> +	if (!db)
> +		goto bail;
> +
> +	db->len = debug_state_print(dlm, db);
> +
> +	file->private_data = db;
> +
> +	return 0;
> +bail:
> +	return -ENOMEM;
> +}
> +
> +static struct file_operations debug_state_fops = {
> +	.open =		debug_state_open,
> +	.release =	debug_buffer_release,
> +	.read =		debug_buffer_read,
> +	.llseek =	debug_buffer_llseek,
> +};
> +/* end  - debug state funcs */
> +
> +/* files in subroot */
> +int dlm_debug_init(struct dlm_ctxt *dlm)
> +{
> +	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
> +
> +	/* for dumping dlm_ctxt */
> +	dc->debug_state_dentry = debugfs_create_file(DLM_DEBUGFS_DLM_STATE,
> +						     S_IFREG|S_IRUSR,
> +						     dlm->dlm_debugfs_subroot,
> +						     dlm, &debug_state_fops);
> +	if (!dc->debug_state_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	dlm_debug_get(dc);
> +	return 0;
> +
> +bail:
> +	dlm_debug_shutdown(dlm);
> +	return -ENOMEM;
> +}
> +
> +void dlm_debug_shutdown(struct dlm_ctxt *dlm)
> +{
> +	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
> +
> +	if (dc) {
> +		if (dc->debug_state_dentry)
> +			debugfs_remove(dc->debug_state_dentry);
> +		dlm_debug_put(dc);
> +	}
> +}
>  
>  /* subroot - domain dir */
>  int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
> @@ -714,6 +1004,13 @@ int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
>  		goto bail;
>  	}
>  
> +	dlm->dlm_debug_ctxt = kzalloc(sizeof(struct dlm_debug_ctxt), GFP_KERNEL);
> +	if (!dlm->dlm_debug_ctxt) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +	kref_init(&dlm->dlm_debug_ctxt->debug_refcnt);
> +
>  	return 0;
>  bail:
>  	dlm_destroy_debugfs_subroot(dlm);
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> index e701499..50cb10f 100644
> --- a/fs/ocfs2/dlm/dlmdebug.h
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -25,6 +25,17 @@
>  #ifndef DLMDEBUG_H
>  #define DLMDEBUG_H
>  
> +struct dlm_debug_ctxt {
> +	struct kref debug_refcnt;
> +	struct dentry *debug_state_dentry;
> +};
> +
> +struct debug_buffer
> +{
> +	int len;
> +	char *buf;
> +};
> +
>  void dlm_remove_proc(void);
>  void dlm_init_proc(void);
>  void dlm_dump_lock_resources(struct dlm_ctxt *dlm);
> @@ -32,6 +43,9 @@ void dlm_proc_add_domain(struct dlm_ctxt *dlm);
>  void dlm_proc_del_domain(struct dlm_ctxt *dlm);
>  void dlm_dump_work_queue(struct dlm_ctxt *dlm);
>  
> +int dlm_debug_init(struct dlm_ctxt *dlm);
> +void dlm_debug_shutdown(struct dlm_ctxt *dlm);
> +
>  int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
>  void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
>  
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index da2a155..c22ebed 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -389,6 +389,7 @@ static void dlm_destroy_dlm_worker(struct dlm_ctxt *dlm)
>  static void dlm_complete_dlm_shutdown(struct dlm_ctxt *dlm)
>  {
>  	dlm_unregister_domain_handlers(dlm);
> +	dlm_debug_shutdown(dlm);
>  	dlm_complete_thread(dlm);
>  	dlm_complete_recovery_thread(dlm);
>  	dlm_destroy_dlm_worker(dlm);
> @@ -1297,6 +1298,12 @@ static int dlm_join_domain(struct dlm_ctxt *dlm)
>  		goto bail;
>  	}
>  
> +	status = dlm_debug_init(dlm);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
>  	status = dlm_launch_thread(dlm);
>  	if (status < 0) {
>  		mlog_errno(status);
> @@ -1364,6 +1371,7 @@ bail:
>  
>  	if (status) {
>  		dlm_unregister_domain_handlers(dlm);
> +		dlm_debug_shutdown(dlm);
>  		dlm_complete_thread(dlm);
>  		dlm_complete_recovery_thread(dlm);
>  		dlm_destroy_dlm_worker(dlm);
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
