From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 12 May 2011 20:47:07 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: skip existing hole when removing
	the last extent_rec in punching-hole codes.
Message-ID: <1305204427-5027-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the case of removing a partial extent record which covers a hole, current
punching-hole logic will try to remove more than the length of whole extent
record, which leads to the failure of following assert(fs/ocfs2/alloc.c):

5507         BUG_ON(cpos < le32_to_cpu(rec->e_cpos) || trunc_range > rec_range);

This patch tries to skip existing hole at the last attempt of removing a partial
extent record, what's more, it also adds some necessary comments for better
understanding of punching-hole codes.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 41565ae..89659d6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1607,6 +1607,9 @@ static void ocfs2_calc_trunc_pos(struct inode *inode,
 	range = le32_to_cpu(rec->e_cpos) + ocfs2_rec_clusters(el, rec);
 
 	if (le32_to_cpu(rec->e_cpos) >= trunc_start) {
+		/*
+		 * remove an entire extent record.
+		 */
 		*trunc_cpos = le32_to_cpu(rec->e_cpos);
 		/*
 		 * Skip holes if any.
@@ -1617,7 +1620,16 @@ static void ocfs2_calc_trunc_pos(struct inode *inode,
 		*blkno = le64_to_cpu(rec->e_blkno);
 		*trunc_end = le32_to_cpu(rec->e_cpos);
 	} else if (range > trunc_start) {
+		/*
+		 * remove a partial extent record, which means we're
+		 * removing the last extent record.
+		 */
 		*trunc_cpos = trunc_start;
+		/*
+		 * skip hole if any.
+		 */
+		if (range < *trunc_end)
+			*trunc_end = range;
 		*trunc_len = *trunc_end - trunc_start;
 		coff = trunc_start - le32_to_cpu(rec->e_cpos);
 		*blkno = le64_to_cpu(rec->e_blkno) +
-- 
1.5.5
