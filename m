From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 19 Sep 2015 11:00:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: improve performance for localalloc
Message-ID: <55FCCFDC.5050607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently cluster allocation is always trying to find a victim chain
(a chian has most space), and this may lead to poor performance because
of discontiguous allocation in some scenarios.
Our test case is block size 4k, cluster size 1M and mount option with
localalloc=2048 (2G), since a gd is 32256M (about 31.5G) and a
localalloc window is only 2G, creating 50G file will result in 2G from
gd0, 2G from gd1, ...
One way to improve performance is enlarge localalloc window size (max
31104M), but this will make end user feel that about 30G is suddenly
"missing", and localalloc currently do not support steal, which means
one node cannot use another node's localalloc even it is not used in
fact. So using the last gd to record the allocation and continues with
the gd if it has enough space for a localalloc window can make the
allocation as more contiguous as possible.
Our test result is below (evaluated in IOPS), which is using iometer
running in VM, dynamic vhd virtual disk stored in ocfs2.
IO model                Original   After   Improved(%)
16K60%Write100%Random   703        876     24.59%
8K90%Write100%Random    735        827     12.59%
4K100%Write100%Random   859        915     6.52%
4K100%Read100%Random    2092       2600    24.30%

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Tested-by: Norton Zhu <norton.zhu@huawei.com>
---
 fs/ocfs2/suballoc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 4479029..26976b9 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1939,7 +1939,10 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
 	if (!status) {
-		hint = ocfs2_group_from_res(res);
+		if (ocfs2_is_cluster_bitmap(ac->ac_inode))
+			hint = res->sr_bg_blkno;
+		else
+			hint = ocfs2_group_from_res(res);
 		goto set_hint;
 	}
 	if (status < 0 && status != -ENOSPC) {
-- 
1.8.4.3
