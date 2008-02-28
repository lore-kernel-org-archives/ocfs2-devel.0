From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 16:53:06 2008
Subject: [Ocfs2-devel] [PATCH 12/18] ocfs2_dlm: Dumps the purgelist
	into a debugfs file
In-Reply-To: <1203970862-8790-13-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-13-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229005220.GN23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:56PM -0800, Sunil Mushran wrote:
> This patch dumps all the lockres' on the purgelist it can fit in one page
> into a debugfs file. Useful for debugging.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	Looks good modulo DEBUG_FS.

Joel

> ---
>  fs/ocfs2/dlm/dlmdebug.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmdebug.h |    1 +
>  2 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 158b2e5..ffdc976 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -707,6 +707,7 @@ EXPORT_SYMBOL_GPL(dlm_errname);
>  #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
>  #define DLM_DEBUGFS_LOCKING_STATE		"locking_state"
>  #define DLM_DEBUGFS_MLE_STATE			"mle_state"
> +#define DLM_DEBUGFS_PURGE_LIST			"purge_list"
>  
>  /* NOTE: This function converts a lockname into a string. It uses knowledge
>   * of the format of the lockname that should be outside the purview of the dlm.
> @@ -828,6 +829,63 @@ static int debug_buffer_release(struct inode *inode, struct file *file)
>  }
>  /* end - util funcs */
>  
> +/* begin - purge list funcs */
> +static int debug_purgelist_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
> +{
> +	struct dlm_lock_resource *res;
> +	int out = 0;
> +	unsigned long total = 0;
> +
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Dumping Purgelist for Domain: %s\n", dlm->name);
> +
> +	spin_lock(&dlm->spinlock);
> +	list_for_each_entry(res, &dlm->purge_list, purge) {
> +		++total;
> +		if (db->len - out < 100)
> +			continue;
> +		spin_lock(&res->spinlock);
> +		out += stringify_lockname(res->lockname.name,
> +					  res->lockname.len,
> +					  db->buf + out, db->len - out);
> +		out += snprintf(db->buf + out, db->len - out, "\t%ld\n",
> +				(jiffies - res->last_used)/HZ);
> +		spin_unlock(&res->spinlock);
> +	}
> +	spin_unlock(&dlm->spinlock);
> +
> +	out += snprintf(db->buf + out, db->len - out,
> +			"Total on list: %ld\n", total);
> +
> +	return out;
> +}
> +
> +static int debug_purgelist_open(struct inode *inode, struct file *file)
> +{
> +	struct dlm_ctxt *dlm = inode->i_private;
> +	struct debug_buffer *db;
> +
> +	db = debug_buffer_allocate();
> +	if (!db)
> +		goto bail;
> +
> +	db->len = debug_purgelist_print(dlm, db);
> +
> +	file->private_data = db;
> +
> +	return 0;
> +bail:
> +	return -ENOMEM;
> +}
> +
> +static struct file_operations debug_purgelist_fops = {
> +	.open =		debug_purgelist_open,
> +	.release =	debug_buffer_release,
> +	.read =		debug_buffer_read,
> +	.llseek =	debug_buffer_llseek,
> +};
> +/* end - purge list funcs */
> +
>  /* begin - debug mle funcs */
>  static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
>  {
> @@ -1339,6 +1397,17 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
>  		goto bail;
>  	}
>  
> +	/* for dumping lockres on the purge list */
> +	dc->debug_purgelist_dentry =
> +			debugfs_create_file(DLM_DEBUGFS_PURGE_LIST,
> +					    S_IFREG|S_IRUSR,
> +					    dlm->dlm_debugfs_subroot,
> +					    dlm, &debug_purgelist_fops);
> +	if (!dc->debug_purgelist_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
>  	dlm_debug_get(dc);
>  	return 0;
>  
> @@ -1352,6 +1421,8 @@ void dlm_debug_shutdown(struct dlm_ctxt *dlm)
>  	struct dlm_debug_ctxt *dc = dlm->dlm_debug_ctxt;
>  
>  	if (dc) {
> +		if (dc->debug_purgelist_dentry)
> +			debugfs_remove(dc->debug_purgelist_dentry);
>  		if (dc->debug_mle_dentry)
>  			debugfs_remove(dc->debug_mle_dentry);
>  		if (dc->debug_lockres_dentry)
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> index c6b240f..ca7bc32 100644
> --- a/fs/ocfs2/dlm/dlmdebug.h
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -30,6 +30,7 @@ struct dlm_debug_ctxt {
>  	struct dentry *debug_state_dentry;
>  	struct dentry *debug_lockres_dentry;
>  	struct dentry *debug_mle_dentry;
> +	struct dentry *debug_purgelist_dentry;
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

"The trouble with being punctual is that nobody's there to
 appreciate it."
	- Franklin P. Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
