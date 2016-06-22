From: Gang He <ghe@suse.com>
Date: Wed, 22 Jun 2016 13:44:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: disable BUG assertions in reading
	blocks
Message-ID: <1466574294-26863-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, rgoldwyn@suse.de, ghe@suse.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

According to some high-load testing, these two BUG assertions
were encountered, this led system panic. Actually, there were
some discussions about removing these two BUG() assertions, it
would not bring any side effect.
Then, I did the the following changes,
1) use the existing macro CATCH_BH_JBD_RACES to wrap BUG() in
the ocfs2_read_blocks_sync function like before.
2) disable the macro CATCH_BH_JBD_RACES in Makefile by default.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/Makefile         | 2 --
 fs/ocfs2/buffer_head_io.c | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index e27e652..4342c7e 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -1,7 +1,5 @@
 ccflags-y := -Ifs/ocfs2
 
-ccflags-y += -DCATCH_BH_JBD_RACES
-
 obj-$(CONFIG_OCFS2_FS) += 	\
 	ocfs2.o			\
 	ocfs2_stackglue.o
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index fe50ded..498641e 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -139,11 +139,16 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 
 		lock_buffer(bh);
 		if (buffer_jbd(bh)) {
+#ifdef CATCH_BH_JBD_RACES
 			mlog(ML_ERROR,
 			     "block %llu had the JBD bit set "
 			     "while I was in lock_buffer!",
 			     (unsigned long long)bh->b_blocknr);
 			BUG();
+#else
+			unlock_buffer(bh);
+			continue;
+#endif
 		}
 
 		clear_buffer_uptodate(bh);
-- 
1.8.5.6
