From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 22 May 2015 11:10:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix NULL pointer dereference in
	function ocfs2_abort_trigger()
Message-ID: <555E9E3A.1080607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function ocfs2_abort_trigger() use bh->b_assoc_map to get sb.
But there's no function to set bh->b_assoc_map in ocfs2, it
will trigger NULL pointer dereference while calling this
function. We can get sb from bh->b_bdev->bd_super instead of
b_assoc_map.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ff53192..11cb383 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -573,7 +573,7 @@ static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
 
 	/* We aren't guaranteed to have the superblock here - but if we
 	 * don't, it'll just crash. */
-	ocfs2_error(bh->b_assoc_map->host->i_sb,
+	ocfs2_error(bh->b_bdev->bd_super,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
 
-- 
1.8.4.3
