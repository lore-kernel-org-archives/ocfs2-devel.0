From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 21 Jan 2011 18:20:27 +0800
Subject: [Ocfs2-devel] [PATCH 10/14] Ocfs2/move_extents: helper to probe a
	proper region to move in an alloc group.
In-Reply-To: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1295605231-15991-11-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Before doing the movement of extents, we'd better probe the alloc group from
'goal_blk' for searching a contiguous region to fit the wanted movement, we
even will have a best-effort try by compromising to a threshold around the
given goal.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index f4410e3..61b2871 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -521,3 +521,42 @@ out:
 
 	return ret;
 }
+
+static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
+				    int *goal_bit, u32 move_len, u32 max_hop,
+				    u32 *phys_cpos)
+{
+	int i, used, last_free_bits = 0, base_bit = *goal_bit;
+	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
+	u32 base_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
+						 le64_to_cpu(gd->bg_blkno));
+
+	for (i = base_bit; i < le16_to_cpu(gd->bg_bits); i++) {
+
+		used = ocfs2_test_bit(i, (unsigned long *)gd->bg_bitmap);
+		if (used) {
+			/*
+			 * we even tried searching the free chunk by jumping
+			 * a 'max_hop' distance, but still failed.
+			 */
+			if ((i - base_bit) > max_hop) {
+				*phys_cpos = 0;
+				break;
+			}
+
+			if (last_free_bits)
+				last_free_bits = 0;
+
+			continue;
+		} else
+			last_free_bits++;
+
+		if (last_free_bits == move_len) {
+			*goal_bit = i;
+			*phys_cpos = base_cpos + i;
+			break;
+		}
+	}
+
+	mlog(0, "found phys_cpos: %u to fit the wanted moving.\n", *phys_cpos);
+}
-- 
1.5.5
