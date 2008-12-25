From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:39 -0800
Subject: [Ocfs2-devel] [PATCH 24/35] ocfs2: One more hamming code
	optimization.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-25-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

The previous optimization used a fast find-highest-bit-set operation to
give us a good starting point in calc_code_bit().  This version lets the
caller cache the previous code buffer bit offset.  Thus, the next call
always starts where the last one left off.

This reduces the calculation another 39%, for a total 80% reduction from
the original, naive implementation.  At least, on my machine.  This also
brings the parity calculation to within an order of magnitude of the
crc32 calculation.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/blockcheck.c |   61 +++++++++++++++---------------------------------
 1 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index f102ec9..2a947c4 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -41,34 +41,6 @@
 
 
 /*
- * Find the log base 2 of 32-bit v.
- *
- * Algorithm found on http://graphics.stanford.edu/~seander/bithacks.html,
- * by Sean Eron Anderson.  Code on the page is in the public domain unless
- * otherwise noted.
- *
- * This particular algorithm is credited to Eric Cole.
- */
-static int find_highest_bit_set(unsigned int v)
-{
-
-	static const int MultiplyDeBruijnBitPosition[32] =
-	{
-		0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
-		31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9
-	};
-
-	v |= v >> 1; /* first round down to power of 2 */
-	v |= v >> 2;
-	v |= v >> 4;
-	v |= v >> 8;
-	v |= v >> 16;
-	v = (v >> 1) + 1;
-
-	return MultiplyDeBruijnBitPosition[(u32)(v * 0x077CB531UL) >> 27];
-}
-
-/*
  * Calculate the bit offset in the hamming code buffer based on the bit's
  * offset in the data buffer.  Since the hamming code reserves all
  * power-of-two bits for parity, the data bit number and the code bit
@@ -81,10 +53,14 @@ static int find_highest_bit_set(unsigned int v)
  * so it's a parity bit.  2 is a power of two (2^1), so it's a parity bit.
  * 3 is not a power of two.  So bit 1 of the data buffer ends up as bit 3
  * in the code buffer.
+ *
+ * The caller can pass in *p if it wants to keep track of the most recent
+ * number of parity bits added.  This allows the function to start the
+ * calculation at the last place.
  */
-static unsigned int calc_code_bit(unsigned int i)
+static unsigned int calc_code_bit(unsigned int i, unsigned int *p_cache)
 {
-	unsigned int b, p;
+	unsigned int b, p = 0;
 
 	/*
 	 * Data bits are 0-based, but we're talking code bits, which
@@ -92,24 +68,25 @@ static unsigned int calc_code_bit(unsigned int i)
 	 */
 	b = i + 1;
 
-	/*
-	 * As a cheat, we know that all bits below b's highest bit must be
-	 * parity bits, so we can start there.
-	 */
-        p = find_highest_bit_set(b);
+	/* Use the cache if it is there */
+	if (p_cache)
+		p = *p_cache;
         b += p;
 
 	/*
 	 * For every power of two below our bit number, bump our bit.
 	 *
-	 * We compare with (b + 1) becuase we have to compare with what b
+	 * We compare with (b + 1) because we have to compare with what b
 	 * would be _if_ it were bumped up by the parity bit.  Capice?
 	 *
-	 * We start p at 2^p because of the cheat above.
+	 * p is set above.
 	 */
-	for (p = (1 << p); p < (b + 1); p <<= 1)
+	for (; (1 << p) < (b + 1); p++)
 		b++;
 
+	if (p_cache)
+		*p_cache = p;
+
 	return b;
 }
 
@@ -126,7 +103,7 @@ static unsigned int calc_code_bit(unsigned int i)
  */
 u32 ocfs2_hamming_encode(u32 parity, void *data, unsigned int d, unsigned int nr)
 {
-	unsigned int i, b;
+	unsigned int i, b, p = 0;
 
 	BUG_ON(!d);
 
@@ -145,7 +122,7 @@ u32 ocfs2_hamming_encode(u32 parity, void *data, unsigned int d, unsigned int nr
 		 * i is the offset in this hunk, nr + i is the total bit
 		 * offset.
 		 */
-		b = calc_code_bit(nr + i);
+		b = calc_code_bit(nr + i, &p);
 
 		/*
 		 * Data bits in the resultant code are checked by
@@ -201,7 +178,7 @@ void ocfs2_hamming_fix(void *data, unsigned int d, unsigned int nr,
 	 * nr + d is the bit right past the data hunk we're looking at.
 	 * If fix after that, nothing to do
 	 */
-	if (fix >= calc_code_bit(nr + d))
+	if (fix >= calc_code_bit(nr + d, NULL))
 		return;
 
 	/*
@@ -209,7 +186,7 @@ void ocfs2_hamming_fix(void *data, unsigned int d, unsigned int nr,
 	 * start b at the offset in the code buffer.  See hamming_encode()
 	 * for a more detailed description of 'b'.
 	 */
-	b = calc_code_bit(nr);
+	b = calc_code_bit(nr, NULL);
 	/* If the fix is before this hunk, nothing to do */
 	if (fix < b)
 		return;
-- 
1.5.6
