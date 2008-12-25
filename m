From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:24 -0800
Subject: [Ocfs2-devel] [PATCH 09/35] ocfs2: Add ecc and checksums to ocfs2
	xattr buckets.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-10-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

The xattr bucket can span multiple blocks on disk.  We have wrappers
for this structure in the code.  We use the new multi-block ecc calls to
calculate and validate the bucket.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bc822d6..7c2f4c9 100644
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
-- 
1.5.6
