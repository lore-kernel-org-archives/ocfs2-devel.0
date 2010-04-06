From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  6 Apr 2010 15:40:32 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make ocfs2_adjust_resv_from_alloc
	simple.
Message-ID: <1270539632-4509-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we allocate some bits from the reservation, we always
allocate from the r_start(see ocfs2_resmap_resv_bits).
So there should be no sense for checking between r_start
and start. And I don't think we will change this behaviour
somehow later by allocating from some bits after r_start.
Why not make ocfs2_adjust_resv_from_alloc simple now?

So the only chance we have to adjust the reservation is that
we haven't reached the end. With this patch, the function is
more readable.

Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/reservations.c |   33 ++++++++++-----------------------
 1 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 32bad4a..d841535 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -406,7 +406,7 @@ ocfs2_find_resv_lhs(struct ocfs2_reservation_map *resmap, unsigned int goal)
  * The start value of *rstart is insignificant.
  *
  * This function searches the bitmap range starting at search_start
- * with length csearch_len for a set of contiguous free bits. We try
+ * with length search_len for a set of contiguous free bits. We try
  * to find up to 'wanted' bits, but can sometimes return less.
  *
  * Returns the length of allocation, 0 if no free bits are found.
@@ -776,38 +776,25 @@ static void
 				     struct ocfs2_alloc_reservation *resv,
 				     unsigned int start, unsigned int end)
 {
-	unsigned int lhs = 0, rhs = 0;
+	unsigned int rhs = 0;
+	unsigned int old_end = ocfs2_resv_end(resv);
 
-	BUG_ON(start < resv->r_start);
+	BUG_ON(start != resv->r_start || old_end < end);
 
-	/*
-	 * Completely used? We can remove it then.
-	 */
-	if (ocfs2_resv_end(resv) <= end && resv->r_start >= start) {
+	if (old_end == end) {
 		__ocfs2_resv_discard(resmap, resv);
 		return;
 	}
 
-	if (end < ocfs2_resv_end(resv))
-		rhs = end - ocfs2_resv_end(resv);
-
-	if (start > resv->r_start)
-		lhs = start - resv->r_start;
+	rhs = end - ocfs2_resv_end(resv);
 
 	/*
-	 * This should have been trapped above. At the very least, rhs
-	 * should be non zero.
+	 * This should have been trapped above.
 	 */
-	BUG_ON(rhs == 0 && lhs == 0);
+	BUG_ON(rhs == 0);
 
-	if (rhs >= lhs) {
-		unsigned int old_end = ocfs2_resv_end(resv);
-
-		resv->r_start = end + 1;
-		resv->r_len = old_end - resv->r_start + 1;
-	} else {
-		resv->r_len = start - resv->r_start;
-	}
+	resv->r_start = end + 1;
+	resv->r_len = old_end - resv->r_start + 1;
 }
 
 void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
-- 
1.5.5
