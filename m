From: Matthew Wilcox <willy@infradead.org>
Date: Thu, 26 Mar 2020 13:02:14 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use memalloc_nofs_save instead of
	memalloc_noio_save
Message-ID: <20200326200214.1102-1-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

OCFS2 doesn't mind if memory reclaim makes I/Os happen; it just cares
that it won't be reentered, so it can use memalloc_nofs_save() instead
of memalloc_noio_save().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/cluster/tcp.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 9261c1f06a9f..2c512b40a940 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1570,15 +1570,13 @@ static void o2net_start_connect(struct work_struct *work)
 	struct sockaddr_in myaddr = {0, }, remoteaddr = {0, };
 	int ret = 0, stop;
 	unsigned int timeout;
-	unsigned int noio_flag;
+	unsigned int nofs_flag;
 
 	/*
-	 * sock_create allocates the sock with GFP_KERNEL. We must set
-	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
-	 * by this process are done as if GFP_NOIO was specified. So we
-	 * are not reentering filesystem while doing memory reclaim.
+	 * sock_create allocates the sock with GFP_KERNEL. We must
+	 * prevent the filesystem from being reentered by memory reclaim.
 	 */
-	noio_flag = memalloc_noio_save();
+	nofs_flag = memalloc_nofs_save();
 	/* if we're greater we initiate tx, otherwise we accept */
 	if (o2nm_this_node() <= o2net_num_from_nn(nn))
 		goto out;
@@ -1683,7 +1681,7 @@ static void o2net_start_connect(struct work_struct *work)
 	if (mynode)
 		o2nm_node_put(mynode);
 
-	memalloc_noio_restore(noio_flag);
+	memalloc_nofs_restore(nofs_flag);
 	return;
 }
 
@@ -1810,15 +1808,13 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	struct o2nm_node *local_node = NULL;
 	struct o2net_sock_container *sc = NULL;
 	struct o2net_node *nn;
-	unsigned int noio_flag;
+	unsigned int nofs_flag;
 
 	/*
-	 * sock_create_lite allocates the sock with GFP_KERNEL. We must set
-	 * per-process flag PF_MEMALLOC_NOIO so that all allocations done
-	 * by this process are done as if GFP_NOIO was specified. So we
-	 * are not reentering filesystem while doing memory reclaim.
+	 * sock_create_lite allocates the sock with GFP_KERNEL. We must
+	 * prevent the filesystem from being reentered by memory reclaim.
 	 */
-	noio_flag = memalloc_noio_save();
+	nofs_flag = memalloc_nofs_save();
 
 	BUG_ON(sock == NULL);
 	*more = 0;
@@ -1934,7 +1930,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	if (sc)
 		sc_put(sc);
 
-	memalloc_noio_restore(noio_flag);
+	memalloc_nofs_restore(nofs_flag);
 	return ret;
 }
 
-- 
2.25.1
