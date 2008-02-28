From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 16:34:37 2008
Subject: [Ocfs2-devel] [PATCH 07/18] ocfs2_dlm: Create debugfs dirs
In-Reply-To: <1203970862-8790-8-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-8-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229003311.GJ23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:51PM -0800, Sunil Mushran wrote:
> This patch creates the debugfs directories that will hold the
> files to be used to dump the dlm state.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	Looks good, but once again it needs to either be conditional on
CONFIG_DEBUG_FS or have OCFS2 depend on it.

Joel

> ---
>  fs/ocfs2/dlm/dlmcommon.h |    2 ++
>  fs/ocfs2/dlm/dlmdebug.c  |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmdebug.h  |    7 +++++++
>  fs/ocfs2/dlm/dlmdomain.c |   20 ++++++++++++++++++++
>  4 files changed, 73 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index a3b22bf..810e9b4 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -125,6 +125,8 @@ struct dlm_ctxt
>  	atomic_t remote_resources;
>  	atomic_t unknown_resources;
>  
> +	struct dentry *dlm_debugfs_subroot;
> +
>  	/* NOTE: Next three are protected by dlm_domain_lock */
>  	struct kref dlm_refs;
>  	enum dlm_ctxt_state dlm_state;
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index e4f1fe9..baa8e24 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -31,6 +31,7 @@
>  #include <linux/sysctl.h>
>  #include <linux/spinlock.h>
>  #include <linux/proc_fs.h>
> +#include <linux/debugfs.h>
>  
>  #include "cluster/heartbeat.h"
>  #include "cluster/nodemanager.h"
> @@ -46,6 +47,8 @@
>  #define MLOG_MASK_PREFIX ML_DLM
>  #include "cluster/masklog.h"
>  
> +static struct dentry *dlm_debugfs_root = NULL;
> +
>  static int dlm_dump_all_lock_resources(const char __user *data,
>  					unsigned int len);
>  static void dlm_dump_purge_list(struct dlm_ctxt *dlm);
> @@ -699,3 +702,44 @@ const char *dlm_errname(enum dlm_status err)
>  	return dlm_errnames[err];
>  }
>  EXPORT_SYMBOL_GPL(dlm_errname);
> +
> +#define DLM_DEBUGFS_DIR				"o2dlm"
> +
> +/* subroot - domain dir */
> +int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
> +{
> +	dlm->dlm_debugfs_subroot = debugfs_create_dir(dlm->name, dlm_debugfs_root);
> +	if (!dlm->dlm_debugfs_subroot) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	return 0;
> +bail:
> +	dlm_destroy_debugfs_subroot(dlm);
> +	return -ENOMEM;
> +}
> +
> +void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
> +{
> +	if (dlm->dlm_debugfs_subroot)
> +		debugfs_remove(dlm->dlm_debugfs_subroot);
> +}
> +
> +/* debugfs root */
> +int dlm_create_debugfs_root(void)
> +{
> +	dlm_debugfs_root = debugfs_create_dir(DLM_DEBUGFS_DIR, NULL);
> +	if (!dlm_debugfs_root) {
> +		mlog_errno(-ENOMEM);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +void dlm_destroy_debugfs_root(void)
> +{
> +	if (dlm_debugfs_root)
> +		debugfs_remove(dlm_debugfs_root);
> +}
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> index dbe3a3d..e701499 100644
> --- a/fs/ocfs2/dlm/dlmdebug.h
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -31,4 +31,11 @@ void dlm_dump_lock_resources(struct dlm_ctxt *dlm);
>  void dlm_proc_add_domain(struct dlm_ctxt *dlm);
>  void dlm_proc_del_domain(struct dlm_ctxt *dlm);
>  void dlm_dump_work_queue(struct dlm_ctxt *dlm);
> +
> +int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
> +void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
> +
> +int dlm_create_debugfs_root(void);
> +void dlm_destroy_debugfs_root(void);
> +
>  #endif
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 1d382f1..da2a155 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -33,6 +33,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/delay.h>
>  #include <linux/err.h>
> +#include <linux/debugfs.h>
>  
>  #include "cluster/heartbeat.h"
>  #include "cluster/nodemanager.h"
> @@ -43,6 +44,7 @@
>  
>  #include "dlmdebug.h"
>  #include "dlmdomain.h"
> +#include "dlmdebug.h"
>  
>  #include "dlmver.h"
>  
> @@ -288,6 +290,8 @@ static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
>  {
>  	dlm_proc_del_domain(dlm);
>  
> +	dlm_destroy_debugfs_subroot(dlm);
> +
>  	if (dlm->lockres_hash)
>  		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
>  
> @@ -1372,6 +1376,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
>  				u32 key)
>  {
>  	int i;
> +	int ret;
>  	struct dlm_ctxt *dlm = NULL;
>  
>  	dlm = kzalloc(sizeof(*dlm), GFP_KERNEL);
> @@ -1404,6 +1409,15 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
>  	dlm->key = key;
>  	dlm->node_num = o2nm_this_node();
>  
> +	ret = dlm_create_debugfs_subroot(dlm);
> +	if (ret < 0) {
> +		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
> +		kfree(dlm->name);
> +		kfree(dlm);
> +		dlm = NULL;
> +		goto leave;
> +	}
> +
>  	spin_lock_init(&dlm->spinlock);
>  	spin_lock_init(&dlm->master_lock);
>  	spin_lock_init(&dlm->ast_lock);
> @@ -1688,8 +1702,13 @@ static int __init dlm_init(void)
>  
>  	dlm_init_proc();
>  
> +	status = dlm_create_debugfs_root();
> +	if (status)
> +		goto error;
> +
>  	return 0;
>  error:
> +	dlm_unregister_net_handlers();
>  	dlm_destroy_lock_cache();
>  	dlm_destroy_lockname_cache();
>  	dlm_destroy_lockres_cache();
> @@ -1699,6 +1718,7 @@ error:
>  
>  static void __exit dlm_exit (void)
>  {
> +	dlm_destroy_debugfs_root();
>  	dlm_remove_proc();
>  	dlm_unregister_net_handlers();
>  	dlm_destroy_lock_cache();
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
