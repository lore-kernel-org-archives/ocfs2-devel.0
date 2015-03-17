From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 17 Mar 2015 12:07:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: rollback the cleared bits if error
	occurs after ocfs2_block_group_clear_bits
Message-ID: <5507A89F.9000100@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_block_group_clear_bits will clear bits in block group bitmap.
Once it succeeds but fails in the following step, it will cause block
group bitmap mismatch the corresponding count recorded in dinode.
So rollback the cleared bits if error occurs.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/suballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0cb889a..4479029 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2499,6 +2499,8 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
+		ocfs2_block_group_set_bits(handle, alloc_inode, group, group_bh,
+				start_bit, count);
 		goto bail;
 	}

-- 
1.8.4.3
