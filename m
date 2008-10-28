From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:28 -0700
Subject: [Ocfs2-devel] [PATCH 13/13] ocfs2: Use buckets in
	ocfs2_xattr_set_entry_in_bucket().
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1225156828-32189-14-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2_xattr_set_entry_in_bucket() function is already working on an
ocfs2_xattr_bucket structure, so let's use the bucket API.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a24a27c..c8c979a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4004,25 +4004,24 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 {
 	int ret;
 	handle_t *handle = NULL;
-	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u64 blkno;
 
 	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
 	     (unsigned long)xi->value_len, xi->name_index,
 	     (unsigned long long)bucket_blkno(xs->bucket));
 
 	if (!xs->bucket->bu_bhs[1]) {
-		ret = ocfs2_read_blocks(inode,
-					bucket_blkno(xs->bucket) + 1,
-					blk_per_bucket - 1, &xs->bucket->bu_bhs[1],
-					0);
+		blkno = bucket_blkno(xs->bucket);
+		ocfs2_xattr_bucket_relse(xs->bucket);
+		ret = ocfs2_read_xattr_bucket(xs->bucket, blkno);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
 	}
 
-	handle = ocfs2_start_trans(osb, blk_per_bucket);
+	handle = ocfs2_start_trans(osb, xs->bucket->bu_blocks);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		handle = NULL;
-- 
1.5.6.5
