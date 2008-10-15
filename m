From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 15 Oct 2008 15:14:56 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Release jbd inode for system
	inodes before journal shutdown
In-Reply-To: <1224108896-6603-1-git-send-email-sunil.mushran@oracle.com>
References: <1224108896-6603-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1224108896-6603-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

JBD2 expects clear inode to also release the corresponding jbd inode.
OCFS2 has a set of system inodes that includes the journal inode that
are cleared after the journal is shutdown. This is problematic as the
jbd inode needs to be released while the journal is still up.

This patch fixes this issue by making the fs explicitly release the jbd
inode for all system inodes before the journal shutdown.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/inode.c |    7 +++++--
 fs/ocfs2/super.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 4903688..20f93fd 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1023,6 +1023,7 @@ void ocfs2_clear_inode(struct inode *inode)
 {
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_journal *journal;
 
 	mlog_entry_void();
 
@@ -1106,8 +1107,10 @@ void ocfs2_clear_inode(struct inode *inode)
 	oi->ip_last_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 	oi->ip_blkno = 0ULL;
-	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
-				       &oi->ip_jinode);
+
+	journal = OCFS2_SB(inode->i_sb)->journal;
+	BUG_ON(journal->j_state != OCFS2_JOURNAL_LOADED);
+	jbd2_journal_release_jbd_inode(journal->j_journal, &oi->ip_jinode);
 
 bail:
 	mlog_exit_void();
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 304b63a..5f40d7c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -324,6 +324,36 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 	mlog_exit(0);
 }
 
+static void ocfs2_release_system_inodes_jbd_inode(struct ocfs2_super *osb)
+{
+	int i;
+	struct inode *inode;
+	struct ocfs2_journal *journal;
+
+	for (i = 0; i < NUM_SYSTEM_INODES; i++) {
+		inode = osb->system_inodes[i];
+		if (!inode)
+			continue;
+		journal = OCFS2_SB(inode->i_sb)->journal;
+		jbd2_journal_release_jbd_inode(journal->j_journal,
+					       OCFS2_I(inode)->ip_jinode);
+	}
+
+	inode = osb->sys_root_inode;
+	if (inode) {
+		journal = OCFS2_SB(inode->i_sb)->journal;
+		jbd2_journal_release_jbd_inode(journal->j_journal,
+					       OCFS2_I(inode)->ip_jinode);
+	}
+
+	inode = osb->root_inode;
+	if (inode) {
+		journal = OCFS2_SB(inode->i_sb)->journal;
+		jbd2_journal_release_jbd_inode(journal->j_journal,
+					       OCFS2_I(inode)->ip_jinode);
+	}
+}
+
 /* We're allocating fs objects, use GFP_NOFS */
 static struct inode *ocfs2_alloc_inode(struct super_block *sb)
 {
@@ -1310,6 +1340,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
+	/* Release jbd inode for system inodes before journal shutdown */
+	ocfs2_release_system_inodes_jbd_inode(osb);
+
 	ocfs2_journal_shutdown(osb);
 
 	ocfs2_sync_blockdev(sb);
-- 
1.5.6.3
