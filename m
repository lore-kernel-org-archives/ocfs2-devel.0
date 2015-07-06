From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 6 Jul 2015 10:05:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not BUG if buffer not uptodate in
	__ocfs2_journal_access
Message-ID: <5599E264.7080606@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When storage network is unstable, it may trigger the BUG in
__ocfs2_journal_access because of buffer not uptodate. We can retry the
write in this case or return error instead of BUG.

Reported-by: Zhangguanghui <zhang.guanghui@h3c.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f8206d1..e731374 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -670,7 +670,23 @@ static int __ocfs2_journal_access(handle_t *handle,
 		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
 		mlog(ML_ERROR, "b_blocknr=%llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		BUG();
+
+		lock_buffer(bh);
+		/*
+		 * A previous attempt to write this buffer head failed.
+		 * Nothing we can do but to retry the write and hope for
+		 * the best.
+		 */
+		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
+			clear_buffer_write_io_error(bh);
+			set_buffer_uptodate(bh);
+		}
+
+		if (!buffer_uptodate(bh)) {
+			unlock_buffer(bh);
+			return -EIO;
+		}
+		unlock_buffer(bh);
 	}

 	/* Set the current transaction information on the ci so
-- 
1.8.4.3
