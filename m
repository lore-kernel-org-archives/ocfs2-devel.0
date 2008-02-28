From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb 28 17:05:26 2008
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2_net: Debug interface added to
	o2net
In-Reply-To: <1204081700-29323-2-git-send-email-sunil.mushran@oracle.com>
References: <1204081700-29323-1-git-send-email-sunil.mushran@oracle.com>
	<1204081700-29323-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080229010338.GU23975@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 26, 2008 at 07:08:20PM -0800, Sunil Mushran wrote:
> This patch is a forward port of net_proc.c in OCFS2 1.2. The difference
> here is that the debugging funtionality is exposed via debugfs.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	Please run this through checkpatch.pl - there are some style
cleanups needed.

Joel

> ---
>  fs/ocfs2/cluster/Makefile       |    1 +
>  fs/ocfs2/cluster/netdebug.c     |  433 +++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/cluster/nodemanager.c  |    5 +-
>  fs/ocfs2/cluster/tcp.c          |   22 ++
>  fs/ocfs2/cluster/tcp.h          |    7 +
>  fs/ocfs2/cluster/tcp_internal.h |   19 ++
>  6 files changed, 486 insertions(+), 1 deletions(-)
>  create mode 100644 fs/ocfs2/cluster/netdebug.c
> 
> diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
> index 08cf6cb..05d9567 100644
> --- a/fs/ocfs2/cluster/Makefile
> +++ b/fs/ocfs2/cluster/Makefile
> @@ -41,6 +41,7 @@ endif
>  SOURCES +=			\
>  	heartbeat.c		\
>  	masklog.c		\
> +	netdebug.c		\
>  	nodemanager.c		\
>  	quorum.c		\
>  	sys.c			\
> diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
> new file mode 100644
> index 0000000..df7fd8e
> --- /dev/null
> +++ b/fs/ocfs2/cluster/netdebug.c
> @@ -0,0 +1,433 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * netdebug.c
> + *
> + * debug functionality for o2net
> + *
> + * Copyright (C) 2005, 2008 Oracle.  All rights reserved.
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
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/idr.h>
> +#include <linux/kref.h>
> +#include <linux/seq_file.h>
> +#include <linux/debugfs.h>
> +
> +#include <asm/uaccess.h>
> +
> +#include "tcp.h"
> +#include "nodemanager.h"
> +#define MLOG_MASK_PREFIX ML_TCP
> +#include "masklog.h"
> +
> +#include "tcp_internal.h"
> +
> +#define O2NET_DEBUG_DIR		"o2net"
> +#define SC_DEBUG_NAME		"sock_containers"
> +#define NST_DEBUG_NAME		"send_tracking"
> +
> +static struct dentry *o2net_dentry = NULL;
> +static struct dentry *sc_dentry = NULL;
> +static struct dentry *nst_dentry = NULL;
> +
> +static spinlock_t o2net_debug_lock = SPIN_LOCK_UNLOCKED;
> +
> +static LIST_HEAD(sock_containers);
> +static LIST_HEAD(send_tracking);
> +
> +void o2net_debug_add_nst(struct o2net_send_tracking *nst)
> +{
> +	spin_lock(&o2net_debug_lock);
> +	list_add(&nst->st_net_debug_item, &send_tracking);
> +	spin_unlock(&o2net_debug_lock);
> +}
> +
> +void o2net_debug_del_nst(struct o2net_send_tracking *nst)
> +{
> +	spin_lock(&o2net_debug_lock);
> +	if (!list_empty(&nst->st_net_debug_item))
> +		list_del_init(&nst->st_net_debug_item);
> +	spin_unlock(&o2net_debug_lock);
> +}
> +
> +static struct o2net_send_tracking *next_nst(struct o2net_send_tracking *nst_start)
> +{
> +	struct o2net_send_tracking *nst, *ret = NULL;
> +
> +	assert_spin_locked(&o2net_debug_lock);
> +
> +	list_for_each_entry(nst, &nst_start->st_net_debug_item,
> +			    st_net_debug_item) {
> +		/* discover the head of the list */
> +		if (&nst->st_net_debug_item == &send_tracking)
> +			break;
> +
> +		/* use st_task to detect real nsts in the list */
> +		if (nst->st_task != NULL) {
> +			ret = nst;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void *nst_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
> +
> +	spin_lock(&o2net_debug_lock);
> +	nst = next_nst(dummy_nst);
> +	spin_unlock(&o2net_debug_lock);
> +
> +	return nst;
> +}
> +
> +static void *nst_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
> +
> +	spin_lock(&o2net_debug_lock);
> +	nst = next_nst(dummy_nst);
> +	list_del_init(&dummy_nst->st_net_debug_item);
> +	if (nst)
> +		list_add(&dummy_nst->st_net_debug_item,
> +			 &nst->st_net_debug_item);
> +	spin_unlock(&o2net_debug_lock);
> +
> +	return nst; /* unused, just needs to be null when done */
> +}
> +
> +static int nst_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
> +
> +	spin_lock(&o2net_debug_lock);
> +	nst = next_nst(dummy_nst);
> +
> +	if (nst != NULL) {
> +		/* get_task_comm isn't exported.  oh well. */
> +		seq_printf(seq, "%p:\n"
> +			   "  pid:          %lu\n"
> +			   "  tgid:         %lu\n"
> +			   "  process name: %s\n"
> +			   "  node:         %u\n"
> +			   "  sc:           %p\n"
> +			   "  message id:   %d\n"
> +			   "  message type: %u\n"
> +			   "  message key:  0x%08x\n"
> +			   "  sock acquiry: %lu.%lu\n"
> +			   "  send start:   %lu.%lu\n"
> +			   "  wait start:   %lu.%lu\n",
> +			   nst, (unsigned long)nst->st_task->pid,
> +			   (unsigned long)nst->st_task->tgid,
> +			   nst->st_task->comm, nst->st_node,
> +			   nst->st_sc, nst->st_id, nst->st_msg_type,
> +			   nst->st_msg_key,
> +			   nst->st_sock_time.tv_sec, nst->st_sock_time.tv_usec,
> +			   nst->st_send_time.tv_sec, nst->st_send_time.tv_usec,
> +			   nst->st_status_time.tv_sec,
> +			   nst->st_status_time.tv_usec);
> +	}
> +
> +	spin_unlock(&o2net_debug_lock);
> +
> +	return 0;
> +}
> +
> +static void nst_seq_stop(struct seq_file *seq, void *v)
> +{
> +}
> +
> +static struct seq_operations nst_seq_ops = {
> +	.start = nst_seq_start,
> +	.next = nst_seq_next,
> +	.stop = nst_seq_stop,
> +	.show = nst_seq_show,
> +};
> +
> +static int nst_fop_open(struct inode *inode, struct file *file)
> +{
> +	struct o2net_send_tracking *dummy_nst;
> +	struct seq_file *seq;
> +	int ret;
> +
> +	dummy_nst = kmalloc(sizeof(struct o2net_send_tracking), GFP_KERNEL);
> +	if (dummy_nst == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	dummy_nst->st_task = NULL;
> +
> +	ret = seq_open(file, &nst_seq_ops);
> +	if (ret)
> +		goto out;
> +
> +	seq = file->private_data;
> +	seq->private = dummy_nst;
> +	o2net_debug_add_nst(dummy_nst);
> +
> +	dummy_nst = NULL;
> +
> +out:
> +	kfree(dummy_nst);
> +	return ret;
> +}
> +
> +static int nst_fop_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = file->private_data;
> +	struct o2net_send_tracking *dummy_nst = seq->private;
> +
> +	o2net_debug_del_nst(dummy_nst);
> +	return seq_release_private(inode, file);
> +}
> +
> +static struct file_operations nst_seq_fops = {
> +	.open = nst_fop_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = nst_fop_release,
> +};
> +
> +void o2net_debug_add_sc(struct o2net_sock_container *sc)
> +{
> +	spin_lock(&o2net_debug_lock);
> +	list_add(&sc->sc_net_debug_item, &sock_containers);
> +	spin_unlock(&o2net_debug_lock);
> +}
> +
> +void o2net_debug_del_sc(struct o2net_sock_container *sc)
> +{
> +	spin_lock(&o2net_debug_lock);
> +	list_del_init(&sc->sc_net_debug_item);
> +	spin_unlock(&o2net_debug_lock);
> +}
> +
> +static struct o2net_sock_container *next_sc(struct o2net_sock_container *sc_start)
> +{
> +	struct o2net_sock_container *sc, *ret = NULL;
> +
> +	assert_spin_locked(&o2net_debug_lock);
> +
> +	list_for_each_entry(sc, &sc_start->sc_net_debug_item, sc_net_debug_item) {
> +		/* discover the head of the list miscast as a sc */
> +		if (&sc->sc_net_debug_item == &sock_containers)
> +			break;
> +
> +		/* use sc_page to detect real scs in the list */
> +		if (sc->sc_page != NULL) {
> +			ret = sc;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void *sc_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct o2net_sock_container *sc, *dummy_sc = seq->private;
> +
> +	spin_lock(&o2net_debug_lock);
> +	sc = next_sc(dummy_sc);
> +	spin_unlock(&o2net_debug_lock);
> +
> +	return sc;
> +}
> +
> +static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct o2net_sock_container *sc, *dummy_sc = seq->private;
> +
> +	spin_lock(&o2net_debug_lock);
> +	sc = next_sc(dummy_sc);
> +	list_del_init(&dummy_sc->sc_net_debug_item);
> +	if (sc)
> +		list_add(&dummy_sc->sc_net_debug_item, &sc->sc_net_debug_item);
> +	spin_unlock(&o2net_debug_lock);
> +
> +	return sc; /* unused, just needs to be null when done */
> +}
> +
> +#define TV_SEC_USEC(TV) TV.tv_sec, TV.tv_usec
> +
> +static int sc_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct o2net_sock_container *sc, *dummy_sc = seq->private;
> +
> +	spin_lock(&o2net_debug_lock);
> +	sc = next_sc(dummy_sc);
> +
> +	if (sc != NULL) {
> +		struct inet_sock *inet = NULL;
> +
> +		__be32 saddr = 0, daddr = 0;
> +		__be16 sport = 0, dport = 0;
> +
> +		if (sc->sc_sock) {
> +			inet = inet_sk(sc->sc_sock->sk);
> +			/* the stack's structs aren't sparse endian clean */
> +			saddr = (__force __be32)inet->saddr;
> +			daddr = (__force __be32)inet->daddr;
> +			sport = (__force __be16)inet->sport;
> +			dport = (__force __be16)inet->dport;
> +		}
> +
> +		/* XXX sigh, inet-> doesn't have sparse annotation so any
> +		 * use of it here generates a warning with -Wbitwise */
> +		seq_printf(seq, "%p:\n"
> +			   "  krefs:           %d\n"
> +			   "  sock:            %u.%u.%u.%u:%u -> %u.%u.%u.%u:%u\n"
> +			   "  remote node:     %s\n"
> +			   "  page off:        %zu\n"
> +			   "  handshake ok:    %u\n"
> +			   "  timer:           %lu.%lu\n"
> +			   "  data ready:      %lu.%lu\n"
> +			   "  advance start:   %lu.%lu\n"
> +			   "  advance stop:    %lu.%lu\n"
> +			   "  func start:      %lu.%lu\n"
> +			   "  func stop:       %lu.%lu\n"
> +			   "  func key:        %u\n"
> +			   "  func type:       %u\n",
> +			   sc,
> +			   atomic_read(&sc->sc_kref.refcount),
> +			   NIPQUAD(saddr), inet ? ntohs(sport) : 0,
> +			   	NIPQUAD(daddr), inet ? ntohs(dport) : 0,
> +			   sc->sc_node->nd_name,
> +			   sc->sc_page_off,
> +			   sc->sc_handshake_ok,
> +			   TV_SEC_USEC(sc->sc_tv_timer),
> +			   TV_SEC_USEC(sc->sc_tv_data_ready),
> +			   TV_SEC_USEC(sc->sc_tv_advance_start),
> +			   TV_SEC_USEC(sc->sc_tv_advance_stop),
> +			   TV_SEC_USEC(sc->sc_tv_func_start),
> +			   TV_SEC_USEC(sc->sc_tv_func_stop),
> +			   sc->sc_msg_key,
> +			   sc->sc_msg_type);
> +	}
> +
> +
> +	spin_unlock(&o2net_debug_lock);
> +
> +	return 0;
> +}
> +
> +static void sc_seq_stop(struct seq_file *seq, void *v)
> +{
> +}
> +
> +static struct seq_operations sc_seq_ops = {
> +	.start = sc_seq_start,
> +	.next = sc_seq_next,
> +	.stop = sc_seq_stop,
> +	.show = sc_seq_show,
> +};
> +
> +static int sc_fop_open(struct inode *inode, struct file *file)
> +{
> +	struct o2net_sock_container *dummy_sc;
> +	struct seq_file *seq;
> +	int ret;
> +
> +	dummy_sc = kmalloc(sizeof(struct o2net_sock_container), GFP_KERNEL);
> +	if (dummy_sc == NULL) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	dummy_sc->sc_page = NULL;
> +
> +	ret = seq_open(file, &sc_seq_ops);
> +	if (ret)
> +		goto out;
> +
> +	seq = file->private_data;
> +	seq->private = dummy_sc;
> +	o2net_debug_add_sc(dummy_sc);
> +
> +	dummy_sc = NULL;
> +
> +out:
> +	kfree(dummy_sc);
> +	return ret;
> +}
> +
> +static int sc_fop_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *seq = file->private_data;
> +	struct o2net_sock_container *dummy_sc = seq->private;
> +
> +	o2net_debug_del_sc(dummy_sc);
> +	return seq_release_private(inode, file);
> +}
> +
> +static struct file_operations sc_seq_fops = {
> +	.open = sc_fop_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = sc_fop_release,
> +};
> +
> +int o2net_debugfs_init(void)
> +{
> +	o2net_dentry = debugfs_create_dir(O2NET_DEBUG_DIR, NULL);
> +	if (!o2net_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	nst_dentry = debugfs_create_file(NST_DEBUG_NAME, S_IFREG|S_IRUSR,
> +					 o2net_dentry, NULL,
> +					 &nst_seq_fops);
> +	if (!nst_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	sc_dentry = debugfs_create_file(SC_DEBUG_NAME, S_IFREG|S_IRUSR,
> +					o2net_dentry, NULL,
> +					&sc_seq_fops);
> +	if (!sc_dentry) {
> +		mlog_errno(-ENOMEM);
> +		goto bail;
> +	}
> +
> +	return 0;
> +bail:
> +	if (sc_dentry)
> +		debugfs_remove(sc_dentry);
> +	if (nst_dentry)
> +		debugfs_remove(nst_dentry);
> +	if (o2net_dentry)
> +		debugfs_remove(o2net_dentry);
> +	return -ENOMEM;
> +}
> +
> +void o2net_debugfs_exit(void)
> +{
> +	if (sc_dentry)
> +		debugfs_remove(sc_dentry);
> +	if (nst_dentry)
> +		debugfs_remove(nst_dentry);
> +	if (o2net_dentry)
> +		debugfs_remove(o2net_dentry);
> +}
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index cb06ef4..c496ae0 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -960,7 +960,10 @@ static int __init init_o2nm(void)
>  	cluster_print_version();
>  
>  	o2hb_init();
> -	o2net_init();
> +
> +	ret = o2net_init();
> +	if (ret)
> +		goto out;
>  
>  	ocfs2_table_header = kapi_register_sysctl_table(ocfs2_root_table);
>  	if (!ocfs2_table_header) {
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index c92b883..3b0a31a 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -303,6 +303,7 @@ static void sc_kref_release(struct kref *kref)
>  	o2nm_node_put(sc->sc_node);
>  	sc->sc_node = NULL;
>  
> +	o2net_debug_del_sc(sc);
>  	kfree(sc);
>  }
>  
> @@ -343,6 +344,7 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)
>  
>  	ret = sc;
>  	sc->sc_page = page;
> +	o2net_debug_add_sc(sc);
>  	sc = NULL;
>  	page = NULL;
>  
> @@ -927,6 +929,13 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
>  	struct o2net_status_wait nsw = {
>  		.ns_node_item = LIST_HEAD_INIT(nsw.ns_node_item),
>  	};
> +	struct o2net_send_tracking nst = {
> +		.st_net_debug_item = LIST_HEAD_INIT(nst.st_net_debug_item),
> +		.st_task = current,
> +		.st_msg_type = msg_type,
> +		.st_msg_key = key,
> +		.st_node = target_node,
> +	};
>  
>  	if (o2net_wq == NULL) {
>  		mlog(0, "attempt to tx without o2netd running\n");
> @@ -952,6 +961,9 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
>  		goto out;
>  	}
>  
> +	o2net_debug_add_nst(&nst);
> +
> +	do_gettimeofday(&nst.st_sock_time);
>  	ret = wait_event_interruptible(nn->nn_sc_wq,
>  				       o2net_tx_can_proceed(nn, &sc, &error));
>  	if (!ret && error)
> @@ -959,6 +971,8 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
>  	if (ret)
>  		goto out;
>  
> +	nst.st_sc = sc;
> +
>  	veclen = caller_veclen + 1;
>  	vec = kmalloc(sizeof(struct kvec) * veclen, GFP_ATOMIC);
>  	if (vec == NULL) {
> @@ -985,7 +999,9 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
>  		goto out;
>  
>  	msg->msg_num = cpu_to_be32(nsw.ns_id);
> +	nst.st_id = nsw.ns_id;
>  
> +	do_gettimeofday(&nst.st_send_time);
>  	/* finally, convert the message header to network byte-order
>  	 * and send */
>  	mutex_lock(&sc->sc_send_lock);
> @@ -999,6 +1015,7 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
>  	}
>  
>  	/* wait on other node's handler */
> +	do_gettimeofday(&nst.st_status_time);
>  	wait_event(nsw.ns_wq, o2net_nsw_completed(nn, &nsw));
>  
>  	/* Note that we avoid overwriting the callers status return
> @@ -1011,6 +1028,7 @@ int o2net_send_message_vec(u32 msg_type, u32 key, struct kvec *caller_vec,
>  	mlog(0, "woken, returning system status %d, user status %d\n",
>  	     ret, nsw.ns_status);
>  out:
> +	o2net_debug_del_nst(&nst); /* must be before dropping sc and node */
>  	if (sc)
>  		sc_put(sc);
>  	if (vec)
> @@ -1951,6 +1969,9 @@ int o2net_init(void)
>  
>  	o2quo_init();
>  
> +	if (o2net_debugfs_init())
> +		return -ENOMEM;
> +
>  	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
>  	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
>  	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
> @@ -1992,4 +2013,5 @@ void o2net_exit(void)
>  	kfree(o2net_hand);
>  	kfree(o2net_keep_req);
>  	kfree(o2net_keep_resp);
> +	o2net_debugfs_exit();
>  }
> diff --git a/fs/ocfs2/cluster/tcp.h b/fs/ocfs2/cluster/tcp.h
> index f36f66a..64bc41a 100644
> --- a/fs/ocfs2/cluster/tcp.h
> +++ b/fs/ocfs2/cluster/tcp.h
> @@ -117,4 +117,11 @@ int o2net_num_connected_peers(void);
>  int o2net_init(void);
>  void o2net_exit(void);
>  
> +int o2net_debugfs_init(void);
> +void o2net_debugfs_exit(void);
> +
> +struct o2net_send_tracking;
> +void o2net_debug_add_nst(struct o2net_send_tracking *nst);
> +void o2net_debug_del_nst(struct o2net_send_tracking *nst);
> +
>  #endif /* O2CLUSTER_TCP_H */
> diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
> index fe1a407..8a45b6c 100644
> --- a/fs/ocfs2/cluster/tcp_internal.h
> +++ b/fs/ocfs2/cluster/tcp_internal.h
> @@ -158,6 +158,8 @@ struct o2net_sock_container {
>  	void			(*sc_state_change)(struct sock *sk);
>  	void			(*sc_data_ready)(struct sock *sk, int bytes);
>  
> +	struct list_head        sc_net_debug_item;
> +
>  	struct timeval 		sc_tv_timer;
>  	struct timeval 		sc_tv_data_ready;
>  	struct timeval 		sc_tv_advance_start;
> @@ -199,4 +201,21 @@ struct o2net_status_wait {
>  	struct list_head	ns_node_item;
>  };
>  
> +/* just for state dumps */
> +struct o2net_send_tracking {
> +	struct list_head		st_net_debug_item;
> +	struct task_struct		*st_task;
> +	struct o2net_sock_container	*st_sc;
> +	u32				st_id;
> +	u32				st_msg_type;
> +	u32				st_msg_key;
> +	u8				st_node;
> +	struct timeval			st_sock_time;
> +	struct timeval			st_send_time;
> +	struct timeval			st_status_time;
> +};
> +
> +void o2net_debug_add_sc(struct o2net_sock_container *sc);
> +void o2net_debug_del_sc(struct o2net_sock_container *sc);
> +
>  #endif /* O2CLUSTER_TCP_INTERNAL_H */
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
