From: Changwei Ge <gechangwei@live.cn>
Date: Wed, 16 May 2018 15:39:31 +0000
Subject: [Ocfs2-devel] [PATCH] Revert "ocfs2/o2hb: check len for
 bio_add_page() to avoid getting incorrect bio"
Message-ID: <SIXPR06MB0461721F398A5A92FC68C39ED5920@SIXPR06MB0461.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Changwei Ge <ge.changwei@h3c.com>

This reverts commit ba16ddfbeb9dde0df67cdb2006820e9cf4d99386.

From my test, this patch introduces a problem that mkfs can't have slots
more than 16 with 4k block size.

And the original logic is safe actually with the situation it mentions
so revert this commit.

Attach test log:
mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 0, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 1, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 2, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 3, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 4, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 5, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 6, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 7, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 8, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 9, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 10, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 11, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 12, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 13, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 14, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 15, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 16, vec_len = 4096,
vec_start = 0
(mkfs.ocfs2,27479,2):o2hb_setup_one_bio:471 ERROR: Adding page[16] to
bio failed, page ffffea0002d7ed40, len 0, vec_len 4096, vec_start 0,
bi_sector 8192
(mkfs.ocfs2,27479,2):o2hb_read_slots:500 ERROR: status = -5
(mkfs.ocfs2,27479,2):o2hb_populate_slot_data:1911 ERROR: status = -5
(mkfs.ocfs2,27479,2):o2hb_region_dev_write:2012 ERROR: status = -5

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/cluster/heartbeat.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 91a8889..ea8c551 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -570,16 +570,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 		     current_page, vec_len, vec_start);
 
 		len = bio_add_page(bio, page, vec_len, vec_start);
-		if (len != vec_len) {
-			mlog(ML_ERROR, "Adding page[%d] to bio failed, "
-			     "page %p, len %d, vec_len %u, vec_start %u, "
-			     "bi_sector %llu\n", current_page, page, len,
-			     vec_len, vec_start,
-			     (unsigned long long)bio->bi_iter.bi_sector);
-			bio_put(bio);
-			bio = ERR_PTR(-EIO);
-			return bio;
-		}
+		if (len != vec_len) break;
 
 		cs += vec_len / (PAGE_SIZE/spp);
 		vec_start = 0;
-- 
2.7.4
