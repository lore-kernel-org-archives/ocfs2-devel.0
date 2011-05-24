From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 18:53:46 +0800
Subject: [Ocfs2-devel] [PATCH 12/15] Ocfs2/move_extents: helper to calculate
	the defraging length in one run.
In-Reply-To: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
References: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306234429-28078-13-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The helper is to calculate the defrag length in one run according to a threshold,
it will proceed doing defragmentation until the threshold was meet, and skip a
LARGE extent if any.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/move_extents.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 6d3e8f6..d701cfe 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -797,3 +797,33 @@ out:
 
 	return ret;
 }
+
+/*
+ * Helper to calculate the defraging length in one run according to threshold.
+ */
+static void ocfs2_calc_extent_defrag_len(u32 *alloc_size, u32 *len_defraged,
+					 u32 threshold, int *skip)
+{
+	if ((*alloc_size + *len_defraged) < threshold) {
+		/*
+		 * proceed defragmentation until we meet the thresh
+		 */
+		*len_defraged += *alloc_size;
+	} else if (*len_defraged == 0) {
+		/*
+		 * XXX: skip a large extent.
+		 */
+		*skip = 1;
+	} else {
+		/*
+		 * split this extent to coalesce with former pieces as
+		 * to reach the threshold.
+		 *
+		 * we're done here with one cycle of defragmentation
+		 * in a size of 'thresh', resetting 'len_defraged'
+		 * forces a new defragmentation.
+		 */
+		*alloc_size = threshold - *len_defraged;
+		*len_defraged = 0;
+	}
+}
-- 
1.5.5
