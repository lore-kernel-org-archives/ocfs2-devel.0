From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Jul 2010 13:56:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Count more refcount records in file
	system fragmentation.
Message-ID: <1279778205-7428-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The refcount record calculation in ocfs2_calc_refcount_meta_credits
is too optimistic that we can always allocate contiguous clusters
and handle an already existed refcount rec as a whole. Actually
because of file system fragmentation, we may have the chance to split
a refcount record into 3 parts during the transaction. So consider
the worst case in record calculation.

Cc: stable at kernel.org
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3ac5aa7..b75ecd8 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2436,16 +2436,26 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 		len = min((u64)cpos + clusters, le64_to_cpu(rec.r_cpos) +
 			  le32_to_cpu(rec.r_clusters)) - cpos;
 		/*
-		 * If the refcount rec already exist, cool. We just need
-		 * to check whether there is a split. Otherwise we just need
-		 * to increase the refcount.
-		 * If we will insert one, increases recs_add.
-		 *
 		 * We record all the records which will be inserted to the
 		 * same refcount block, so that we can tell exactly whether
 		 * we need a new refcount block or not.
+		 *
+		 * If we will insert a new one, this is easy and only happens
+		 * during adding refcounted flag to the extent, so we don't
+		 * have a chance of spliting. We just need one record.
+		 *
+		 * If the refcount rec already exists, that would be a little
+		 * complicated. we may have to:
+		 * 1) split at the beginning if the start pos isn't aligned.
+		 *    we need 1 more record in this case.
+		 * 2) split int the end if the end pos isn't aligned.
+		 *    we need 1 more record in this case.
+		 * 3) split in the middle because of file system fragmentation.
+		 *    we need 2 more records in this case(we can't detect this
+		 *    beforehand, so always think of the worst case).
 		 */
 		if (rec.r_refcount) {
+			recs_add += 2;
 			/* Check whether we need a split at the beginning. */
 			if (cpos == start_cpos &&
 			    cpos != le64_to_cpu(rec.r_cpos))
-- 
1.7.1.GIT
