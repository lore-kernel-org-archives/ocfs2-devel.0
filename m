From: piaojun <piaojun@huawei.com>
Date: Wed, 28 Mar 2018 11:50:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/o2hb: check len for bio_add_page() to
 avoid submitting incorrect bio
Message-ID: <5ABB110A.3050808@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We need check len for bio_add_page() to make sure the bio has been set up
correctly, otherwise we may submit incorrect data to device.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/cluster/heartbeat.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ea8c551..43ad79f 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -570,7 +570,16 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 		     current_page, vec_len, vec_start);

 		len = bio_add_page(bio, page, vec_len, vec_start);
-		if (len != vec_len) break;
+		if (len != vec_len) {
+			mlog(ML_ERROR, "Adding page[%d] to bio failed, "
+			     "page %p, len %d, vec_len %u, vec_start %u, "
+			     "bi_sector %llu\n", current_page, page, len,
+			     vec_len, vec_start,
+			     (unsigned long long)bio->bi_iter.bi_sector);
+			bio_put(bio);
+			bio = ERR_PTR(-EFAULT);
+			return bio;
+		}

 		cs += vec_len / (PAGE_SIZE/spp);
 		vec_start = 0;
-- 
