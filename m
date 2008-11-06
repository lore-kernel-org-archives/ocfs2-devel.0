From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  6 Nov 2008 08:10:48 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/xattr: Only set buffer update if it
	doesn't exist in cache.
In-Reply-To: <49129D87.5040600@oracle.com>
References: <49129D87.5040600@oracle.com>
Message-ID: <1225930248-16502-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we call ocfs2_init_xattr_bucket, we deem that the new buffer head
will be written to disk immediately, so we just use sb_getblk. But in
some cases the buffer may have already been in ocfs2 uptodate cache,
so we only call ocfs2_set_buffer_uptodate if the buffer head isn't
in the cache.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 501c9e7..5244c5d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -219,8 +219,10 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 			break;
 		}
 
-		ocfs2_set_new_buffer_uptodate(bucket->bu_inode,
-					      bucket->bu_bhs[i]);
+		if (!ocfs2_buffer_uptodate(bucket->bu_inode,
+					   bucket->bu_bhs[i]))
+			ocfs2_set_new_buffer_uptodate(bucket->bu_inode,
+						      bucket->bu_bhs[i]);
 	}
 
 	if (rc)
-- 
1.5.4.GIT
