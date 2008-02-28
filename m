From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 16:55:10 2008
Subject: [Ocfs2-devel] [PATCH 14/18] ocfs2_dlm: Remove the proc interface
In-Reply-To: <1203970862-8790-15-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
	<1203970862-8790-15-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229005338.GP23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2008 at 12:20:58PM -0800, Sunil Mushran wrote:
> The proc debug interface is no longer needed as all the functionality
> it provided has been moved to the debugfs interface.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlm/dlmcommon.h |    2 -
>  fs/ocfs2/dlm/dlmdebug.c  |  458 ----------------------------------------------
>  fs/ocfs2/dlm/dlmdebug.h  |    7 -
>  fs/ocfs2/dlm/dlmdomain.c |    8 -
>  4 files changed, 0 insertions(+), 475 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 41c8d90..1d05ebf 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -155,8 +155,6 @@ struct dlm_ctxt
>  	struct list_head master_list;
>  	struct list_head mle_hb_events;
>  
> -	struct proc_dir_entry *dlm_proc;
> -
>  	/* these give a really vague idea of the system load */
>  	atomic_t local_resources;
>  	atomic_t remote_resources;
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 1864731..e8fa5a9 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -30,7 +30,6 @@
>  #include <linux/utsname.h>
>  #include <linux/sysctl.h>
>  #include <linux/spinlock.h>
> -#include <linux/proc_fs.h>
>  #include <linux/debugfs.h>
>  
>  #include "cluster/heartbeat.h"
> @@ -39,8 +38,6 @@
>  
>  #include "dlmapi.h"
>  #include "dlmcommon.h"
> -#include "dlmdebug.h"
> -
>  #include "dlmdomain.h"
>  #include "dlmdebug.h"
>  
> @@ -49,233 +46,6 @@
>  
>  static struct dentry *dlm_debugfs_root = NULL;
>  
> -static int dlm_dump_all_lock_resources(const char __user *data,
> -					unsigned int len);
> -static void dlm_dump_purge_list(struct dlm_ctxt *dlm);
> -static int dlm_dump_all_purge_lists(const char __user *data, unsigned int len);
> -static int dlm_trigger_migration(const char __user *data, unsigned int len);
> -static int dlm_dump_one_lock_resource(const char __user *data,
> -				       unsigned int len);
> -static int dlm_dump_work_queues(const char __user *data, unsigned int len);
> -
> -static int dlm_parse_domain_and_lockres(char *buf, unsigned int len,
> -					struct dlm_ctxt **dlm,
> -					struct dlm_lock_resource **res);
> -
> -static int dlm_proc_stats(char *page, char **start, off_t off,
> -			  int count, int *eof, void *data);
> -
> -typedef int (dlm_debug_func_t)(const char __user *data, unsigned int len);
> -
> -struct dlm_debug_funcs
> -{
> -	char key;
> -	dlm_debug_func_t *func;
> -};
> -
> -static struct dlm_debug_funcs dlm_debug_map[] = {
> -	{ 'r', dlm_dump_all_lock_resources },
> -	{ 'R', dlm_dump_one_lock_resource },
> -	{ 'm', dlm_dump_all_mles },
> -	{ 'p', dlm_dump_all_purge_lists  },
> -	{ 'M', dlm_trigger_migration },
> -	{ 'w', dlm_dump_work_queues }
> -};
> -static int dlm_debug_map_sz = (sizeof(dlm_debug_map) /
> -			       sizeof(struct dlm_debug_funcs));
> -
> -static ssize_t write_dlm_debug(struct file *file, const char __user *buf,
> -			       size_t count, loff_t *ppos)
> -{
> -	int i;
> -	char c;
> -	dlm_debug_func_t *fn;
> -	int ret;
> -
> -	mlog(0, "(%p, %p, %u, %lld)\n",
> -		  file, buf, (unsigned int)count, (long long)*ppos);
> -	ret = 0;
> -	if (count<=0)
> -		goto done;
> -
> -	ret = -EFAULT;
> -	if (get_user(c, buf))
> -		goto done;
> -
> -	ret = count;
> -	for (i=0; i < dlm_debug_map_sz; i++) {
> -		struct dlm_debug_funcs *d = &dlm_debug_map[i];
> -		if (c == d->key) {
> -			fn = d->func;
> -			if (fn)
> -				ret = (fn)(buf, count);
> -			goto done;
> -		}
> -	}
> -done:
> -	return ret;
> -}
> -
> -static struct file_operations dlm_debug_operations = {
> -	.write          = write_dlm_debug,
> -};
> -
> -#define OCFS2_DLM_PROC_PATH "fs/ocfs2_dlm"
> -#define DLM_DEBUG_PROC_NAME "debug"
> -#define DLM_STAT_PROC_NAME  "stat"
> -
> -static struct proc_dir_entry *ocfs2_dlm_proc;
> -
> -void dlm_remove_proc(void)
> -{
> -	if (ocfs2_dlm_proc) {
> -		remove_proc_entry(DLM_DEBUG_PROC_NAME, ocfs2_dlm_proc);
> -		remove_proc_entry(OCFS2_DLM_PROC_PATH, NULL);
> -	}
> -}
> -
> -void dlm_init_proc(void)
> -{
> -	struct proc_dir_entry *entry;
> -
> -	ocfs2_dlm_proc = proc_mkdir(OCFS2_DLM_PROC_PATH, NULL);
> -	if (!ocfs2_dlm_proc) {
> -		mlog_errno(-ENOMEM);
> -		return;
> -	}
> -
> -	entry = create_proc_entry(DLM_DEBUG_PROC_NAME, S_IWUSR,
> -				  ocfs2_dlm_proc);
> -	if (entry)
> -		entry->proc_fops = &dlm_debug_operations;
> -}
> -
> -static int dlm_proc_stats(char *page, char **start, off_t off,
> -			  int count, int *eof, void *data)
> -{
> -	int len;
> -	struct dlm_ctxt *dlm = data;
> -
> -	len = sprintf(page, "local=%d, remote=%d, unknown=%d, key=0x%08x\n",
> -		      atomic_read(&dlm->local_resources),
> -		      atomic_read(&dlm->remote_resources),
> -		      atomic_read(&dlm->unknown_resources),
> -		      dlm->key);
> -
> -	if (len <= off + count)
> -		*eof = 1;
> -
> -	*start = page + off;
> -	len -= off;
> -	if (len > count)
> -		len = count;
> -	if (len < 0)
> -		len = 0;
> -
> -	return len;
> -}
> -
> -void dlm_proc_add_domain(struct dlm_ctxt *dlm)
> -{
> -	struct proc_dir_entry *entry;
> -
> -	dlm->dlm_proc = proc_mkdir(dlm->name, ocfs2_dlm_proc);
> -	if (dlm->dlm_proc) {
> -		entry = create_proc_read_entry(DLM_STAT_PROC_NAME,
> -					       S_IFREG | S_IRUGO, dlm->dlm_proc,
> -					       dlm_proc_stats, (char *)dlm);
> -		if (entry)
> -			entry->owner = THIS_MODULE;
> -	}
> -}
> -
> -void dlm_proc_del_domain(struct dlm_ctxt *dlm)
> -{
> -	if (dlm->dlm_proc) {
> -		remove_proc_entry(DLM_STAT_PROC_NAME, dlm->dlm_proc);
> -		remove_proc_entry(dlm->name, ocfs2_dlm_proc);
> -	}
> -}
> -
> -/* lock resource printing is usually very important (printed
> - * right before a BUG in some cases), but we'd like to be
> - * able to shut it off if needed, hence the KERN_NOTICE level */
> -static int dlm_dump_all_lock_resources(const char __user *data,
> -				       unsigned int len)
> -{
> -	struct dlm_ctxt *dlm;
> -	struct list_head *iter;
> -
> -	mlog(ML_NOTICE, "dumping ALL dlm state for node %s\n",
> -#ifndef NO_SYSTEM_UTSNAME
> -	     system_utsname.nodename);
> -#else
> -	     init_uts_ns.name.nodename);
> -#endif
> -	spin_lock(&dlm_domain_lock);
> -	list_for_each(iter, &dlm_domains) {
> -		dlm = list_entry (iter, struct dlm_ctxt, list);
> -		dlm_dump_lock_resources(dlm);
> -	}
> -	spin_unlock(&dlm_domain_lock);
> -	return len;
> -}
> -
> -static int dlm_dump_one_lock_resource(const char __user *data,
> -				       unsigned int len)
> -{
> -	struct dlm_ctxt *dlm;
> -	struct dlm_lock_resource *res;
> -	char *buf = NULL;
> -	int ret = -EINVAL;
> -	int tmpret;
> -
> -	if (len >= PAGE_SIZE-1) {
> -		mlog(ML_ERROR, "user passed too much data: %d bytes\n", len);
> -		goto leave;
> -	}
> -	if (len < 5) {
> -		mlog(ML_ERROR, "user passed too little data: %d bytes\n", len);
> -		goto leave;
> -	}
> -	buf = kmalloc(len+1, GFP_NOFS);
> -	if (!buf) {
> -		mlog(ML_ERROR, "could not alloc %d bytes\n", len+1);
> -		ret = -ENOMEM;
> -		goto leave;
> -	}
> -	if (strncpy_from_user(buf, data, len) < len) {
> -		mlog(ML_ERROR, "failed to get all user data.  done.\n");
> -		goto leave;
> -	}
> -	buf[len]='\0';
> -	mlog(0, "got this data from user: %s\n", buf);
> -
> -	if (*buf != 'R') {
> -		mlog(0, "bad data\n");
> -		goto leave;
> -	}
> -
> -	tmpret = dlm_parse_domain_and_lockres(buf, len, &dlm, &res);
> -	if (tmpret < 0) {
> -		mlog(0, "bad data\n");
> -		goto leave;
> -	}
> -
> -	mlog(ML_NOTICE, "struct dlm_ctxt: %s, node=%u, key=%u\n",
> -		dlm->name, dlm->node_num, dlm->key);
> -
> -	dlm_print_one_lock_resource(res);
> -	dlm_lockres_put(res);
> -	dlm_put(dlm);
> -	ret = len;
> -
> -leave:
> -	if (buf)
> -		kfree(buf);
> -	return ret;
> -}
> -
>  static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
>  {
>  	int bit;
> @@ -369,234 +139,6 @@ void dlm_print_one_lock(struct dlm_lock *lockid)
>  }
>  EXPORT_SYMBOL_GPL(dlm_print_one_lock);
>  
> -void dlm_dump_lock_resources(struct dlm_ctxt *dlm)
> -{
> -	struct dlm_lock_resource *res;
> -	struct hlist_node *iter;
> -	struct hlist_head *bucket;
> -	int i;
> -
> -	mlog(ML_NOTICE, "struct dlm_ctxt: %s, node=%u, key=%u\n",
> -		  dlm->name, dlm->node_num, dlm->key);
> -	if (!dlm || !dlm->name) {
> -		mlog(ML_ERROR, "dlm=%p\n", dlm);
> -		return;
> -	}
> -
> -	spin_lock(&dlm->spinlock);
> -	for (i=0; i<DLM_HASH_BUCKETS; i++) {
> -		bucket = dlm_lockres_hash(dlm, i);
> -		hlist_for_each_entry(res, iter, bucket, hash_node)
> -			dlm_print_one_lock_resource(res);
> -	}
> -	spin_unlock(&dlm->spinlock);
> -}
> -static void dlm_dump_purge_list(struct dlm_ctxt *dlm)
> -{
> -	struct list_head *iter;
> -	struct dlm_lock_resource *lockres;
> -
> -	mlog(ML_NOTICE, "Purge list for DLM Domain \"%s\"\n", dlm->name);
> -	mlog(ML_NOTICE, "Last_used\tName\n");
> -
> -	spin_lock(&dlm->spinlock);
> -	list_for_each(iter, &dlm->purge_list) {
> -		lockres = list_entry(iter, struct dlm_lock_resource, purge);
> -
> -		spin_lock(&lockres->spinlock);
> -		mlog(ML_NOTICE, "%lu\t%.*s\n", lockres->last_used,
> -		       lockres->lockname.len, lockres->lockname.name);
> -		spin_unlock(&lockres->spinlock);
> -	}
> -	spin_unlock(&dlm->spinlock);
> -}
> -
> -void dlm_dump_work_queue(struct dlm_ctxt *dlm)
> -{
> -	struct list_head *iter;
> -	struct dlm_work_item *item;
> -
> -	spin_lock(&dlm->work_lock);
> -	list_for_each(iter, &dlm->work_list) {
> -		item = list_entry(iter, struct dlm_work_item, list);
> -		if (item->func == dlm_request_all_locks_worker) {
> -			printk("%s: found requestalllocks, mas=%u, dead=%u\n",
> -			       dlm->name, item->u.ral.reco_master,
> -			       item->u.ral.dead_node);
> -		} else if (item->func == dlm_mig_lockres_worker) {
> -			printk("%s:%.*s: found assert_master, realmaster=%u\n",
> -			       dlm->name, item->u.ml.lockres->lockname.len,
> -			       item->u.ml.lockres->lockname.name,
> -			       item->u.ml.real_master);
> -		} else if (item->func == dlm_assert_master_worker) {
> -			printk("%s:%.*s: found assert_master, from=%u, "
> -			       "flags=%u, ignore=%d\n",
> -			       dlm->name, item->u.am.lockres->lockname.len,
> -			       item->u.am.lockres->lockname.name,
> -			       item->u.am.request_from, item->u.am.flags,
> -			       item->u.am.ignore_higher);
> -		} else {
> -			printk("%s: found INVALID work item, func=%p\n",
> -			       dlm->name, item->func);
> -		}
> -	}
> -	spin_unlock(&dlm->work_lock);
> -}
> -
> -static int dlm_dump_work_queues(const char __user *data, unsigned int len)
> -{
> -	struct dlm_ctxt *dlm;
> -	struct list_head *iter;
> -
> -	spin_lock(&dlm_domain_lock);
> -	list_for_each(iter, &dlm_domains) {
> -		dlm = list_entry (iter, struct dlm_ctxt, list);
> -		dlm_dump_work_queue(dlm);
> -	}
> -	spin_unlock(&dlm_domain_lock);
> -	return len;
> -
> -}
> -
> -static int dlm_dump_all_purge_lists(const char __user *data, unsigned int len)
> -{
> -	struct dlm_ctxt *dlm;
> -	struct list_head *iter;
> -
> -	spin_lock(&dlm_domain_lock);
> -	list_for_each(iter, &dlm_domains) {
> -		dlm = list_entry (iter, struct dlm_ctxt, list);
> -		dlm_dump_purge_list(dlm);
> -	}
> -	spin_unlock(&dlm_domain_lock);
> -	return len;
> -}
> -
> -static int dlm_parse_domain_and_lockres(char *buf, unsigned int len,
> -					struct dlm_ctxt **dlm,
> -					struct dlm_lock_resource **res)
> -{
> -	char *resname;
> -	char *domainname;
> -	char *tmp;
> -	int ret = -EINVAL;
> -
> -	*dlm = NULL;
> -	*res = NULL;
> -
> -	tmp = buf;
> -	tmp++;
> -	if (*tmp != ' ') {
> -		mlog(0, "bad data\n");
> -		goto leave;
> -	}
> -	tmp++;
> -	domainname = tmp;
> -
> -	while (*tmp) {
> -		if (*tmp == ' ')
> -			break;
> -		tmp++;
> -	}
> -	if (!*tmp || !*(tmp+1)) {
> -		mlog(0, "bad data\n");
> -		goto leave;
> -	}
> -
> -	*tmp = '\0';  // null term the domainname
> -	tmp++;
> -	resname = tmp;
> -	while (*tmp) {
> -		if (*tmp == '\n' ||
> -		    *tmp == ' ' ||
> -		    *tmp == '\r') {
> -			*tmp = '\0';
> -			break;
> -		}
> -		tmp++;
> -	}
> -
> -	mlog(0, "now looking up domain %s, lockres %s\n",
> -	       domainname, resname);
> -	spin_lock(&dlm_domain_lock);
> -	*dlm = __dlm_lookup_domain(domainname);
> -	spin_unlock(&dlm_domain_lock);
> -
> -	if (!dlm_grab(*dlm)) {
> -		mlog(ML_ERROR, "bad dlm!\n");
> -		*dlm = NULL;
> -		goto leave;
> -	}
> -
> -	*res = dlm_lookup_lockres(*dlm, resname, strlen(resname));
> -	if (!*res) {
> -		mlog(ML_ERROR, "bad lockres!\n");
> -		dlm_put(*dlm);
> -		*dlm = NULL;
> -		goto leave;
> -	}
> -
> -	mlog(0, "found dlm=%p, lockres=%p\n", *dlm, *res);
> -	ret = 0;
> -
> -leave:
> -	return ret;
> -}
> -
> -static int dlm_trigger_migration(const char __user *data, unsigned int len)
> -{
> -	struct dlm_lock_resource *res;
> -	struct dlm_ctxt *dlm;
> -	char *buf = NULL;
> -	int ret = -EINVAL;
> -	int tmpret;
> -
> -	if (len >= PAGE_SIZE-1) {
> -		mlog(ML_ERROR, "user passed too much data: %d bytes\n", len);
> -		goto leave;
> -	}
> -	if (len < 5) {
> -		mlog(ML_ERROR, "user passed too little data: %d bytes\n", len);
> -		goto leave;
> -	}
> -	buf = kmalloc(len+1, GFP_NOFS);
> -	if (!buf) {
> -		mlog(ML_ERROR, "could not alloc %d bytes\n", len+1);
> -		ret = -ENOMEM;
> -		goto leave;
> -	}
> -	if (strncpy_from_user(buf, data, len) < len) {
> -		mlog(ML_ERROR, "failed to get all user data.  done.\n");
> -		goto leave;
> -	}
> -	buf[len]='\0';
> -	mlog(0, "got this data from user: %s\n", buf);
> -
> -	if (*buf != 'M') {
> -		mlog(0, "bad data\n");
> -		goto leave;
> -	}
> -
> -	tmpret = dlm_parse_domain_and_lockres(buf, len, &dlm, &res);
> -	if (tmpret < 0) {
> -		mlog(0, "bad data\n");
> -		goto leave;
> -	}
> -	tmpret = dlm_migrate_lockres(dlm, res, O2NM_MAX_NODES);
> -	mlog(0, "dlm_migrate_lockres returned %d\n", tmpret);
> -	if (tmpret < 0)
> -		mlog(ML_ERROR, "failed to migrate %.*s: %d\n",
> -		     res->lockname.len, res->lockname.name, tmpret);
> -	dlm_lockres_put(res);
> -	dlm_put(dlm);
> -	ret = len;
> -
> -leave:
> -	if (buf)
> -		kfree(buf);
> -	return ret;
> -}
> -
>  static const char *dlm_errnames[] = {
>  	[DLM_NORMAL] =			"DLM_NORMAL",
>  	[DLM_GRANTED] =			"DLM_GRANTED",
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> index fcc19c8..f6537ac 100644
> --- a/fs/ocfs2/dlm/dlmdebug.h
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -48,13 +48,6 @@ struct debug_lockres
>  	struct dlm_lock_resource *dl_res;
>  };
>  
> -void dlm_remove_proc(void);
> -void dlm_init_proc(void);
> -void dlm_dump_lock_resources(struct dlm_ctxt *dlm);
> -void dlm_proc_add_domain(struct dlm_ctxt *dlm);
> -void dlm_proc_del_domain(struct dlm_ctxt *dlm);
> -void dlm_dump_work_queue(struct dlm_ctxt *dlm);
> -
>  int dlm_debug_init(struct dlm_ctxt *dlm);
>  void dlm_debug_shutdown(struct dlm_ctxt *dlm);
>  
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index c22ebed..307d147 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -41,8 +41,6 @@
>  
>  #include "dlmapi.h"
>  #include "dlmcommon.h"
> -
> -#include "dlmdebug.h"
>  #include "dlmdomain.h"
>  #include "dlmdebug.h"
>  
> @@ -288,8 +286,6 @@ static int dlm_wait_on_domain_helper(const char *domain)
>  
>  static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
>  {
> -	dlm_proc_del_domain(dlm);
> -
>  	dlm_destroy_debugfs_subroot(dlm);
>  
>  	if (dlm->lockres_hash)
> @@ -1477,7 +1473,6 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
>  	dlm->dlm_state = DLM_CTXT_NEW;
>  
>  	INIT_LIST_HEAD(&dlm->dlm_eviction_callbacks);
> -	dlm_proc_add_domain(dlm);
>  
>  	mlog(0, "context init: refcount %u\n",
>  		  atomic_read(&dlm->dlm_refs.refcount));
> @@ -1708,8 +1703,6 @@ static int __init dlm_init(void)
>  	if (status)
>  		goto error;
>  
> -	dlm_init_proc();
> -
>  	status = dlm_create_debugfs_root();
>  	if (status)
>  		goto error;
> @@ -1727,7 +1720,6 @@ error:
>  static void __exit dlm_exit (void)
>  {
>  	dlm_destroy_debugfs_root();
> -	dlm_remove_proc();
>  	dlm_unregister_net_handlers();
>  	dlm_destroy_lock_cache();
>  	dlm_destroy_lockname_cache();
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

#!/bin/perl -sp0777i<X+d*lMLa^*lN%0]dsXx++lMlN/dsM0<j]dsj
$/=unpack('H*',$_);$_=`echo 16dio\U$k"SK$/SM$n\EsN0p[lN*1
lK[d2%Sa2/d0$^Ixp"|dc`;s/\W//g;$_=pack('H*',/((..)*)$/)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
