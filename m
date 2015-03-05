From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 5 Mar 2015 14:47:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix typo in
	ocfs2_reserve_local_alloc_bits
Message-ID: <54F7FBEC.9030108@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_reserve_local_alloc_bits, it calls ocfs2_error if local alloc
inode bitmap used bits mismatch, but the log mistakes it as free bits.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/localalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 0440134..096cff6 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -666,7 +666,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
 		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-			    "%u free bits, but a count shows %u",
+			    "%u used bits, but a count shows %u",
 			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
 			    le32_to_cpu(alloc->id1.bitmap1.i_used),
 			    ocfs2_local_alloc_count_bits(alloc));
-- 
1.8.4.3
