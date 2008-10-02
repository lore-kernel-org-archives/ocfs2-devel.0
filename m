From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:11:53 -0700
Subject: [Ocfs2-devel] [PATCH 04/39] ocfs2: track local alloc state via
	debugfs
In-Reply-To: <1222293680-15451-5-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-5-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231153.2d19bb68.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:45 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> A per-mount debugfs file, "local_alloc" is created which when read will
> expose live state of the nodes local alloc file. Performance impact is
> minimal, only a bit of memory overhead per mount point. Still, the code is
> hidden behind CONFIG_OCFS2_FS_STATS. This feature will help us debug
> local alloc performance problems on a live system.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/ocfs2/localalloc.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/ocfs2.h      |    5 +++
>  2 files changed, 92 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index f71658a..b889f10 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
>  #include <linux/bitops.h>
> +#include <linux/debugfs.h>
>  
>  #define MLOG_MASK_PREFIX ML_DISK_ALLOC
>  #include <cluster/masklog.h>
> @@ -73,6 +74,85 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
>  static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
>  					  struct inode *local_alloc_inode);
>  
> +#ifdef CONFIG_OCFS2_FS_STATS
> +
> +DEFINE_MUTEX(la_debug_mutex);

Unless this mutex is used in a later patch, it can be made static to this file.

> +static int ocfs2_la_debug_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +#define LA_DEBUG_BUF_SZ	PAGE_CACHE_SIZE
> +#define LA_DEBUG_VER	1
> +static ssize_t ocfs2_la_debug_read(struct file *file, char __user *userbuf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct ocfs2_super *osb = file->private_data;
> +	int written, ret;
> +	char *buf = osb->local_alloc_debug_buf;
> +
> +	mutex_lock(&la_debug_mutex);
> +	memset(buf, 0, LA_DEBUG_BUF_SZ);
> +
> +	written = snprintf(buf, LA_DEBUG_BUF_SZ,
> +			   "0x%x\t0x%llx\t%u\t%u\t0x%x\n",
> +			   LA_DEBUG_VER,
> +			   (unsigned long long)osb->la_last_gd,
> +			   osb->local_alloc_default_bits,
> +			   osb->local_alloc_bits, osb->local_alloc_state);
> +
> +	ret = simple_read_from_buffer(userbuf, count, ppos, buf, written);
> +
> +	mutex_unlock(&la_debug_mutex);
> +	return ret;
> +}

In fact it can be made static and local to this function.

> +static const struct file_operations ocfs2_la_debug_fops = {
> +	.open =		ocfs2_la_debug_open,
> +	.read =		ocfs2_la_debug_read,
> +};
> +
> +static void ocfs2_init_la_debug(struct ocfs2_super *osb)
> +{
> +	osb->local_alloc_debug_buf = kmalloc(LA_DEBUG_BUF_SZ, GFP_NOFS);
> +	if (!osb->local_alloc_debug_buf)
> +		return;
> +
> +	osb->local_alloc_debug = debugfs_create_file("local_alloc_stats",
> +						     S_IFREG|S_IRUSR,
> +						     osb->osb_debug_root,
> +						     osb,
> +						     &ocfs2_la_debug_fops);
> +	if (!osb->local_alloc_debug) {
> +		kfree(osb->local_alloc_debug_buf);
> +		osb->local_alloc_debug_buf = NULL;
> +	}
> +}
> +
> +static void ocfs2_shutdown_la_debug(struct ocfs2_super *osb)
> +{
> +	if (osb->local_alloc_debug)
> +		debugfs_remove(osb->local_alloc_debug);
> +
> +	if (osb->local_alloc_debug_buf)
> +		kfree(osb->local_alloc_debug_buf);
> +
> +	osb->local_alloc_debug_buf = NULL;
> +	osb->local_alloc_debug = NULL;
> +}
> +#else	/* CONFIG_OCFS2_FS_STATS */
> +static void ocfs2_init_la_debug(struct ocfs2_super *osb)
> +{
> +	return;
> +}
> +static void ocfs2_shutdown_la_debug(struct ocfs2_super *osb)
> +{
> +	return;
> +}
> +#endif
> +
>  static inline int ocfs2_la_state_enabled(struct ocfs2_super *osb)
>  {
>  	return (osb->local_alloc_state == OCFS2_LA_THROTTLED ||
> @@ -146,6 +226,8 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  
>  	mlog_entry_void();
>  
> +	ocfs2_init_la_debug(osb);
> +
>  	if (osb->local_alloc_bits == 0)
>  		goto bail;
>  
> @@ -218,6 +300,9 @@ bail:
>  	if (inode)
>  		iput(inode);
>  
> +	if (status < 0)
> +		ocfs2_shutdown_la_debug(osb);
> +
>  	mlog(0, "Local alloc window bits = %d\n", osb->local_alloc_bits);
>  
>  	mlog_exit(status);
> @@ -247,6 +332,8 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  	cancel_delayed_work(&osb->la_enable_wq);
>  	flush_workqueue(ocfs2_wq);
>  
> +	ocfs2_shutdown_la_debug(osb);
> +
>  	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
>  		goto out;
>  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 4d6e200..1282799 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -272,6 +272,11 @@ struct ocfs2_super
>  
>  	u64 la_last_gd;
>  
> +#ifdef CONFIG_OCFS2_FS_STATS
> +	struct dentry *local_alloc_debug;
> +	char *local_alloc_debug_buf;
> +#endif
> +
>  	/* Next two fields are for local node slot recovery during
>  	 * mount. */
>  	int dirty;
> -- 
> 1.5.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
