From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 16:51:01 2008
Subject: [Ocfs2-devel] [PATCH 09/18] ocfs2_dlm: Dumps the lockres' into
	a debugfs file
In-Reply-To: <1203970862-8790-10-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-10-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229005015.GL23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:53PM -0800, Sunil Mushran wrote:
> This patch dumps all the lockres' alongwith all the locks into
> a debugfs file. Useful for debugging.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	Looks good modulo DEBUG_FS.

Joel

> ---
>  fs/ocfs2/dlm/dlmdebug.c |  248 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmdebug.h |    9 ++
>  2 files changed, 257 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 83f3ac6..905145a 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -705,7 +705,34 @@ EXPORT_SYMBOL_GPL(dlm_errname);
>  
>  #define DLM_DEBUGFS_DIR				"o2dlm"
>  #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
> +#define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
>  
> +/* NOTE: This function converts a lockname into a string. It uses knowledge
> + * of the format of the lockname that should be outside the purview of the dlm.
> + * We are adding only to make dlm debugging slightly easier.
> + *
> + * For more on lockname formats, please refer to dlmglue.c and ocfs2_lockid.h.
> + */
> +static int stringify_lockname(const char *lockname, int locklen,
> +			      char *buf, int len)
> +{
> +	int out = 0;
> +	__be64 inode_blkno_be;
> +
> +#define OCFS2_DENTRY_LOCK_INO_START	18
> +	if (*lockname == 'N') {
> +		memcpy((__be64 *)&inode_blkno_be,
> +		       (char *)&lockname[OCFS2_DENTRY_LOCK_INO_START],
> +		       sizeof(__be64));
> +		out += snprintf(buf + out, len - out, "%.*s%08x",
> +				OCFS2_DENTRY_LOCK_INO_START - 1, lockname,
> +				(unsigned int)be64_to_cpu(inode_blkno_be));
> +	} else
> +		out += snprintf(buf + out, len - out, "%.*s",
> +				locklen, lockname);
> +	return out;
> +}
> + 
>  /* begin - utils funcs */
>  static void dlm_debug_free(struct kref *kref)
>  {
> @@ -800,6 +827,214 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
>  }
>  /* end - util funcs */
>  
> +/* begin - debug lockres funcs */
> +static int dump_lock(struct dlm_lock *lock, int list_type, char *buf, int len)
> +{
> +	int out;
> +
> +#define DEBUG_LOCK_VERSION	1
> +	spin_lock(&lock->spinlock);
> +	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,%d,"
> +		       "%d,%d,%d,%d\n",
> +		       DEBUG_LOCK_VERSION,
> +		       list_type, lock->ml.type, lock->ml.convert_type,
> +		       lock->ml.node,
> +		       dlm_get_lock_cookie_node(be64_to_cpu(lock->ml.cookie)),
> +		       dlm_get_lock_cookie_seq(be64_to_cpu(lock->ml.cookie)),
> +		       !list_empty(&lock->ast_list),
> +		       !list_empty(&lock->bast_list),
> +		       lock->ast_pending, lock->bast_pending,
> +		       lock->convert_pending, lock->lock_pending,
> +		       lock->cancel_pending, lock->unlock_pending,
> +		       atomic_read(&lock->lock_refs.refcount));
> +	spin_unlock(&lock->spinlock);
> +
> +	return out;
> +}
> +
> +static int dump_lockres(struct dlm_lock_resource *res, char *buf, int len)
> +{
> +	struct dlm_lock *lock;
> +	int i;
> +	int out = 0;
> +
> +	out += snprintf(buf + out, len - out, "NAME:");
> +	out += stringify_lockname(res->lockname.name, res->lockname.len,
> +				  buf + out, len - out);
> +	out += snprintf(buf + out, len - out, "\n");
> +
> +#define DEBUG_LRES_VERSION	1
> +	out += snprintf(buf + out, len - out,
> +			"LRES:%d,%d,%d,%ld,%d,%d,%d,%d,%d,%d,%d\n",
> +			DEBUG_LRES_VERSION,
> +			res->owner, res->state, res->last_used,
> +			!list_empty(&res->purge),
> +			!list_empty(&res->dirty),
> +			!list_empty(&res->recovering),
> +		       	res->inflight_locks, res->migration_pending,
> +			atomic_read(&res->asts_reserved),
> +			atomic_read(&res->refs.refcount));
> +
> +	/* refmap */
> +	out += snprintf(buf + out, len - out, "RMAP:");
> +	out += stringify_nodemap(res->refmap, O2NM_MAX_NODES,
> +				 buf + out, len - out);
> +	out += snprintf(buf + out, len - out, "\n");
> +
> +	/* lvb */
> +	out += snprintf(buf + out, len - out, "LVBX:");
> +	for (i = 0; i < DLM_LVB_LEN; i++)
> +		out += snprintf(buf + out, len - out,
> +					"%02x", (unsigned char)res->lvb[i]);
> +	out += snprintf(buf + out, len - out, "\n");
> +
> +	/* granted */
> +	list_for_each_entry(lock, &res->granted, list)
> +		out += dump_lock(lock, 0, buf + out, len - out);
> +
> +	/* converting */
> +	list_for_each_entry(lock, &res->converting, list)
> +		out += dump_lock(lock, 1, buf + out, len - out);
> +
> +	/* blocked */
> +	list_for_each_entry(lock, &res->blocked, list)
> +		out += dump_lock(lock, 2, buf + out, len - out);
> +
> +	out += snprintf(buf + out, len - out, "\n");
> +
> +	return out;
> +}
> +
> +static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct debug_lockres *dl = m->private;
> +	struct dlm_ctxt *dlm = dl->dl_ctxt;
> +	struct dlm_lock_resource *res = NULL;
> +
> +	spin_lock(&dlm->spinlock);
> +
> +	if (dl->dl_res) {
> +		list_for_each_entry(res, &dl->dl_res->tracking, tracking) {
> +			if (dl->dl_res) {
> +				dlm_lockres_put(dl->dl_res);
> +				dl->dl_res = NULL;
> +			}
> +			if (&res->tracking == &dlm->tracking_list) {
> +				mlog(0, "End of list found, %p\n", res);
> +				dl = NULL;
> +				break;
> +			}
> +			dlm_lockres_get(res);
> +			dl->dl_res = res;
> +			break;
> +		}
> +	} else {
> +		if (!list_empty(&dlm->tracking_list)) {
> +			list_for_each_entry(res, &dlm->tracking_list, tracking)
> +				break;
> +			dlm_lockres_get(res);
> +			dl->dl_res = res;
> +		} else
> +			dl = NULL;
> +	}
> +
> +	if (dl) {
> +		spin_lock(&dl->dl_res->spinlock);
> +		dump_lockres(dl->dl_res, dl->dl_buf, dl->dl_len - 1);
> +		spin_unlock(&dl->dl_res->spinlock);
> +	}
> +
> +	spin_unlock(&dlm->spinlock);
> +
> +	return dl;
> +}
> +
> +static void lockres_seq_stop(struct seq_file *m, void *v)
> +{
> +}
> +
> +static void *lockres_seq_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	return NULL;
> +}
> +
> +static int lockres_seq_show(struct seq_file *s, void *v)
> +{
> +	struct debug_lockres *dl = (struct debug_lockres *)v;
> +
> +	seq_printf(s, "%s", dl->dl_buf);
> +
> +	return 0;
> +}
> +
> +static struct seq_operations debug_lockres_ops = {
> +	.start =	lockres_seq_start,
> +	.stop =		lockres_seq_stop,
> +	.next =		lockres_seq_next,
> +	.show =		lockres_seq_show,
> +};
> +
> +static int debug_lockres_open(struct inode *inode, struct file *file)
> +{
> +	struct dlm_ctxt *dlm = inode->i_private;
> +	int ret = -ENOMEM;
> +	struct seq_file *seq;
> +	struct debug_lockres *dl = NULL;
> +
> +	dl = kzalloc(sizeof(struct debug_lockres), GFP_KERNEL);
> +	if (!dl) {
> +		mlog_errno(ret);
> +		goto bail;
> +	}
> +
> +	dl->dl_len = PAGE_SIZE;
> +	dl->dl_buf = kmalloc(dl->dl_len, GFP_KERNEL);
> +	if (!dl->dl_buf) {
> +		mlog_errno(ret);
> +		goto bail;
> +	}
> +
> +	ret = seq_open(file, &debug_lockres_ops);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto bail;
> +	}
> +
> +	seq = (struct seq_file *) file->private_data;
> +	seq->private = dl;
> +
> +	dlm_grab(dlm);
> +	dl->dl_ctxt = dlm;
> +
> +	return 0;
> +bail:
> +	if (dl && dl->dl_buf)
> +		kfree(dl->dl_buf);
> +	if (dl)
> +		kfree(dl);
> +	return ret;
> +}
> +
> +static int debug_lockres_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = (struct seq_file *)file->private_data;
> +	struct debug_lockres *dl = (struct debug_lockres *)seq->private;
> +
> +	if (dl->dl_res)
> +		dlm_lockres_put(dl->dl_res);
> +	dlm_put(dl->dl_ctxt);
> +	kfree(dl->dl_buf);
> +	return seq_release_private(inode, file);
> +}
> +
> +static struct file_operations debug_lockres_fops = {
> +	.open =		debug_lockres_open,
> +	.release =	debug_lockres_release,
> +	.read =		seq_read,
> +	.llseek =	seq_lseek,
> +};
> +/* end - debug lockres funcs */
> +
>  /* begin - debug state funcs */
>  static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
>  {
> @@ -976,6 +1211,17 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
>  		goto bail;
>  	}
>  
> +	/* for dumping lockres */
> +	dc->debug_lockres_dentry =
> +			debugfs_create_file(DLM_DEBUGFS_LOCKING_STATE,
> +					    S_IFREG|S_IRUSR,
> +					    dlm->dlm_debugfs_subroot,
> +					    dlm, &debug_lockres_fops);
> +	if (!dc->debug_lockres_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
>  	dlm_debug_get(dc);
>  	return 0;
>  
> @@ -989,6 +1235,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
>  	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
>  
>  	if (dc) {
> +		if (dc->debug_lockres_dentry)
> +			debugfs_remove(dc->debug_lockres_dentry);
>  		if (dc->debug_state_dentry)
>  			debugfs_remove(dc->debug_state_dentry);
>  		dlm_debug_put(dc);
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> index 50cb10f..86d02f4 100644
> --- a/fs/ocfs2/dlm/dlmdebug.h
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -28,6 +28,7 @@
>  struct dlm_debug_ctxt {
>  	struct kref debug_refcnt;
>  	struct dentry *debug_state_dentry;
> +	struct dentry *debug_lockres_dentry;
>  };
>  
>  struct debug_buffer
> @@ -36,6 +37,14 @@ struct debug_buffer
>  	char *buf;
>  };
>  
> +struct debug_lockres
> +{
> +	int dl_len;
> +	char *dl_buf;
> +	struct dlm_ctxt *dl_ctxt;
> +	struct dlm_lock_resource *dl_res;
> +};
> +
>  void dlm_remove_proc(void);
>  void dlm_init_proc(void);
>  void dlm_dump_lock_resources(struct dlm_ctxt *dlm);
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
