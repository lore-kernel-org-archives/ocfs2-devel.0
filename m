From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:34 -0800
Subject: [Ocfs2-devel] [PATCH 15/45] ocfs2/xattr: Only set buffer update if
	it doesn't exist in cache.
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-16-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

When we call ocfs2_init_xattr_bucket, we deem that the new buffer head
will be written to disk immediately, so we just use sb_getblk. But in
some cases the buffer may have already been in ocfs2 uptodate cache,
so we only call ocfs2_set_buffer_uptodate if the buffer head isn't
in the cache.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 87cf39d..d8fc714 100644
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
1.5.6
