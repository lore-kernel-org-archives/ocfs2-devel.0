From: Coly Li <coly.li@suse.de>
Date: Thu, 22 Oct 2009 13:40:03 +0800
Subject: [Ocfs2-devel] [PATCH] indexed-dirs: fix brelse order in
	ocfs2_find_entry_dx()
Message-ID: <4ADFF033.4040104@suse.de>
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
 fs/ocfs2/dir.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 28c3ec2..05aa238 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1048,7 +1048,7 @@ static int ocfs2_find_entry_dx(const char *name, int namelen,
 	ret = ocfs2_read_inode_block(dir, &di_bh);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_di;
 	}

 	di = (struct ocfs2_dinode *)di_bh->b_data;
@@ -1070,8 +1070,9 @@ static int ocfs2_find_entry_dx(const char *name, int namelen,
 	lookup->dl_dx_root_bh = dx_root_bh;
 	dx_root_bh = NULL;
 out:
-	brelse(di_bh);
 	brelse(dx_root_bh);
+out_di:
+	brelse(di_bh);
 	return ret;
 }

-- 
Coly Li
SuSE Labs
