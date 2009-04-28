From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 29 Apr 2009 01:20:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Remove unused variable in
	ocfs2_rename.
Message-ID: <1240939255-22590-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

With indexed dir enabled, now we use ocfs2_dir_lookup_result to
wrap all the bh used for dir. So remove the 2 unused variables.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2220f93..33464c6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1025,10 +1025,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct inode *orphan_dir = NULL;
 	struct ocfs2_dinode *newfe = NULL;
 	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
-	struct buffer_head *orphan_entry_bh = NULL;
 	struct buffer_head *newfe_bh = NULL;
 	struct buffer_head *old_inode_bh = NULL;
-	struct buffer_head *insert_entry_bh = NULL;
 	struct ocfs2_super *osb = NULL;
 	u64 newfe_blkno, old_de_ino;
 	handle_t *handle = NULL;
@@ -1455,8 +1453,6 @@ bail:
 	brelse(old_inode_bh);
 	brelse(old_dir_bh);
 	brelse(new_dir_bh);
-	brelse(orphan_entry_bh);
-	brelse(insert_entry_bh);
 
 	mlog_exit(status);
 
-- 
1.5.5
