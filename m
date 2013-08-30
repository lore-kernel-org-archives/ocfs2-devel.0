From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Fri, 30 Aug 2013 08:42:43 -0500
Subject: [Ocfs2-devel] [PATCH] Use a bigger nodestr in ocfs2_dismount_volume
Message-ID: <20130830134238.GA4472@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While printing 32-bit node numbers, an 8-byte string is not enough.
Increase the size of the string to 12 chars.

This got left out in 49fa8140e487b492da24c76ac3cccad0a0ae63e4

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 121da2d..d4e81e4 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1924,7 +1924,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 {
 	int tmp, hangup_needed = 0;
 	struct ocfs2_super *osb = NULL;
-	char nodestr[8];
+	char nodestr[12];
 
 	trace_ocfs2_dismount_volume(sb);
 
-- 
Goldwyn
