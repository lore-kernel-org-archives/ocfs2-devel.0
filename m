From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 26 Feb 2010 10:54:52 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Only bug out in direct io write for
	reflinked extent.
Message-ID: <1267152892-15727-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_direct_IO_get_blocks, we only need to bug out
in case of we are going to write a recounted extent rec.

What a silly bug introduced by me!

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 26b175b..03789dc 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -591,8 +591,9 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	/* We should already CoW the refcounted extent. */
-	BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
+	/* We should already CoW the refcounted extent in case of create. */
+	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
+
 	/*
 	 * get_more_blocks() expects us to describe a hole by clearing
 	 * the mapped bit on bh_result().
-- 
1.6.3.3.334.g916e1.dirty
