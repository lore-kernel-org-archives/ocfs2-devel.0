From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:28 +0100
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Fix oops when extending quota
	files
In-Reply-To: <1227623495-16708-2-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
	<1227623495-16708-2-git-send-email-jack@suse.cz>
Message-ID: <1227623495-16708-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have to mark buffer as uptodate before calling ocfs2_journal_access() and
ocfs2_set_buffer_uptodate() does not do this for us.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 1401edf..339c98a 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -172,7 +172,7 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	struct inode *gqinode = oinfo->dqi_gqinode;
 	int offset = off & (sb->s_blocksize - 1);
 	sector_t blk = off >> sb->s_blocksize_bits;
-	int err = 0, new = 0;
+	int err = 0, new = 0, ja_type;
 	struct buffer_head *bh = NULL;
 	handle_t *handle = journal_current_handle();
 
@@ -205,32 +205,28 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 	if ((offset || len < sb->s_blocksize - OCFS2_QBLK_RESERVED_SPACE) &&
 	    !new) {
 		err = ocfs2_read_quota_block(gqinode, blk, &bh);
-		if (err) {
-			mlog_errno(err);
-			return err;
-		}
-		err = ocfs2_journal_access(handle, gqinode, bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ja_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	} else {
 		bh = ocfs2_get_quota_block(gqinode, blk, &err);
-		if (!bh) {
-			mlog_errno(err);
-			return err;
-		}
-		err = ocfs2_journal_access(handle, gqinode, bh,
-					   OCFS2_JOURNAL_ACCESS_CREATE);
+		ja_type = OCFS2_JOURNAL_ACCESS_CREATE;
 	}
-	if (err < 0) {
-		brelse(bh);
-		goto out;
+	if (err) {
+		mlog_errno(err);
+		return err;
 	}
 	lock_buffer(bh);
 	if (new)
 		memset(bh->b_data, 0, sb->s_blocksize);
 	memcpy(bh->b_data + offset, data, len);
 	flush_dcache_page(bh->b_page);
+	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 	ocfs2_set_buffer_uptodate(gqinode, bh);
+	err = ocfs2_journal_access(handle, gqinode, bh, ja_type);
+	if (err < 0) {
+		brelse(bh);
+		goto out;
+	}
 	err = ocfs2_journal_dirty(handle, bh);
 	brelse(bh);
 	if (err < 0)
-- 
1.6.0.4
