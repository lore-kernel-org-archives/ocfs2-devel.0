From: Matthew Wilcox (Oracle) <willy@infradead.org>
Date: Sun,  4 Oct 2020 19:04:28 +0100
Subject: [Ocfs2-devel] [PATCH 7/7] btrfs: Promote to unsigned long long
	before multiplying
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
Message-ID: <20201004180428.14494-8-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On 32-bit systems, these shifts will overflow for files larger than 4GB.
Add helper functions to avoid this problem coming back.

Cc: stable at vger.kernel.org
Fixes: 73ff61dbe5ed ("Btrfs: fix device replace of a missing RAID 5/6 device")
Fixes: be50a8ddaae1 ("Btrfs: Simplify scrub_setup_recheck_block()'s argument")
Fixes: ff023aac3119 ("Btrfs: add code to scrub to copy read data to another disk")
Fixes: b5d67f64f9bc ("Btrfs: change scrub to support big blocks")
Fixes: a2de733c78fa ("btrfs: scrub")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/scrub.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 354ab9985a34..ccbaf9c6e87a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1262,12 +1262,17 @@ static inline void scrub_stripe_index_and_offset(u64 logical, u64 map_type,
 	}
 }
 
+static u64 sblock_length(struct scrub_block *sblock)
+{
+	return (u64)sblock->page_count * PAGE_SIZE;
+}
+
 static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 				     struct scrub_block *sblocks_for_recheck)
 {
 	struct scrub_ctx *sctx = original_sblock->sctx;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
-	u64 length = original_sblock->page_count * PAGE_SIZE;
+	u64 length = sblock_length(original_sblock);
 	u64 logical = original_sblock->pagev[0]->logical;
 	u64 generation = original_sblock->pagev[0]->generation;
 	u64 flags = original_sblock->pagev[0]->flags;
@@ -1610,6 +1615,11 @@ static void scrub_write_block_to_dev_replace(struct scrub_block *sblock)
 	}
 }
 
+static u64 sbio_length(struct scrub_bio *sbio)
+{
+	return (u64)sbio->page_count * PAGE_SIZE;
+}
+
 static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
 					   int page_num)
 {
@@ -1659,10 +1669,9 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
 		bio->bi_opf = REQ_OP_WRITE;
 		sbio->status = 0;
-	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
+	} else if (sbio->physical + sbio_length(sbio) !=
 		   spage->physical_for_dev_replace ||
-		   sbio->logical + sbio->page_count * PAGE_SIZE !=
-		   spage->logical) {
+		   sbio->logical + sbio_length(sbio) != spage->logical) {
 		scrub_wr_submit(sctx);
 		goto again;
 	}
@@ -2005,10 +2014,8 @@ static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
 		bio->bi_opf = REQ_OP_READ;
 		sbio->status = 0;
-	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
-		   spage->physical ||
-		   sbio->logical + sbio->page_count * PAGE_SIZE !=
-		   spage->logical ||
+	} else if (sbio->physical + sbio_length(sbio) != spage->physical ||
+		   sbio->logical + sbio_length(sbio) != spage->logical ||
 		   sbio->dev != spage->dev) {
 		scrub_submit(sctx);
 		goto again;
@@ -2094,7 +2101,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 {
 	struct scrub_ctx *sctx = sblock->sctx;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
-	u64 length = sblock->page_count * PAGE_SIZE;
+	u64 length = sblock_length(sblock);
 	u64 logical = sblock->pagev[0]->logical;
 	struct btrfs_bio *bbio = NULL;
 	struct bio *bio;
-- 
2.28.0
