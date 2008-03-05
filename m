From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 14:52:31 2008
Subject: [Ocfs2-devel] [PATCH 1/7] ocfs2: Move slot map access into
	slot_map.c
In-Reply-To: <1204757524-21343-1-git-send-email-joel.becker@oracle.com>
References: <1204757524-21343-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204757524-21343-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

From: Mark Fasheh <mark.fasheh@oracle.com>

journal.c and dlmglue.c would refresh the slot map by hand.  Instead, have
the update and clear functions do the work inside slot_map.c.  The eventual
result is to make ocfs2_slot_info defined privately in slot_map.c

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmglue.c  |    8 +-----
 fs/ocfs2/journal.c  |    3 +-
 fs/ocfs2/slot_map.c |   62 +++++++++++++++++++++++++++++++++++++++-----------
 fs/ocfs2/slot_map.h |   11 +++-----
 fs/ocfs2/super.c    |    3 +-
 5 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f779430..33c8a65 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2132,8 +2132,6 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 	int status = 0;
 	int level = ex ? LKM_EXMODE : LKM_PRMODE;
 	struct ocfs2_lock_res *lockres = &osb->osb_super_lockres;
-	struct buffer_head *bh;
-	struct ocfs2_slot_info *si = osb->slot_info;
 
 	mlog_entry_void();
 
@@ -2159,11 +2157,7 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 		goto bail;
 	}
 	if (status) {
-		bh = si->si_bh;
-		status = ocfs2_read_block(osb, bh->b_blocknr, &bh, 0,
-					  si->si_inode);
-		if (status == 0)
-			ocfs2_update_slot_info(si);
+		status = ocfs2_refresh_slot_info(osb);
 
 		ocfs2_complete_lock_res_refresh(lockres, status);
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f31c7e8..c2e654e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1123,8 +1123,7 @@ static int ocfs2_recover_node(struct ocfs2_super *osb,
 
 	/* Likewise, this would be a strange but ultimately not so
 	 * harmful place to get an error... */
-	ocfs2_clear_slot(si, slot_num);
-	status = ocfs2_update_disk_slots(osb, si);
+	status = ocfs2_clear_slot(osb, slot_num);
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 3a50ce5..f5727b8 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -49,7 +49,7 @@ static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
 			      s16 node_num);
 
 /* post the slot information on disk into our slot_info struct. */
-void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
+static void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 {
 	int i;
 	__le16 *disk_info;
@@ -65,10 +65,27 @@ void ocfs2_update_slot_info(struct ocfs2_slot_info *si)
 	spin_unlock(&si->si_lock);
 }
 
+int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
+{
+	int ret;
+	struct ocfs2_slot_info *si = osb->slot_info;
+	struct buffer_head *bh;
+
+	if (si == NULL)
+		return 0;
+
+	bh = si->si_bh;
+	ret = ocfs2_read_block(osb, bh->b_blocknr, &bh, 0, si->si_inode);
+	if (ret == 0)
+		ocfs2_update_slot_info(si);
+
+	return ret;
+}
+
 /* post the our slot info stuff into it's destination bh and write it
  * out. */
-int ocfs2_update_disk_slots(struct ocfs2_super *osb,
-			    struct ocfs2_slot_info *si)
+static int ocfs2_update_disk_slots(struct ocfs2_super *osb,
+				   struct ocfs2_slot_info *si)
 {
 	int status, i;
 	__le16 *disk_info = (__le16 *) si->si_bh->b_data;
@@ -135,6 +152,19 @@ s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 	return ret;
 }
 
+static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
+{
+	if (si == NULL)
+		return;
+
+	if (si->si_inode)
+		iput(si->si_inode);
+	if (si->si_bh)
+		brelse(si->si_bh);
+
+	kfree(si);
+}
+
 static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
 			      s16 slot_num,
 			      s16 node_num)
@@ -147,12 +177,18 @@ static void __ocfs2_fill_slot(struct ocfs2_slot_info *si,
 	si->si_global_node_nums[slot_num] = node_num;
 }
 
-void ocfs2_clear_slot(struct ocfs2_slot_info *si,
-		      s16 slot_num)
+int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num)
 {
+	struct ocfs2_slot_info *si = osb->slot_info;
+
+	if (si == NULL)
+		return 0;
+
 	spin_lock(&si->si_lock);
 	__ocfs2_fill_slot(si, slot_num, OCFS2_INVALID_SLOT);
 	spin_unlock(&si->si_lock);
+
+	return ocfs2_update_disk_slots(osb, osb->slot_info);
 }
 
 int ocfs2_init_slot_info(struct ocfs2_super *osb)
@@ -202,18 +238,17 @@ int ocfs2_init_slot_info(struct ocfs2_super *osb)
 	osb->slot_info = si;
 bail:
 	if (status < 0 && si)
-		ocfs2_free_slot_info(si);
+		__ocfs2_free_slot_info(si);
 
 	return status;
 }
 
-void ocfs2_free_slot_info(struct ocfs2_slot_info *si)
+void ocfs2_free_slot_info(struct ocfs2_super *osb)
 {
-	if (si->si_inode)
-		iput(si->si_inode);
-	if (si->si_bh)
-		brelse(si->si_bh);
-	kfree(si);
+	struct ocfs2_slot_info *si = osb->slot_info;
+
+	osb->slot_info = NULL;
+	__ocfs2_free_slot_info(si);
 }
 
 int ocfs2_find_slot(struct ocfs2_super *osb)
@@ -285,7 +320,6 @@ void ocfs2_put_slot(struct ocfs2_super *osb)
 	}
 
 bail:
-	osb->slot_info = NULL;
-	ocfs2_free_slot_info(si);
+	ocfs2_free_slot_info(osb);
 }
 
diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
index 1025872..b029ffd 100644
--- a/fs/ocfs2/slot_map.h
+++ b/fs/ocfs2/slot_map.h
@@ -30,7 +30,7 @@
 struct ocfs2_slot_info {
 	spinlock_t si_lock;
 
-       	struct inode *si_inode;
+	struct inode *si_inode;
 	struct buffer_head *si_bh;
 	unsigned int si_num_slots;
 	unsigned int si_size;
@@ -38,19 +38,16 @@ struct ocfs2_slot_info {
 };
 
 int ocfs2_init_slot_info(struct ocfs2_super *osb);
-void ocfs2_free_slot_info(struct ocfs2_slot_info *si);
+void ocfs2_free_slot_info(struct ocfs2_super *osb);
 
 int ocfs2_find_slot(struct ocfs2_super *osb);
 void ocfs2_put_slot(struct ocfs2_super *osb);
 
-void ocfs2_update_slot_info(struct ocfs2_slot_info *si);
-int ocfs2_update_disk_slots(struct ocfs2_super *osb,
-			    struct ocfs2_slot_info *si);
+int ocfs2_refresh_slot_info(struct ocfs2_super *osb);
 
 s16 ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 			   s16 global);
-void ocfs2_clear_slot(struct ocfs2_slot_info *si,
-		      s16 slot_num);
+int ocfs2_clear_slot(struct ocfs2_super *osb, s16 slot_num);
 
 static inline int ocfs2_is_empty_slot(struct ocfs2_slot_info *si,
 				      int slot_num)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bec75af..fad37af 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1724,8 +1724,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 
 	/* This function assumes that the caller has the main osb resource */
 
-	if (osb->slot_info)
-		ocfs2_free_slot_info(osb->slot_info);
+	ocfs2_free_slot_info(osb);
 
 	kfree(osb->osb_orphan_wipes);
 	/* FIXME
-- 
1.5.3.8
