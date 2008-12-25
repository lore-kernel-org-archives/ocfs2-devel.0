From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:38 -0800
Subject: [Ocfs2-devel] [PATCH 23/35] ocfs2: Another hamming code
	optimization.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-24-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

In the calc_code_bit() function, we must find all powers of two beneath
the code bit number, *after* it's shifted by those powers of two.  This
requires a loop to see where it ends up.

We can optimize it by starting at its most significant bit.  This shaves
32% off the time, for a total of 67.6% shaved off of the original, naive
implementation.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/blockcheck.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 1d5083c..f102ec9 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -39,6 +39,35 @@
  * c = # total code bits (d + p)
  */
 
+
+/*
+ * Find the log base 2 of 32-bit v.
+ *
+ * Algorithm found on http://graphics.stanford.edu/~seander/bithacks.html,
+ * by Sean Eron Anderson.  Code on the page is in the public domain unless
+ * otherwise noted.
+ *
+ * This particular algorithm is credited to Eric Cole.
+ */
+static int find_highest_bit_set(unsigned int v)
+{
+
+	static const int MultiplyDeBruijnBitPosition[32] =
+	{
+		0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
+		31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9
+	};
+
+	v |= v >> 1; /* first round down to power of 2 */
+	v |= v >> 2;
+	v |= v >> 4;
+	v |= v >> 8;
+	v |= v >> 16;
+	v = (v >> 1) + 1;
+
+	return MultiplyDeBruijnBitPosition[(u32)(v * 0x077CB531UL) >> 27];
+}
+
 /*
  * Calculate the bit offset in the hamming code buffer based on the bit's
  * offset in the data buffer.  Since the hamming code reserves all
@@ -64,12 +93,21 @@ static unsigned int calc_code_bit(unsigned int i)
 	b = i + 1;
 
 	/*
+	 * As a cheat, we know that all bits below b's highest bit must be
+	 * parity bits, so we can start there.
+	 */
+        p = find_highest_bit_set(b);
+        b += p;
+
+	/*
 	 * For every power of two below our bit number, bump our bit.
 	 *
 	 * We compare with (b + 1) becuase we have to compare with what b
 	 * would be _if_ it were bumped up by the parity bit.  Capice?
+	 *
+	 * We start p at 2^p because of the cheat above.
 	 */
-	for (p = 0; (1 << p) < (b + 1); p++)
+	for (p = (1 << p); p < (b + 1); p <<= 1)
 		b++;
 
 	return b;
-- 
1.5.6
