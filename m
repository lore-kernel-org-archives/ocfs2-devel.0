From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  8 Apr 2010 16:33:02 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: make ocfs2_adjust_resv_from_alloc
	simple.
In-Reply-To: <20100407212423.GP11402@wotan.suse.de>
References: <20100407212423.GP11402@wotan.suse.de>
Message-ID: <1270715582-13702-1-git-send-email-tao.ma@oracle.com>
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

Note:
btw, this patch also fixes an original bug in the function
which I haven't found before.
	if (end < ocfs2_resv_end(resv))
		rhs = end - ocfs2_resv_end(resv);
This code is of course buggy. ;)

Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/reservations.c |   32 ++++++++++++--------------------
 fs/ocfs2/reservations.h |    3 ++-
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 32bad4a..4065002 100644
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
@@ -776,38 +776,28 @@ static void
 				     struct ocfs2_alloc_reservation *resv,
 				     unsigned int start, unsigned int end)
 {
-	unsigned int lhs = 0, rhs = 0;
+	unsigned int rhs = 0;
+	unsigned int old_end = ocfs2_resv_end(resv);
 
-	BUG_ON(start < resv->r_start);
+	BUG_ON(start != resv->r_start || old_end < end);
 
 	/*
 	 * Completely used? We can remove it then.
 	 */
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
+	rhs = old_end - end;
 
 	/*
-	 * This should have been trapped above. At the very least, rhs
-	 * should be non zero.
+	 * This should have been trapped above.
 	 */
-	BUG_ON(rhs == 0 && lhs == 0);
-
-	if (rhs >= lhs) {
-		unsigned int old_end = ocfs2_resv_end(resv);
+	BUG_ON(rhs == 0);
 
-		resv->r_start = end + 1;
-		resv->r_len = old_end - resv->r_start + 1;
-	} else {
-		resv->r_len = start - resv->r_start;
-	}
+	resv->r_start = end + 1;
+	resv->r_len = old_end - resv->r_start + 1;
 }
 
 void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
@@ -822,6 +812,8 @@ void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
 	if (resv == NULL)
 		return;
 
+	BUG_ON(cstart != resv->r_start);
+
 	spin_lock(&resv_lock);
 
 	mlog(0, "claim bits: cstart: %u cend: %u clen: %u r_start: %u "
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 25b0c0e..1e49cc2 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -149,7 +149,8 @@ int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
  * reservation. But we must always call this function when bits are claimed.
  * Internally, the reservations code will use this information to mark the
  * reservations bitmap. If resv is passed, it's next allocation window will be
- * calculated.
+ * calculated. It also expects that 'cstart' is the same as we passed back
+ * from ocfs2_resmap_resv_bits().
  */
 void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
 			       struct ocfs2_alloc_reservation *resv,
-- 
1.5.5
