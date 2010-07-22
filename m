From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 22 Jul 2010 09:50:38 -0500
Subject: [Ocfs2-devel] [TRIVIAL] [PATCH] Remove unnecessary goto statements
Message-ID: <AANLkTilVfUTA63SEMhnaagn-mmmEWwfKgogpYcJwdqxA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove unnecessary goto statements.
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

---
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c30b644..c91527f 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -824,10 +824,8 @@ int ocfs2_reserve_cluster_bitmap_bits(struct
ocfs2_super *osb,
 					     ALLOC_NEW_GROUP);
 	if (status < 0 && status != -ENOSPC) {
 		mlog_errno(status);
-		goto bail;
 	}

-bail:
 	return status;
 }

@@ -1050,7 +1048,6 @@ static inline int
ocfs2_block_group_set_bits(handle_t *handle,
 				     group_bh);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
 	}

 bail:
