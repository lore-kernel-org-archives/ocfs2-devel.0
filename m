From: Coly Li <coly.li@suse.de>
Date: Thu, 22 Oct 2009 13:56:22 +0800
Subject: [Ocfs2-devel] [PATCH] indexed-dirs: fix brelse order in
 ocfs2_find_entry_dx(), v2
Message-ID: <4ADFF406.5010700@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_find_entry_dx(), if ocfs2_read_inode_block() failed, both di_bh and dx_root_bh are both released. In this case,
for dx_root_bh, it's unnecessary (even buggy if refcount of dx_root_bh is non-zero).

This patch fixes this issue by change brelse order of di_bh and dx_root_bh.

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/dir.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 28c3ec2..502a3e9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1048,7 +1048,7 @@ static int ocfs2_find_entry_dx(const char *name, int namelen,
 	ret = ocfs2_read_inode_block(dir, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto brelse_di;
 	}

 	di = (struct ocfs2_dinode *)di_bh->b_data;
@@ -1056,7 +1056,7 @@ static int ocfs2_find_entry_dx(const char *name, int namelen,
 	ret = ocfs2_read_dx_root(dir, di, &dx_root_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto brelse_dx_root;
 	}
 	dx_root = (struct ocfs2_dx_root_block *) dx_root_bh->b_data;

@@ -1064,14 +1064,16 @@ static int ocfs2_find_entry_dx(const char *name, int namelen,
 	if (ret) {
 		if (ret != -ENOENT)
 			mlog_errno(ret);
-		goto out;
+		goto brelse_dx_root;
 	}

 	lookup->dl_dx_root_bh = dx_root_bh;
-	dx_root_bh = NULL;
-out:
-	brelse(di_bh);
+	goto brelse_di;
+
+brelse_dx_root:
 	brelse(dx_root_bh);
+brelse_di:
+	brelse(di_bh);
 	return ret;
 }

-- 
Coly Li
SuSE Labs
