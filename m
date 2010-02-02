From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  1 Feb 2010 17:34:58 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Remove BUG_ON in dlm recovery
	when freeing locks of a dead node
Message-ID: <1265074498-26262-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During recovery, the dlm frees the locks for the dead node. If it finds a
lock in a resource for the dead node, it expects that node to also have a
ref in that lock resource. If not, it BUGs.

ossbz#1175 was filed with the above BUG. Now, while it is correct that we
should be expecting the ref, I see no reason why we have to BUG. After all,
we are freeing up the lock and clearing the ref.

This patch replaces the BUG_ON with a printk(). Hopefully, that will give
us more clues next time this happens.

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1175

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index d9fa3d2..9948308 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2193,7 +2193,12 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 		mlog(0, "%s:%.*s: freed %u locks for dead node %u, "
 		     "dropping ref from lockres\n", dlm->name,
 		     res->lockname.len, res->lockname.name, freed, dead_node);
-		BUG_ON(!test_bit(dead_node, res->refmap));
+		if(!test_bit(dead_node, res->refmap)) {
+			mlog(ML_ERROR, "%s:%.*s: freed %u locks for dead node %u, "
+			     "but ref was not set\n",
+			     res->lockname.len, res->lockname.name, freed, dead_node);
+			__dlm_print_one_lock_resource(res);
+		}
 		dlm_lockres_clear_refmap_bit(dead_node, res);
 	} else if (test_bit(dead_node, res->refmap)) {
 		mlog(0, "%s:%.*s: dead node %u had a ref, but had "
-- 
1.6.3.3
