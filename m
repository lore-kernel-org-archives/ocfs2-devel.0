From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue,  9 Feb 2010 14:57:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a refcount condition checking -v2
Message-ID: <201002090658.o195naM8009406@rcsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We disable DIO write if the inode has reflink. The way to determine if the inode
has reflink is wrong in case (!has_refcount && direct_io). The patch fixes it.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 file.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 06ccf6a..c9e4c51 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1836,6 +1836,8 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 							       &meta_level);
 			if (has_refcount)
 				*has_refcount = 1;
+			if (direct_io)
+				*direct_io = 0;
 		}
 
 		if (ret < 0) {
@@ -1859,10 +1861,6 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
 			break;
 		}
 
-		if (has_refcount && *has_refcount == 1) {
-			*direct_io = 0;
-			break;
-		}
 		/*
 		 * Allowing concurrent direct writes means
 		 * i_size changes wouldn't be synchronized, so
