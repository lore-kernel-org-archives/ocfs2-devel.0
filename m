From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:46:14 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: truncate page cache for clone
 destination file before remapping
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
Message-ID: <153870037408.29072.13917200269931783121.stgit@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

When cloning blocks into another file, truncate the page cache before we
start remapping blocks so that concurrent reads wait for us to finish.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3758954f2377..02283c38b5a4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4853,14 +4853,12 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		down_write_nested(&OCFS2_I(inode_out)->ip_alloc_sem,
 				  SINGLE_DEPTH_NESTING);
 
-	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
-					 out_bh, pos_out, len);
-
 	/* Zap any page cache for the destination file's range. */
-	if (!ret)
-		truncate_inode_pages_range(&inode_out->i_data, pos_out,
-					   PAGE_ALIGN(pos_out + len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + len) - 1);
 
+	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
+					 out_bh, pos_out, len);
 	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
 	if (!same_inode)
 		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
