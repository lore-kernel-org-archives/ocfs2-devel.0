From: Jan Kara <jack@suse.cz>
Date: Wed, 21 Jan 2015 13:46:05 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove pointless assignment from
	ocfs2_calc_refcount_meta_credits()
Message-ID: <1421844365-15343-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The assigned value is never used.

Coverity-id: 1226847
CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/refcounttree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d81f6e2a97f5..ee541f92dab4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2428,8 +2428,6 @@ static int ocfs2_calc_refcount_meta_credits(struct super_block *sb,
 			get_bh(prev_bh);
 		}
 
-		rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
-
 		trace_ocfs2_calc_refcount_meta_credits_iterate(
 				recs_add, (unsigned long long)cpos, clusters,
 				(unsigned long long)le64_to_cpu(rec.r_cpos),
-- 
2.1.2
