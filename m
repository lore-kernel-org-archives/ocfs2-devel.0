From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Dec 2008 17:08:11 -0800
Subject: [Ocfs2-devel] [PATCH 1/9] ocfs2/hb: Exposes list of
	heartbeating nodes via debugfs
In-Reply-To: <1229471363-15887-2-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
	<1229471363-15887-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20081217010811.GA8791@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 16, 2008 at 03:49:15PM -0800, Sunil Mushran wrote:
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

Why can't this just use generic_file_llseek?
	--Mark

--
Mark Fasheh
