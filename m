From: tristan.ye <tristan.ye@oracle.com>
Date: Wed, 17 Dec 2008 17:03:25 +0800
Subject: [Ocfs2-devel] [PATCH 1/9] ocfs2/hb: Exposes list
	of	heartbeating nodes via debugfs
In-Reply-To: <1229471363-15887-2-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
	<1229471363-15887-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1229504605.411.5.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2008-12-16 at 15:49 -0800, Sunil Mushran wrote:
> Patch creates a debugfs file, o2hb/livesnodes, which exposes the aggregate
> list of heartbeating node across all heartbeat regions.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c   |  140 +++++++++++++++++++++++++++++++++++++++-
>  fs/ocfs2/cluster/heartbeat.h   |    3 +-
>  fs/ocfs2/cluster/nodemanager.c |    9 ++-
>  3 files changed, 148 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index 6ebaa58..7e9d25c 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -33,6 +33,7 @@
>  #include <linux/random.h>
>  #include <linux/crc32.h>
>  #include <linux/time.h>
> +#include <linux/debugfs.h>
>  
>  #include "heartbeat.h"
>  #include "tcp.h"
> @@ -60,6 +61,11 @@ static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
>  static LIST_HEAD(o2hb_node_events);
>  static DECLARE_WAIT_QUEUE_HEAD(o2hb_steady_queue);
>  
> +#define O2HB_DEBUG_DIR			"o2hb"
> +#define O2HB_DEBUG_LIVENODES		"livenodes"
> +static struct dentry *o2hb_debug_dir;
> +static struct dentry *o2hb_debug_livenodes;
> +
>  static LIST_HEAD(o2hb_all_regions);
>  
>  static struct o2hb_callback {
> @@ -905,7 +911,121 @@ static int o2hb_thread(void *data)
>  	return 0;
>  }
>  
> -void o2hb_init(void)
> +#ifdef CONFIG_DEBUG_FS
> +struct o2hb_debug_buffer {
> +	int len;
> +	char *buf;
> +};
> +
> +static int o2hb_debug_open(struct inode *inode, struct file *file)

Just be curious that why the arg 'inode' kept here since it never be
refered in below func body.
so as the func o2hb_debug_release()

