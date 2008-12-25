From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:37 -0800
Subject: [Ocfs2-devel] [PATCH 22/35] ocfs2: Don't hand-code xor in
	ocfs2_hamming_encode().
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-23-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

When I wrote ocfs2_hamming_encode(), I was following documentation of
the algorithm and didn't have quite the (possibly still imperfect) grasp
of it I do now.  As part of this, I literally hand-coded xor.  I would
test a bit, and then add that bit via xor to the parity word.

I can, of course, just do a single xor of the parity word and the source
word (the code buffer bit offset).  This cuts CPU usage by 53% on a
mostly populated buffer (an inode containing utmp.h inline).

Joel

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/blockcheck.c |   67 ++++++++++++++----------------------------------
 1 files changed, 20 insertions(+), 47 deletions(-)

diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index 2ce6ae5..1d5083c 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -31,7 +31,6 @@
 #include "blockcheck.h"
 
 
-
 /*
  * We use the following conventions:
  *
@@ -39,26 +38,6 @@
  * p = # parity bits
  * c = # total code bits (d + p)
  */
-static int calc_parity_bits(unsigned int d)
-{
-	unsigned int p;
-
-	/*
-	 * Bits required for Single Error Correction is as follows:
-	 *
-	 * d + p + 1 <= 2^p
-	 *
-	 * We're restricting ourselves to 31 bits of parity, that should be
-	 * sufficient.
-	 */
-	for (p = 1; p < 32; p++)
-	{
-		if ((d + p + 1) <= (1 << p))
-			return p;
-	}
-
-	return 0;
-}
 
 /*
  * Calculate the bit offset in the hamming code buffer based on the bit's
@@ -109,10 +88,9 @@ static unsigned int calc_code_bit(unsigned int i)
  */
 u32 ocfs2_hamming_encode(u32 parity, void *data, unsigned int d, unsigned int nr)
 {
-	unsigned int p = calc_parity_bits(nr + d);
-	unsigned int i, j, b;
+	unsigned int i, b;
 
-	BUG_ON(!p);
+	BUG_ON(!d);
 
 	/*
 	 * b is the hamming code bit number.  Hamming code specifies a
@@ -131,27 +109,23 @@ u32 ocfs2_hamming_encode(u32 parity, void *data, unsigned int d, unsigned int nr
 		 */
 		b = calc_code_bit(nr + i);
 
-		for (j = 0; j < p; j++)
-		{
-			/*
-			 * Data bits in the resultant code are checked by
-			 * parity bits that are part of the bit number
-			 * representation.  Huh?
-			 *
-			 * <wikipedia href="http://en.wikipedia.org/wiki/Hamming_code">
-			 * In other words, the parity bit at position 2^k
-			 * checks bits in positions having bit k set in
-			 * their binary representation.  Conversely, for
-			 * instance, bit 13, i.e. 1101(2), is checked by
-			 * bits 1000(2) = 8, 0100(2)=4 and 0001(2) = 1.
-			 * </wikipedia>
-			 *
-			 * Note that 'k' is the _code_ bit number.  'b' in
-			 * our loop.
-			 */
-			if (b & (1 << j))
-				parity ^= (1 << j);
-		}
+		/*
+		 * Data bits in the resultant code are checked by
+		 * parity bits that are part of the bit number
+		 * representation.  Huh?
+		 *
+		 * <wikipedia href="http://en.wikipedia.org/wiki/Hamming_code">
+		 * In other words, the parity bit at position 2^k
+		 * checks bits in positions having bit k set in
+		 * their binary representation.  Conversely, for
+		 * instance, bit 13, i.e. 1101(2), is checked by
+		 * bits 1000(2) = 8, 0100(2)=4 and 0001(2) = 1.
+		 * </wikipedia>
+		 *
+		 * Note that 'k' is the _code_ bit number.  'b' in
+		 * our loop.
+		 */
+		parity ^= b;
 	}
 
 	/* While the data buffer was treated as little endian, the
@@ -174,10 +148,9 @@ u32 ocfs2_hamming_encode_block(void *data, unsigned int blocksize)
 void ocfs2_hamming_fix(void *data, unsigned int d, unsigned int nr,
 		       unsigned int fix)
 {
-	unsigned int p = calc_parity_bits(nr + d);
 	unsigned int i, b;
 
-	BUG_ON(!p);
+	BUG_ON(!d);
 
 	/*
 	 * If the bit to fix has an hweight of 1, it's a parity bit.  One
-- 
1.5.6
