From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 3 Aug 2011 17:49:15 -0500
Subject: [Ocfs2-devel] [PATCH 2/3] Return EIO instead of EROFS in case of
	dx_dir errors
Message-ID: <CAJtY7HW=FF0A2DXPc3XC9hxzb_HfY0PZNZx23ZpSZ9tCVQA_oA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/dir.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index fdb4ed9..94061ab 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -618,11 +618,11 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 	}

 	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
-		ocfs2_error(sb,
+		mlog(ML_ERROR,
 			    "Dir Index Root # %llu has bad signature %.*s",
 			    (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
 			    7, dx_root->dr_signature);
-		return -EINVAL;
+		return -EIO;
 	}

 	return 0;
@@ -662,9 +662,9 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 	}

 	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
-		ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
+		mlog(ML_ERROR, "Dir Index Leaf has bad signature %.*s",
 			    7, dx_leaf->dl_signature);
-		return -EROFS;
+		return -EIO;
 	}

 	return 0;
-- 
1.7.6
