From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:00:52 -0700
Subject: [Ocfs2-devel] [PATCH 02/32] ocfs2: Move struct recovery_map to a
	header file
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

Move the definition of struct recovery_map from journal.c to journal.h. This
is preparation for the next patch.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/journal.c |   12 ------------
 fs/ocfs2/journal.h |   11 +++++++++++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 57d7d25..4c8f355 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -76,18 +76,6 @@ static inline int ocfs2_wait_on_quotas(struct ocfs2_super *osb)
 	return __ocfs2_wait_on_mount(osb, 1);
 }
 
-
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
index 172850a..21601ee 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -38,6 +38,17 @@ enum ocfs2_journal_state {
 struct ocfs2_super;
 struct ocfs2_dinode;
 
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
+
 struct ocfs2_journal {
 	enum ocfs2_journal_state   j_state;    /* Journals current state   */
 
-- 
1.5.6
