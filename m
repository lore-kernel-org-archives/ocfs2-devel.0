From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 12 Aug 2013 11:47:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: adjust code style for
	o2net_handler_tree_lookup()
Message-ID: <52085ACC.7080509@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Code in o2net_handler_tree_lookup() may be corrupted by mistake.
So adjust it to promote readability.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/tcp.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index f31b333..3d83058 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -762,32 +762,32 @@ static struct o2net_msg_handler *
 o2net_handler_tree_lookup(u32 msg_type, u32 key, struct rb_node ***ret_p,
 			  struct rb_node **ret_parent)
 {
-        struct rb_node **p = &o2net_handler_tree.rb_node;
-        struct rb_node *parent = NULL;
+	struct rb_node **p = &o2net_handler_tree.rb_node;
+	struct rb_node *parent = NULL;
 	struct o2net_msg_handler *nmh, *ret = NULL;
 	int cmp;
 
-        while (*p) {
-                parent = *p;
-                nmh = rb_entry(parent, struct o2net_msg_handler, nh_node);
+	while (*p) {
+		parent = *p;
+		nmh = rb_entry(parent, struct o2net_msg_handler, nh_node);
 		cmp = o2net_handler_cmp(nmh, msg_type, key);
 
-                if (cmp < 0)
-                        p = &(*p)->rb_left;
-                else if (cmp > 0)
-                        p = &(*p)->rb_right;
-                else {
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else if (cmp > 0)
+			p = &(*p)->rb_right;
+		else {
 			ret = nmh;
-                        break;
+			break;
 		}
-        }
+	}
 
-        if (ret_p != NULL)
-                *ret_p = p;
-        if (ret_parent != NULL)
-                *ret_parent = parent;
+	if (ret_p != NULL)
+		*ret_p = p;
+	if (ret_parent != NULL)
+		*ret_parent = parent;
 
-        return ret;
+	return ret;
 }
 
 static void o2net_handler_kref_release(struct kref *kref)
-- 
1.7.9.7
