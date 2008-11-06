From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  6 Nov 2008 08:10:47 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/xattr: Remove additional bucket
	allocation in bucket defragment.
In-Reply-To: <49129D87.5040600@oracle.com>
References: <49129D87.5040600@oracle.com>
Message-ID: <1225930248-16502-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel has refactored xattr bucket and make xattr bucket a general
wrapper. So in ocfs2_defrag_xattr_bucket, we have already passed the
bucket in, so there is no need to allocate a new one and read it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b0a73c2..501c9e7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2896,7 +2896,6 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	size_t blocksize = inode->i_sb->s_blocksize;
 	handle_t *handle;
 	struct ocfs2_xattr_entry *xe;
-	struct ocfs2_xattr_bucket *wb = NULL;
 
 	/*
 	 * In order to make the operation more efficient and generic,
@@ -2910,21 +2909,11 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	wb = ocfs2_xattr_bucket_new(inode);
-	if (!wb) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = ocfs2_read_xattr_bucket(wb, blkno);
-	if (ret)
-		goto out;
-
 	buf = bucket_buf;
-	for (i = 0; i < wb->bu_blocks; i++, buf += blocksize)
-		memcpy(buf, bucket_block(wb, i), blocksize);
+	for (i = 0; i < bucket->bu_blocks; i++, buf += blocksize)
+		memcpy(buf, bucket_block(bucket, i), blocksize);
 
-	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), wb->bu_blocks);
+	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)), bucket->bu_blocks);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		handle = NULL;
@@ -2932,7 +2921,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_xattr_bucket_journal_access(handle, wb,
+	ret = ocfs2_xattr_bucket_journal_access(handle, bucket,
 						OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -3005,14 +2994,13 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	     cmp_xe, swap_xe);
 
 	buf = bucket_buf;
-	for (i = 0; i < wb->bu_blocks; i++, buf += blocksize)
-		memcpy(bucket_block(wb, i), buf, blocksize);
-	ocfs2_xattr_bucket_journal_dirty(handle, wb);
+	for (i = 0; i < bucket->bu_blocks; i++, buf += blocksize)
+		memcpy(bucket_block(bucket, i), buf, blocksize);
+	ocfs2_xattr_bucket_journal_dirty(handle, bucket);
 
 commit:
 	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 out:
-	ocfs2_xattr_bucket_free(wb);
 	kfree(bucket_buf);
 	return ret;
 }
-- 
1.5.4.GIT
