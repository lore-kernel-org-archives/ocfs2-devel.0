From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:13 -0700
Subject: [Ocfs2-devel] [patch 19/22] ocfs2: adjust code style for
	o2net_handler_tree_lookup()
Message-ID: <20130827210513.A480031C1D6@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: adjust code style for o2net_handler_tree_lookup()

Code in o2net_handler_tree_lookup() may be corrupted by mistake.  So
adjust it to promote readability.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-adjust-code-style-for-o2net_handler_tree_lookup fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-adjust-code-style-for-o2net_handler_tree_lookup
+++ a/fs/ocfs2/cluster/tcp.c
@@ -766,32 +766,32 @@ static struct o2net_msg_handler *
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
_
