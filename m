From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 22 Oct 2014 11:13:07 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: fix an off-by-one BUG_ON() statement
Message-ID: <20141022081307.GC31384@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ->si_slots[] array is allocated in ocfs2_init_slot_info() it has
"->max_slots" number of elements so this test should be >= instead of >.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker work.  Compile tested only.

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index a88b2a4..d5493e3 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -306,7 +306,7 @@ int ocfs2_slot_to_node_num_locked(struct ocfs2_super *osb, int slot_num,
 	assert_spin_locked(&osb->osb_lock);
 
 	BUG_ON(slot_num < 0);
-	BUG_ON(slot_num > osb->max_slots);
+	BUG_ON(slot_num >= osb->max_slots);
 
 	if (!si->si_slots[slot_num].sl_valid)
 		return -ENOENT;
