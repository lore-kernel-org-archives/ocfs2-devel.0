From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Oct 2008 13:24:29 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Set journal descriptor to NULL
	after journal shutdown
Message-ID: <1224707069-14173-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch sets journal descriptor to NULL after the journal is shutdown.
This ensures that jbd2_journal_release_jbd_inode(), which removes the
jbd2 inode from txn lists, can be called safely from ocfs2_clear_inode()
even after the journal has been shutdown.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/inode.c   |    6 ++++++
 fs/ocfs2/journal.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 4903688..7aa00d5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1106,6 +1106,12 @@ void ocfs2_clear_inode(struct inode *inode)
 	oi->ip_last_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 	oi->ip_blkno = 0ULL;
+
+	/*
+	 * ip_jinode is used to track txns against this inode. We ensure that
+	 * the journal is flushed before journal shutdown. Thus it is safe to
+	 * have inodes get cleaned up after journal shutdown.
+	 */
 	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
 				       &oi->ip_jinode);
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 81e4067..99fe9d5 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -690,6 +690,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 
 	/* Shutdown the kernel journal system */
 	jbd2_journal_destroy(journal->j_journal);
+	journal->j_journal = NULL;
 
 	OCFS2_I(inode)->ip_open_count--;
 
-- 
1.5.4.3
