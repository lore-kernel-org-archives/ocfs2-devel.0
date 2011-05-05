From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 5 May 2011 10:44:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Initialize data_ac (might be used
	uninitialized)
Message-ID: <20110505174411.GB17822@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Marcus Meissner <meissner@suse.de>

CLANG found that there is a path that has data_ac uninitialized,
this place
	2917	/* This gets us the dx_root */
	2918	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
	2919	if (ret) {

	3
		Taking true branch
	2920	mlog_errno(ret);
	2921	goto out;

	4
		Control jumps to line 3168
	2922	}

Goes to the out: label without data_ac being initialized.

Ciao, Marcus

Signed-Off-By: Marcus Meissner <meissner@suse.de>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

---
 fs/ocfs2/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 9fe5b8f..8582e3f 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2868,7 +2868,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		bytes = blocks_wanted << sb->s_blocksize_bits;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_inode_info *oi = OCFS2_I(dir);
-	struct ocfs2_alloc_context *data_ac;
+	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	struct buffer_head *dirdata_bh = NULL;
 	struct buffer_head *dx_root_bh = NULL;
-- 
1.7.4.1
