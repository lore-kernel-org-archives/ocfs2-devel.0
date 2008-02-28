From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb 28 17:27:59 2008
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix writeout in
	ocfs2_data_convert_worker()
Message-ID: <20080229012643.GA9349@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit f1f540688eae66c274ff1c1133b5d9c687b28f58 "optimized"
ocfs2_data_convert_worker() to "only do work for regular files".
Unfortunately, I left out a '!', which casued it to *skip* regular files.
This was hidden from testing until recently because the default data
journaling mode (data=ordered) doesn't exercise this code.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 351130c..f4b3dab 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3042,7 +3042,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;
 
-	if (S_ISREG(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		goto out;
 
 	/*
-- 
1.5.3.6
