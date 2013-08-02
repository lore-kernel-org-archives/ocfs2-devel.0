From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 02 Aug 2013 18:17:07 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Revert commit 40bd62e to avoid
 regression in extended allocation
Message-ID: <51FB8723.4030907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

Revert "fs/ocfs2/journal.h: add bits_wanted while calculating credits in ocfs2_calc_extend_credits"

This reverts commit 40bd62eb7fb8447798732e809a676ebaf2a7f910.

Unfortunately this change broken fallocate even if there has sufficient
disk space can be preallocated, which is a serious problem.

# df -h
/dev/sda8        22G  1.2G   21G   6% /ocfs2
# fallocate -o 0 -l 200M /ocfs2/testfile
fallocate: /ocfs2/test: fallocate failed: No space left on device

CPU: 3 PID: 3656 Comm: fallocate Tainted: G        W  O 3.11.0-rc3 #2
Call Trace:
[<ffffffff81a5fea7>] dump_stack+0x77/0x9e
[<ffffffff81093504>] warn_slowpath_common+0xc4/0x110
[<ffffffff8109357a>] warn_slowpath_null+0x2a/0x40
[<ffffffffa00ad9dc>] start_this_handle+0x6c/0x640 [jbd2]
[<ffffffff81150f9d>] ? __module_address+0x1ad/0x270
[<ffffffff81155cee>] ? is_module_address+0x1e/0x40
[<ffffffff81135875>] ? static_obj+0x65/0xb0
[<ffffffff8113f6f7>] ? lockdep_init_map+0x147/0x280
[<ffffffffa00ae398>] jbd2__journal_start+0x138/0x300 [jbd2]
[<ffffffffa00ae583>] jbd2_journal_start+0x23/0x30 [jbd2]
[<ffffffffa0997726>] ocfs2_start_trans+0x166/0x300 [ocfs2]
[<ffffffff81022426>] ? show_stack+0x66/0x70
[<ffffffffa0985c4f>] __ocfs2_extend_allocation+0x38f/0xdb0 [ocfs2]
[<ffffffffa097e414>] ? ocfs2_get_clusters_nocache.isra.11+0x234/0x5b0
[<ffffffffa098fb53>] ? ocfs2_read_inode_block_full+0x43/0x80 [ocfs2]
[<ffffffffa0997d00>] ? ocfs2_extend_trans+0x2c0/0x2c0 [ocfs2]
[<ffffffffa098710e>] ? __ocfs2_change_file_space+0x57e/0xa60 [ocfs2]
[<ffffffffa0986a39>] ocfs2_allocate_unwritten_extents+0x3c9/0x520
[<ffffffff81a6e828>] ? down_write+0x108/0x120
[<ffffffffa0987170>] __ocfs2_change_file_space+0x5e0/0xa60 [ocfs2]
[<ffffffff812bd1ad>] ? do_fallocate+0x1ad/0x220
[<ffffffffa09876a1>] ocfs2_fallocate+0xb1/0xe0 [ocfs2]
[<ffffffff812bd1cb>] do_fallocate+0x1cb/0x220
[<ffffffff812bd28f>] SyS_fallocate+0x6f/0xb0
[<ffffffff81a83419>] system_call_fastpath+0x16/0x1b
---[ end trace 474a79e9fc2db862 ]---
[ 1683.855972] JBD2: fallocate wants too many credits (51216 > 4381)

Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/journal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 96f9ac2..0a99273 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -537,7 +537,7 @@ static inline int ocfs2_calc_extend_credits(struct super_block *sb,
 	extent_blocks = 1 + 1 + le16_to_cpu(root_el->l_tree_depth);
 
 	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks +
-	       ocfs2_quota_trans_credits(sb) + bits_wanted;
+	       ocfs2_quota_trans_credits(sb);
 }
 
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
-- 
1.7.9.5
