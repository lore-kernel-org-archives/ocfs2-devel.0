From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 27 Aug 2013 23:15:52 -0500
Subject: [Ocfs2-devel] [PATCH] Use bigger nodestr to accomodate 32-bit node
	numbers
Message-ID: <20130828041547.GA4404@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While using pacemaker/corosync, the node numbers are generated using
IP address as opposed to serial node number generation. This may
not fit in a 8-byte string. Use a bigger string to print the 
complete node number.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
--- 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 854d809..bc947e0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1022,7 +1022,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode = NULL;
 	struct ocfs2_super *osb = NULL;
 	struct buffer_head *bh = NULL;
-	char nodestr[8];
+	char nodestr[12];
 	struct ocfs2_blockcheck_stats stats;
 
 	trace_ocfs2_fill_super(sb, data, silent);

-- 
Goldwyn
