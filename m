From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 17 Sep 2014 17:58:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a deadlock while o2net_wq doing
 direct memory reclaim
Message-ID: <54195B2D.9040405@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The patch fix a deadlock problem caused by direct memory reclaim in
o2net_wq. The situation is as follows:

1) Receiving a connect message from another node, node queues a
work_struct o2net_listen_work.
2) o2net_wq processes this work and call the following functions:
o2net_wq
-> o2net_accept_one
  -> sock_create_lite
    -> sock_alloc()
      -> kmem_cache_alloc with GFP_KERNEL
        -> ____cache_alloc_node
          ->__alloc_pages_nodemask
            -> do_try_to_free_pages
              -> shrink_slab
                -> evict
                  -> ocfs2_evict_inode
                    -> ocfs2_drop_lock
                      -> dlmunlock
                        -> o2net_send_message_vec
then o2net_wq wait for the unlock reply from master.
3)tcp layer received the reply, call o2net_data_ready() and
queue sc_rx_work, waiting o2net_wq to process this work.
4)o2net_wq is a single thread workqueue, it process the work one by
one. Right now it is still doing o2net_listen_work and cannot handle
sc_rx_work. so we deadlock.

Junxiao Bi's patch
(http://ozlabs.org/~akpm/mmots/broken-out/mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch)
clearing __GFP_FS in memalloc_noio_flags() besides __GFP_IO.
We use memalloc_noio_save() to set process flag PF_MEMALLOC_NOIO
so that all allocations done by this process are done as if GFP_NOIO was
specified. We are not reentering filesystem while doing memory reclaim.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/cluster/tcp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index ea34952..e607937 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1601,7 +1601,15 @@ static void o2net_start_connect(struct work_struct *work)
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
 	int ret = 0, stop;
 	unsigned int timeout;
+	unsigned int noio_flag;
 
+	/*
+	 * sock_create allocates the sock with GFP_KERNEL. We must set
+	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
+	 * by this process are done as if GFP_NOIO was specified. So we
+	 * are not reentering filesystem while doing memory reclaim.
+	 */
+	noio_flag = memalloc_noio_save();
 	/* if we're greater we initiate tx, otherwise we accept */
 	if (o2nm_this_node() <= o2net_num_from_nn(nn))
 		goto out;
@@ -1710,6 +1718,7 @@ out:
 	if (mynode)
 		o2nm_node_put(mynode);
 
+	memalloc_noio_restore(noio_flag);
 	return;
 }
 
@@ -1835,6 +1844,15 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	struct o2nm_node *local_node = NULL;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
+	unsigned int noio_flag;
+
+	/*
+	 * sock_create_lite allocates the sock with GFP_KERNEL. We must set
+	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
+	 * by this process are done as if GFP_NOIO was specified. So we
+	 * are not reentering filesystem while doing memory reclaim.
+	 */
+	noio_flag = memalloc_noio_save();
 
 	BUG_ON(sock == NULL);
 	*more = 0;
@@ -1951,6 +1969,8 @@ out:
 		o2nm_node_put(local_node);
 	if (sc)
 		sc_put(sc);
+
+	memalloc_noio_restore(noio_flag);
 	return ret;
 }
 
-- 
1.8.4.3
