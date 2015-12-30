From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 30 Dec 2015 13:26:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: remove redundant code
Message-ID: <1451453199-13450-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Found this when do patch review, remove to make it clear and save
a little cpu time.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 9e4f862d20fe..42cac5f01a96 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2450,11 +2450,7 @@ static void __dlm_hb_node_down(struct dlm_ctxt *dlm, int idx)
 	 * perhaps later we can genericize this for other waiters. */
 	wake_up(&dlm->migration_wq);
 
-	if (test_bit(idx, dlm->recovery_map))
-		mlog(0, "domain %s, node %u already added "
-		     "to recovery map!\n", dlm->name, idx);
-	else
-		set_bit(idx, dlm->recovery_map);
+	set_bit(idx, dlm->recovery_map);
 }
 
 void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data)
-- 
1.7.9.5
