From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 26 May 2011 17:57:42 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Get dinode buffer head on hard
	readonly mount
In-Reply-To: <4DDE2000.3000301@oracle.com>
References: <4DDE2000.3000301@oracle.com>
Message-ID: <1306403862-15299-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_statfs, ocfs2_fiemap, ocfs2_get_acl, ocfs2_listxattr and
ocfs2_xattr_get need ocfs2_inode_lock to get dinode buffer head
even on hard readonly mount.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/dlmglue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 09e8b30..717f8d3 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2304,7 +2304,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	if (ocfs2_is_hard_readonly(osb)) {
 		if (ex)
 			status = -EROFS;
-		goto bail;
+		goto getbh;
 	}
 
 	if (ocfs2_mount_local(osb))
@@ -2362,7 +2362,7 @@ local:
 			mlog_errno(status);
 		goto bail;
 	}
-
+getbh:
 	if (ret_bh) {
 		status = ocfs2_assign_bh(inode, ret_bh, local_bh);
 		if (status < 0) {
-- 
1.7.4.4
