From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 23 Jul 2009 08:12:58 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use ocfs2_rec_clusters in
	ocfs2_adjust_adjacent_records. v2
In-Reply-To: <20090722011332.GK19170@mail.oracle.com>
References: <20090722011332.GK19170@mail.oracle.com>
Message-ID: <1248307978-23411-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	how about this? I add a bug_on  and change the commit log some how.

Regards,
Tao

In ocfs2_adjust_adjacent_records, we will adjust adjacent records
according to the extent_list in the lower level. But actually
the lower level tree will either be a leaf or a branch. If we only
use ocfs2_is_empty_extent we will meet with some problem if the lower
tree is a branch(tree_depth > 1). So use !ocfs2_rec_clusters instead.
And actually only the leaf record can have holes. So add a BUG_ON
for non-leaf branch.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 11085af..f9a3e89 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1914,7 +1914,8 @@ static void ocfs2_adjust_adjacent_records(struct ocfs2_extent_rec *left_rec,
 	 * immediately to their right.
 	 */
 	left_clusters = le32_to_cpu(right_child_el->l_recs[0].e_cpos);
-	if (ocfs2_is_empty_extent(&right_child_el->l_recs[0])) {
+	if (!ocfs2_rec_clusters(right_child_el, &right_child_el->l_recs[0])) {
+		BUG_ON(right_child_el->l_tree_depth);
 		BUG_ON(le16_to_cpu(right_child_el->l_next_free_rec) <= 1);
 		left_clusters = le32_to_cpu(right_child_el->l_recs[1].e_cpos);
 	}
-- 
1.6.2.rc2.16.gf474c
