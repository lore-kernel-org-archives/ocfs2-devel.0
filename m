From: wangyan <wangyan122@huawei.com>
Date: Sat, 22 Feb 2020 09:54:18 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: correct annotation from
 "l_next_rec" to "l_next_free_rec"
Message-ID: <5e76c953-3479-1280-023c-ad05e4c75608@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Correct annotation from "l_next_rec" to "l_next_free_rec"

Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 1e3b06fa4785..65b3abbcce4e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3941,7 +3941,7 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_tree *et,
 	 * above.
 	 *
 	 * This leaf needs to have space, either by the empty 1st
-	 * extent record, or by virtue of an l_next_rec < l_count.
+	 * extent record, or by virtue of an l_next_free_rec < l_count.
 	 */
 	ocfs2_rotate_leaf(el, insert_rec);
 }
-- 
2.19.1
