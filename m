From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:10 -0800
Subject: [Ocfs2-devel] [PATCH 29/56] ocfs2: Use BH_JBDPrivateStart instead
	of BH_Unshadow
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-30-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

This is safer. We no longer have to worry about tracking changes to
jbd_state_bits.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/buffer_head_io.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 0e9eed0..15c8e6d 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -42,11 +42,10 @@
 /*
  * Bits on bh->b_state used by ocfs2.
  *
- * These MUST be after the JBD2 bits.  Currently BH_Unshadow is the last
- * JBD2 bit.
+ * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
  */
 enum ocfs2_state_bits {
-	BH_NeedsValidate = BH_Unshadow + 1,
+	BH_NeedsValidate = BH_JBDPrivateStart,
 };
 
 /* Expand the magic b_state functions */
-- 
1.5.6
