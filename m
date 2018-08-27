From: Larry Chen <lchen@suse.com>
Date: Mon, 27 Aug 2018 15:26:34 +0800
Subject: [Ocfs2-devel] [PATCH V2] fix crash on
	ocfs2_duplicate_clusters_by_page
Message-ID: <20180827072634.23700-1-lchen@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

ocfs2_duplicate_clusters_by_page may crash if one of extent's pages is dirty.
When a page has not been written back, it is still in dirty state. If 
ocfs2_duplicate_clusters_by_page is called against the
dirty page, the crash happens.

To fix this bug, we can just unlock the page and wait the page until
it's not dirty.

The following is the buck trace dump:

kernel BUG at /root/code/ocfs2/refcounttree.c:2961!
[exception RIP: ocfs2_duplicate_clusters_by_page+822]
__ocfs2_move_extent+0x80/0x450 [ocfs2]
? __ocfs2_claim_clusters+0x130/0x250 [ocfs2]
ocfs2_defrag_extent+0x5b8/0x5e0 [ocfs2]
__ocfs2_move_extents_range+0x2a4/0x470 [ocfs2]
ocfs2_move_extents+0x180/0x3b0 [ocfs2]
? ocfs2_wait_for_recovery+0x13/0x70 [ocfs2]
ocfs2_ioctl_move_extents+0x133/0x2d0 [ocfs2]
ocfs2_ioctl+0x253/0x640 [ocfs2]
do_vfs_ioctl+0x90/0x5f0
SyS_ioctl+0x74/0x80
do_syscall_64+0x74/0x140
entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Change-log:
1. Once we founce the page is dirty, we do not wait until it's clean,
   but rather we use write_one_page to write it back

Signed-off-by: Larry Chen <lchen@suse.com>
---
 fs/ocfs2/refcounttree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7869622af22a..380c9ae2f467 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2946,6 +2946,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		if (map_end & (PAGE_SIZE - 1))
 			to = map_end & (PAGE_SIZE - 1);
 
+retry:
 		page = find_or_create_page(mapping, page_index, GFP_NOFS);
 		if (!page) {
 			ret = -ENOMEM;
@@ -2957,8 +2958,15 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		 * In case PAGE_SIZE <= CLUSTER_SIZE, This page
 		 * can't be dirtied before we CoW it out.
 		 */
-		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize)
-			BUG_ON(PageDirty(page));
+		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
+			if (PageDirty(page)) {
+				/*
+				 * write_on_page will unlock the page on return
+				 */
+				ret = write_one_page(page, 1);
+				goto retry;
+			}
+		}
 
 		if (!PageUptodate(page)) {
 			ret = block_read_full_page(page, ocfs2_get_block);
-- 
2.13.7
