From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 17 Dec 2009 18:42:16 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Should ocfs2 support fiemap for
	S_IFDIR inode?
Message-ID: <1261046536-4502-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Let userspace have a chance to get the extent info of a
directory just like extN did.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f010b22..0b9f35e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2326,4 +2326,5 @@ const struct inode_operations ocfs2_dir_iops = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= ocfs2_listxattr,
 	.removexattr	= generic_removexattr,
+	.fiemap         = ocfs2_fiemap,
 };
-- 
1.6.5.2
