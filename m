From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Dec 2010 14:14:27 -0800
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2/cluster: Pin the remote node item
	in configfs
In-Reply-To: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
References: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292364871-18461-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2net pins the node item of the remote node in configfs before initiating
the connection. It is unpinned on disconnect. This is to prevent the node
item from being unlinked while it is still in use.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/tcp.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 9aa426e..92de96c 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -355,6 +355,7 @@ static void sc_kref_release(struct kref *kref)
 		sc->sc_sock = NULL;
 	}
 
+	o2nm_undepend_item(&sc->sc_node->nd_item);
 	o2nm_node_put(sc->sc_node);
 	sc->sc_node = NULL;
 
@@ -376,6 +377,7 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)
 {
 	struct o2net_sock_container *sc, *ret = NULL;
 	struct page *page = NULL;
+	int status = 0;
 
 	page = alloc_page(GFP_NOFS);
 	sc = kzalloc(sizeof(*sc), GFP_NOFS);
@@ -386,6 +388,13 @@ static struct o2net_sock_container *sc_alloc(struct o2nm_node *node)
 	o2nm_node_get(node);
 	sc->sc_node = node;
 
+	/* pin the node item of the remote node */
+	status = o2nm_depend_item(&node->nd_item);
+	if (status) {
+		mlog_errno(status);
+		o2nm_node_put(node);
+		goto out;
+	}
 	INIT_WORK(&sc->sc_connect_work, o2net_sc_connect_completed);
 	INIT_WORK(&sc->sc_rx_work, o2net_rx_until_empty);
 	INIT_WORK(&sc->sc_shutdown_work, o2net_shutdown_sc);
-- 
1.7.1
