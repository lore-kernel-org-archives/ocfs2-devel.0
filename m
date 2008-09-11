From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Sep 2008 20:05:56 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Moves struct recovery_map to a
	header file
In-Reply-To: <1221102357-869-1-git-send-email-sunil.mushran@oracle.com>
References: <1221102357-869-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1221102357-869-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Moves the definition of struct recovery_map from journal.c to ocfs2.h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |   11 -----------
 fs/ocfs2/ocfs2.h   |   11 ++++++++++-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7a37240..9c05e06 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -64,17 +64,6 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 				 int slot);
 static int ocfs2_commit_thread(void *arg);
 
-
-/*
- * The recovery_list is a simple linked list of node numbers to recover.
- * It is protected by the recovery_lock.
- */
-
-struct ocfs2_recovery_map {
-	unsigned int rm_used;
-	unsigned int *rm_entries;
-};
-
 int ocfs2_recovery_init(struct ocfs2_super *osb)
 {
 	struct ocfs2_recovery_map *rm;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index b4bf878..5ab2211 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -207,8 +207,17 @@ struct ocfs2_slot_info {
 	struct ocfs2_slot *si_slots;
 };
 
+/*
+ * The recovery_list is a simple linked list of node numbers to recover.
+ * It is protected by the recovery_lock.
+ */
+
+struct ocfs2_recovery_map {
+	unsigned int rm_used;
+	unsigned int *rm_entries;
+};
+
 struct ocfs2_journal;
-struct ocfs2_recovery_map;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
-- 
1.5.4.3