> +{
> +	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +	struct o2hb_debug_buffer *odb = NULL;
> +	int i = -1;
> +	int out = 0;
> +
> +	odb = kzalloc(sizeof(struct o2hb_debug_buffer), GFP_KERNEL);
> +	if (!odb)
> +		goto bail;
> +
> +	odb->len = PAGE_SIZE;
> +	odb->buf = kmalloc(odb->len, GFP_KERNEL);
> +	if (!odb->buf) {
> +		kfree(odb);
> +		goto bail;
> +	}
> +
> +	o2hb_fill_node_map(map, sizeof(map));
> +
> +	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
> +		out += snprintf(odb->buf + out, odb->len - out, "%d ", i);
> +	out += snprintf(odb->buf + out, odb->len - out, "\n");
> +
> +	odb->len = out;
> +
> +	file->private_data = odb;
> +
> +	return 0;
> +bail:
> +	return -ENOMEM;
> +}
> +
> +static int o2hb_debug_release(struct inode *inode, struct file *file)
> +{
> +	struct o2hb_debug_buffer *odb =
> +			(struct o2hb_debug_buffer *)file->private_data;
> +
> +	kfree(odb->buf);
> +	kfree(odb);
> +
> +	return 0;
> +}
> +
> +static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
> +				 size_t nbytes, loff_t *ppos)
> +{
> +	struct o2hb_debug_buffer *odb =
> +			(struct o2hb_debug_buffer *)file->private_data;
> +
> +	return simple_read_from_buffer(buf, nbytes, ppos, odb->buf, odb->len);
> +}
> +
> +static loff_t o2hb_debug_llseek(struct file *file, loff_t off, int whence)
> +{
> +	struct o2hb_debug_buffer *odb =
> +			(struct o2hb_debug_buffer *)file->private_data;
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
> +	if (new < 0 || new > odb->len)
> +		return -EINVAL;
> +
> +	return (file->f_pos = new);
> +}
> +#else
> +static int o2hb_debug_open(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}
> +static int o2hb_debug_release(struct inode *inode, struct file *file)
> +{
> +	return 0;
> +}
> +static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
> +			       size_t nbytes, loff_t *ppos)
> +{
> +	return 0;
> +}
> +static loff_t o2hb_debug_llseek(struct file *file, loff_t off, int whence)
> +{
> +	return 0;
> +}
> +#endif  /* CONFIG_DEBUG_FS */
> +
> +static struct file_operations o2hb_debug_fops = {
> +	.open =		o2hb_debug_open,
> +	.release =	o2hb_debug_release,
> +	.read =		o2hb_debug_read,
> +	.llseek =	o2hb_debug_llseek,
> +};
> +
> +void o2hb_exit(void)
> +{
> +	if (o2hb_debug_livenodes)
> +		debugfs_remove(o2hb_debug_livenodes);
> +	if (o2hb_debug_dir)
> +		debugfs_remove(o2hb_debug_dir);
> +}
> +
> +int o2hb_init(void)
>  {
>  	int i;
>  
> @@ -918,6 +1038,24 @@ void o2hb_init(void)
>  	INIT_LIST_HEAD(&o2hb_node_events);
>  
>  	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
> +
> +	o2hb_debug_dir = debugfs_create_dir(O2HB_DEBUG_DIR, NULL);
> +	if (!o2hb_debug_dir) {
> +		mlog_errno(-ENOMEM);
> +		return -ENOMEM;
> +	}
> +
> +	o2hb_debug_livenodes = debugfs_create_file(O2HB_DEBUG_LIVENODES,
> +						   S_IFREG|S_IRUSR,
> +						   o2hb_debug_dir, NULL,
> +						   &o2hb_debug_fops);
> +	if (!o2hb_debug_livenodes) {
> +		mlog_errno(-ENOMEM);
> +		debugfs_remove(o2hb_debug_dir);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
>  }
>  
>  /* if we're already in a callback then we're already serialized by the sem */
> diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
> index e511339..2f16492 100644
> --- a/fs/ocfs2/cluster/heartbeat.h
> +++ b/fs/ocfs2/cluster/heartbeat.h
> @@ -75,7 +75,8 @@ void o2hb_unregister_callback(const char *region_uuid,
>  			      struct o2hb_callback_func *hc);
>  void o2hb_fill_node_map(unsigned long *map,
>  			unsigned bytes);
> -void o2hb_init(void);
> +void o2hb_exit(void);
> +int o2hb_init(void);
>  int o2hb_check_node_heartbeating(u8 node_num);
>  int o2hb_check_node_heartbeating_from_callback(u8 node_num);
>  int o2hb_check_local_node_heartbeating(void);
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index 816a3f6..2ce28d7 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -881,6 +881,7 @@ static void __exit exit_o2nm(void)
>  	o2cb_sys_shutdown();
>  
>  	o2net_exit();
> +	o2hb_exit();
>  }
>  
>  static int __init init_o2nm(void)
> @@ -889,11 +890,13 @@ static int __init init_o2nm(void)
>  
>  	cluster_print_version();
>  
> -	o2hb_init();
> +	ret = o2hb_init();
> +	if (ret)
> +		goto out;
>  
>  	ret = o2net_init();
>  	if (ret)
> -		goto out;
> +		goto out_o2hb;
>  
>  	ret = o2net_register_hb_callbacks();
>  	if (ret)
> @@ -916,6 +919,8 @@ out_callbacks:
>  	o2net_unregister_hb_callbacks();
>  out_o2net:
>  	o2net_exit();
> +out_o2hb:
> +	o2hb_exit();
>  out:
>  	return ret;
>  }
