From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 11 Feb 2009 10:38:34 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: set gap to seperate entry and
	value when xattr in bucket
In-Reply-To: <499238F3.9010208@oracle.com>
References: <499238F3.9010208@oracle.com>
Message-ID: <1234319914-7040-1-git-send-email-tiger.yang@oracle.com>
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
 fs/ocfs2/xattr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ce793af..60b5ca3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5024,8 +5024,8 @@ try_again:
 	count = le16_to_cpu(xh->xh_count);
 	xh_free_start = le16_to_cpu(xh->xh_free_start);
 	header_size = OCFS2_XATTR_HEADER_SIZE(xh);
-	max_free = OCFS2_XATTR_BUCKET_SIZE -
-		le16_to_cpu(xh->xh_name_value_len) - header_size;
+	max_free = OCFS2_XATTR_BUCKET_SIZE - header_size -
+		le16_to_cpu(xh->xh_name_value_len) - sizeof(__u32);
 
 	mlog_bug_on_msg(header_size > blocksize, "bucket %llu has header size "
 			"of %u which exceed block size\n",
@@ -5058,7 +5058,7 @@ try_again:
 			need = 0;
 	}
 
-	free = xh_free_start - header_size;
+	free = xh_free_start - header_size - sizeof(__u32);
 	/*
 	 * We need to make sure the new name/value pair
 	 * can exist in the same block.
@@ -5091,7 +5091,7 @@ try_again:
 			}
 
 			xh_free_start = le16_to_cpu(xh->xh_free_start);
-			free = xh_free_start - header_size;
+			free = xh_free_start - header_size - sizeof(__u32);
 			if (xh_free_start % blocksize < need)
 				free -= xh_free_start % blocksize;
 
-- 
1.5.4.1
