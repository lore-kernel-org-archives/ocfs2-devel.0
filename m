From: John Lightsey <john@nixnuts.net>
Date: Sun, 07 Jan 2018 15:07:55 -0600
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: try to reuse extent block in
 dealloc without meta_alloc
In-Reply-To: <HK2PR06MB101296F6BF12EAD83777D81DD5050@HK2PR06MB1012.apcprd06.prod.outlook.com>
References: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
	<5A448D59.4040603@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2909D75@H3CMLB12-EX.srv.huawei-3com.com>
	,<1514582159.2812.5.camel@nixnuts.net>
	<HK2PR06MB101296F6BF12EAD83777D81DD5050@HK2PR06MB1012.apcprd06.prod.outlook.com>
Message-ID: <1515359275.3044.4.camel@nixnuts.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 2017-12-29 at 22:36 +0000, Ge Changwei wrote:
> Hi john,
> 
> Thanks for your test.
> I am on a vacation until 3, January.
> I will investigate the issue when I am back to work.
> 

From what I can tell, the order of reclaiming blocs vs allocating new
ones just needs to be reversed for everything to work correctly.

This patch on top of yours works in my testing.

I'm not certain my test scenario is hitting ocfs2_add_branch() with
new_blocks > 1 and meta_ac != NULL though.


From 317cbd5a7c8ee5f8f6dff3844d23d3169db990a4 Mon Sep 17 00:00:00 2001
From: John Lightsey <john@nixnuts.net>
Date: Sun, 7 Jan 2018 14:43:21 -0600
Subject: [PATCH] Reuse deallocated extents before claiming new extents.

By reusing deallocated extents before attempting to claim new
extents, this avoids a condition where the extent tree is truncated,
and then an allocation requests are made for more extents than were
originally reserved.
---
 fs/ocfs2/alloc.c | 26 +++++++++++++++++++-------
 fs/ocfs2/aops.c  |  3 +--
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 89807ea7..dce2eaa7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1166,7 +1166,7 @@ static int ocfs2_add_branch(handle_t *handle,
 			    struct buffer_head **last_eb_bh,
 			    struct ocfs2_alloc_context *meta_ac)
 {
-	int status, new_blocks, i;
+	int status, new_blocks, reclaimed_blocks, i;
 	u64 next_blkno, new_last_eb_blk;
 	struct buffer_head *bh;
 	struct buffer_head **new_eb_bhs = NULL;
@@ -1222,8 +1222,20 @@ static int ocfs2_add_branch(handle_t *handle,
 	}
 
 	if (meta_ac) {
-		status = ocfs2_create_new_meta_bhs(handle, et, new_blocks,
-						   meta_ac, new_eb_bhs);
+		reclaimed_blocks = 0;
+		while ( reclaimed_blocks < new_blocks && !ocfs2_is_dealloc_empty(et) ) {
+			status = ocfs2_reuse_blk_from_dealloc(handle, et,
+					new_eb_bhs + reclaimed_blocks, 1);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+			reclaimed_blocks++;
+		}
+		if (reclaimed_blocks < new_blocks) {
+			status = ocfs2_create_new_meta_bhs(handle, et, new_blocks - reclaimed_blocks,
+				meta_ac, new_eb_bhs + reclaimed_blocks);
+		}
 	} else if (!ocfs2_is_dealloc_empty(et)) {
 		status = ocfs2_reuse_blk_from_dealloc(handle, et,
 						      new_eb_bhs, new_blocks);
@@ -1362,12 +1374,12 @@ static int ocfs2_shift_tree_depth(handle_t *handle,
 	struct ocfs2_extent_list  *root_el;
 	struct ocfs2_extent_list  *eb_el;
 
-	if (meta_ac) {
-		status = ocfs2_create_new_meta_bhs(handle, et, 1, meta_ac,
-						   &new_eb_bh);
-	} else if (!ocfs2_is_dealloc_empty(et)) {
+	if (!ocfs2_is_dealloc_empty(et)) {
 		status = ocfs2_reuse_blk_from_dealloc(handle, et,
 						      &new_eb_bh, 1);
+	} else if (meta_ac) {
+		status = ocfs2_create_new_meta_bhs(handle, et, 1, meta_ac,
+						   &new_eb_bh);
 	} else {
 		BUG();
 	}
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index dcea6d5c..8ad37965 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1743,8 +1743,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
 					      wc->w_di_bh);
 		ret = ocfs2_lock_allocators(inode, &et,
-					    clusters_to_alloc,
-					    2*extents_to_split,
+					    clusters_to_alloc, extents_to_split,
 					    &data_ac, &meta_ac);
 		if (ret) {
 			mlog_errno(ret);
-- 
2.11.0
