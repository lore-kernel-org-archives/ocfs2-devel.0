From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 12 Jul 2019 15:02:52 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] jbd2: remove
	jbd2_journal_inode_add_[write|wait]
In-Reply-To: <1562914972-97318-1-git-send-email-joseph.qi@linux.alibaba.com>
References: <1562914972-97318-1-git-send-email-joseph.qi@linux.alibaba.com>
Message-ID: <1562914972-97318-2-git-send-email-joseph.qi@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <zwisler@chromium.org>, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Since ext4/ocfs2 are using jbd2_inode dirty range scoping APIs now,
jbd2_journal_inode_add_[write|wait] are not used any more, remove them.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/jbd2/journal.c     |  2 --
 fs/jbd2/transaction.c | 12 ------------
 include/linux/jbd2.h  |  2 --
 3 files changed, 16 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 953990e..1c58859 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -89,8 +89,6 @@
 EXPORT_SYMBOL(jbd2_journal_invalidatepage);
 EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
-EXPORT_SYMBOL(jbd2_journal_inode_add_write);
-EXPORT_SYMBOL(jbd2_journal_inode_add_wait);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_write);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_wait);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 990e7b5..9bf793d 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2619,18 +2619,6 @@ static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
 	return 0;
 }
 
-int jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *jinode)
-{
-	return jbd2_journal_file_inode(handle, jinode,
-			JI_WRITE_DATA | JI_WAIT_DATA, 0, LLONG_MAX);
-}
-
-int jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *jinode)
-{
-	return jbd2_journal_file_inode(handle, jinode, JI_WAIT_DATA, 0,
-			LLONG_MAX);
-}
-
 int jbd2_journal_inode_ranged_write(handle_t *handle,
 		struct jbd2_inode *jinode, loff_t start_byte, loff_t length)
 {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index df03825..603fbc4 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1410,8 +1410,6 @@ extern int	   jbd2_journal_update_sb_log_tail	(journal_t *, tid_t,
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_force_commit_nested(journal_t *);
-extern int	   jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *inode);
-extern int	   jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *inode);
 extern int	   jbd2_journal_inode_ranged_write(handle_t *handle,
 			struct jbd2_inode *inode, loff_t start_byte,
 			loff_t length);
-- 
1.8.3.1
