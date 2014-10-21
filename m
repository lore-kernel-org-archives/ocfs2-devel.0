From: Jan Kara <jack@suse.cz>
Date: Tue, 21 Oct 2014 17:02:54 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove pointless assignment in
	ocfs2_init()
Message-ID: <1413903774-18825-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove assignment which is never used.

Coverity-id: 1227009
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 93c85bc745e1..e1be0f0ea411 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1621,10 +1621,8 @@ static int __init ocfs2_init(void)
 	}
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
-	if (!ocfs2_debugfs_root) {
-		status = -EFAULT;
+	if (!ocfs2_debugfs_root)
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
-	}
 
 	ocfs2_set_locking_protocol();
 
-- 
1.8.1.4
