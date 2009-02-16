From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 16 Feb 2009 15:43:40 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: set gap to seperate entry and
	value when xattr in bucket
In-Reply-To: <49991812.3090005@oracle.com>
References: <49991812.3090005@oracle.com>
Message-ID: <1234770220-9946-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch set a gap (4 bytes) between xattr entry and
name/value when xattr in bucket. This gap use to seperate
entry and name/value when a bucket is full. It had already
been set when xattr in inode/block.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 41c9c5d..880bcb3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -82,6 +82,7 @@ struct ocfs2_xattr_set_ctxt {
 
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
 #define OCFS2_XATTR_INLINE_SIZE	80
+#define OCFS2_XATTR_HEADER_GAP	4
 #define OCFS2_XATTR_FREE_IN_IBODY	(OCFS2_MIN_XATTR_INLINE_SIZE \
 					 - sizeof(struct ocfs2_xattr_header) \
 					 - sizeof(__u32))
@@ -1506,7 +1507,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	/* Compute last entry and free space. */
 	last = &xs->header->xh_entries[le16_to_cpu(xs->header->xh_count)];
 	free = le16_to_cpu(xs->header->xh_free_start) -
-		OCFS2_XATTR_HEADER_SIZE(xs->header) - sizeof(__u32);
+		OCFS2_XATTR_HEADER_SIZE(xs->header) - OCFS2_XATTR_HEADER_GAP;
 	if (free < 0)
 		return -EIO;
 
@@ -2294,7 +2295,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		 */
 		int free = le16_to_cpu(xis->header->xh_free_start) -
 			   OCFS2_XATTR_HEADER_SIZE(xis->header) -
-			   sizeof(__u32);
+			   OCFS2_XATTR_HEADER_GAP;
 		int size = ocfs2_xattr_entry_real_size(strlen(xi->name),
 						       xi->value_len);
 
@@ -5054,8 +5055,8 @@ try_again:
 	count = le16_to_cpu(xh->xh_count);
 	xh_free_start = le16_to_cpu(xh->xh_free_start);
 	header_size = OCFS2_XATTR_HEADER_SIZE(xh);
-	max_free = OCFS2_XATTR_BUCKET_SIZE -
-		le16_to_cpu(xh->xh_name_value_len) - header_size;
+	max_free = OCFS2_XATTR_BUCKET_SIZE - header_size -
+		le16_to_cpu(xh->xh_name_value_len) - OCFS2_XATTR_HEADER_GAP;
 
 	mlog_bug_on_msg(header_size > blocksize, "bucket %llu has header size "
 			"of %u which exceed block size\n",
@@ -5088,7 +5089,7 @@ try_again:
 			need = 0;
 	}
 
-	free = xh_free_start - header_size;
+	free = xh_free_start - header_size - OCFS2_XATTR_HEADER_GAP;
 	/*
 	 * We need to make sure the new name/value pair
 	 * can exist in the same block.
@@ -5121,7 +5122,8 @@ try_again:
 			}
 
 			xh_free_start = le16_to_cpu(xh->xh_free_start);
-			free = xh_free_start - header_size;
+			free = xh_free_start - header_size
+				- OCFS2_XATTR_HEADER_GAP;
 			if (xh_free_start % blocksize < need)
 				free -= xh_free_start % blocksize;
 
-- 
1.5.4.1
