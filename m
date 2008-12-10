From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:46 -0800
Subject: [Ocfs2-devel] [PATCH 09/18] ocfs2: Add ecc and checksums to ocfs2
	xattr buckets.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-10-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The xattr bucket can span multiple blocks on disk.  We have wrappers
for this structure in the code.  We use the new multi-block ecc calls to
calculate and validate the bucket.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dcf26ad..1540e4d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -273,6 +273,15 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	rc = ocfs2_read_blocks(bucket->bu_inode, xb_blkno,
 			       bucket->bu_blocks, bucket->bu_bhs, 0,
 			       NULL);
+	if (!rc) {
+		rc = ocfs2_validate_meta_ecc_bhs(bucket->bu_inode->i_sb,
+						 bucket->bu_bhs,
+						 bucket->bu_blocks,
+						 &bucket_xh(bucket)->xh_check);
+		if (rc)
+			mlog_errno(rc);
+	}
+
 	if (rc)
 		ocfs2_xattr_bucket_relse(bucket);
 	return rc;
@@ -301,6 +310,10 @@ static void ocfs2_xattr_bucket_journal_dirty(handle_t *handle,
 {
 	int i;
 
+	ocfs2_compute_meta_ecc_bhs(bucket->bu_inode->i_sb,
+				   bucket->bu_bhs, bucket->bu_blocks,
+				   &bucket_xh(bucket)->xh_check);
+
 	for (i = 0; i < bucket->bu_blocks; i++)
 		ocfs2_journal_dirty(handle, bucket->bu_bhs[i]);
 }
@@ -3080,7 +3093,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 		if (func) {
 			ret = func(inode, bucket, para);
 			if (ret)
-  				mlog_errno(ret);
+				mlog_errno(ret);
 			/* Fall through to bucket_relse() */
 		}
 
-- 
1.5.6.5
