From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Mar  5 10:55:25 2008
Subject: [Ocfs2-devel] [PATCH 04/12] ocfs2/dlm: Create debugfs dirs
In-Reply-To: <1204678200-26237-5-git-send-email-sunil.mushran@oracle.com>
References: <1204678200-26237-1-git-send-email-sunil.mushran@oracle.com>
	<1204678200-26237-5-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080305185459.GB799@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 04, 2008 at 04:49:52PM -0800, Sunil Mushran wrote:
> This patch creates the debugfs directories that will hold the
> files to be used to dump the dlm state.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/dlm/dlmcommon.h |    2 +
>  fs/ocfs2/dlm/dlmdebug.c  |   57 +++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ocfs2/dlm/dlmdebug.h  |   34 +++++++++++++++++++++++++++
>  fs/ocfs2/dlm/dlmdomain.c |   20 ++++++++++++++++
>  4 files changed, 112 insertions(+), 1 deletions(-)
>  create mode 100644 fs/ocfs2/dlm/dlmdebug.h
> 
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index e2a2b7a..a20d093 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -123,6 +123,8 @@ struct dlm_ctxt
>  	atomic_t remote_resources;
>  	atomic_t unknown_resources;
>  
> +	struct dentry *dlm_debugfs_subroot;
> +
>  	/* NOTE: Next three are protected by dlm_domain_lock */
>  	struct kref dlm_refs;
>  	enum dlm_ctxt_state dlm_state;
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index 64239b3..be63024 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -30,6 +30,7 @@
>  #include <linux/utsname.h>
>  #include <linux/sysctl.h>
>  #include <linux/spinlock.h>
> +#include <linux/debugfs.h>
>  
>  #include "cluster/heartbeat.h"
>  #include "cluster/nodemanager.h"
> @@ -37,12 +38,16 @@
>  
>  #include "dlmapi.h"
>  #include "dlmcommon.h"
> -
>  #include "dlmdomain.h"
> +#include "dlmdebug.h"
>  
>  #define MLOG_MASK_PREFIX ML_DLM
>  #include "cluster/masklog.h"
>  
> +#ifdef CONFIG_DEBUG_FS
> +static struct dentry *dlm_debugfs_root = NULL;
> +#endif
> +
>  void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
>  {
>  	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
> @@ -266,3 +271,53 @@ const char *dlm_errname(enum dlm_status err)
>  	return dlm_errnames[err];
>  }
>  EXPORT_SYMBOL_GPL(dlm_errname);
> +
> +#define DLM_DEBUGFS_DIR				"o2dlm"
> +
> +/* subroot - domain dir */
> +int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm)
> +{
> +#ifdef CONFIG_DEBUG_FS
> +	dlm->dlm_debugfs_subroot = debugfs_create_dir(dlm->name,
> +						      dlm_debugfs_root);
> +	if (!dlm->dlm_debugfs_subroot) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	return 0;
> +bail:
> +	dlm_destroy_debugfs_subroot(dlm);
> +	return -ENOMEM;
> +#endif
> +	return 0;
> +}
> +
> +void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm)
> +{
> +#ifdef CONFIG_DEBUG_FS
> +	if (dlm->dlm_debugfs_subroot)
> +		debugfs_remove(dlm->dlm_debugfs_subroot);
> +#endif
> +}
> +
> +/* debugfs root */
> +int dlm_create_debugfs_root(void)
> +{
> +#ifdef CONFIG_DEBUG_FS
> +	dlm_debugfs_root = debugfs_create_dir(DLM_DEBUGFS_DIR, NULL);
> +	if (!dlm_debugfs_root) {
> +		mlog_errno(-ENOMEM);
> +		return -ENOMEM;
> +	}
> +#endif
> +	return 0;
> +}
> +
> +void dlm_destroy_debugfs_root(void)
> +{
> +#ifdef CONFIG_DEBUG_FS
> +	if (dlm_debugfs_root)
> +		debugfs_remove(dlm_debugfs_root);
> +#endif
> +}
> diff --git a/fs/ocfs2/dlm/dlmdebug.h b/fs/ocfs2/dlm/dlmdebug.h
> new file mode 100644
> index 0000000..eb397d5
> --- /dev/null
> +++ b/fs/ocfs2/dlm/dlmdebug.h
> @@ -0,0 +1,34 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * dlmdebug.h
> + *
> + * Copyright (C) 2008 Oracle.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + *
> + */
> +
> +#ifndef DLMDEBUG_H
> +#define DLMDEBUG_H
> +
> +int dlm_create_debugfs_subroot(struct dlm_ctxt *dlm);
> +void dlm_destroy_debugfs_subroot(struct dlm_ctxt *dlm);
> +
> +int dlm_create_debugfs_root(void);
> +void dlm_destroy_debugfs_root(void);
> +
> +#endif
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index 6b62211..2fd17a4 100644
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
> @@ -42,6 +43,7 @@
>  #include "dlmcommon.h"
>  
>  #include "dlmdomain.h"
> +#include "dlmdebug.h"
>  
>  #include "dlmver.h"
>  
> @@ -298,6 +300,8 @@ static int dlm_wait_on_domain_helper(const char *domain)
>  
>  static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
>  {
> +	dlm_destroy_debugfs_subroot(dlm);
> +
>  	if (dlm->lockres_hash)
>  		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
>  
> @@ -1465,6 +1469,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
>  				u32 key)
>  {
>  	int i;
> +	int ret;
>  	struct dlm_ctxt *dlm = NULL;
>  
>  	dlm = kzalloc(sizeof(*dlm), GFP_KERNEL);
> @@ -1497,6 +1502,15 @@ static struct dlm_ctxt *dlm_alloc_ctxt(const char *domain,
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
> @@ -1822,8 +1836,13 @@ static int __init dlm_init(void)
>  		goto error;
>  	}
>  
> +	status = dlm_create_debugfs_root();
> +	if (status)
> +		goto error;
> +
>  	return 0;
>  error:
> +	dlm_unregister_net_handlers();
>  	dlm_destroy_lock_cache();
>  	dlm_destroy_master_caches();
>  	dlm_destroy_mle_cache();
> @@ -1832,6 +1851,7 @@ error:
>  
>  static void __exit dlm_exit (void)
>  {
> +	dlm_destroy_debugfs_root();
>  	dlm_unregister_net_handlers();
>  	dlm_destroy_lock_cache();
>  	dlm_destroy_master_caches();
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #226

	"When someone hugs you, let them be the first to let go."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
