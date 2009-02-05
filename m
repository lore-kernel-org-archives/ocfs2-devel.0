From: Jan Kara <jack@suse.cz>
Date: Thu,  5 Feb 2009 15:53:02 +0100
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add journal parameter to
	jbd2_journal_begin_ordered_truncate()
In-Reply-To: <1233845582-954-3-git-send-email-jack@suse.cz>
References: <y> <1233845582-954-1-git-send-email-jack@suse.cz>
	<1233845582-954-2-git-send-email-jack@suse.cz>
	<1233845582-954-3-git-send-email-jack@suse.cz>
Message-ID: <1233845582-954-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, mfasheh@suse.de

Add new parameter of the function.

CC: ocfs2-devel at oss.oracle.com
CC: mfasheh at suse.de
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 3c3532e..172850a 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -513,8 +513,10 @@ static inline int ocfs2_jbd2_file_inode(handle_t *handle, struct inode *inode)
 static inline int ocfs2_begin_ordered_truncate(struct inode *inode,
 					       loff_t new_size)
 {
-	return jbd2_journal_begin_ordered_truncate(&OCFS2_I(inode)->ip_jinode,
-						   new_size);
+	return jbd2_journal_begin_ordered_truncate(
+				OCFS2_SB(inode->i_sb)->journal->j_journal,
+				&OCFS2_I(inode)->ip_jinode,
+				new_size);
 }
 
 #endif /* OCFS2_JOURNAL_H */
-- 
1.6.0.2
