From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 21 Jul 2009 15:42:06 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use ocfs2_rec_clusters in
	ocfs2_adjust_adjacent_records.
In-Reply-To: <4A656FC9.4010404@oracle.com>
References: <4A656FC9.4010404@oracle.com>
Message-ID: <1248162126-21507-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_adjust_adjacent_records, we will adjust adjacent records
according to the extent_list in the lower level. But actually
the lower level tree will either be a leaf or a branch. So we
shouldn't use ocfs2_is_empty_extent which is only valid for a
tree leaf. Use ocfs2_rec_clusters instead. We will meet with some
problem when the tree depth > 2.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 11085af..1957645 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1914,7 +1914,7 @@ static void ocfs2_adjust_adjacent_records(struct ocfs2_extent_rec *left_rec,
 	 * immediately to their right.
 	 */
 	left_clusters = le32_to_cpu(right_child_el->l_recs[0].e_cpos);
-	if (ocfs2_is_empty_extent(&right_child_el->l_recs[0])) {
+	if (!ocfs2_rec_clusters(right_child_el, &right_child_el->l_recs[0])) {
 		BUG_ON(le16_to_cpu(right_child_el->l_next_free_rec) <= 1);
 		left_clusters = le32_to_cpu(right_child_el->l_recs[1].e_cpos);
 	}
-- 
1.6.2.rc2.16.gf474c
