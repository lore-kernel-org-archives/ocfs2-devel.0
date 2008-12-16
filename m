From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 16 Dec 2008 15:49:16 -0800
Subject: [Ocfs2-devel] [PATCH 2/9] ocfs2: Moves struct recovery_map to a
	header file
In-Reply-To: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1229471363-15887-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Moves the definition of struct recovery_map from journal.c to ocfs2.h.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |   11 -----------
 fs/ocfs2/journal.h |    9 +++++++++
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 99fe9d5..3d2c81f 100644
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
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index d4d14e9..efbcf8e 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -43,6 +43,15 @@ enum ocfs2_journal_state {
 struct ocfs2_super;
 struct ocfs2_dinode;
 
+/*
+ * The recovery_list is a simple linked list of node numbers to recover.
+ * It is protected by the recovery_lock.
+ */
+struct ocfs2_recovery_map {
+	unsigned int rm_used;
+	unsigned int *rm_entries;
+};
+
 struct ocfs2_journal {
 	enum ocfs2_journal_state   j_state;    /* Journals current state   */
 
-- 
1.5.6.3
