From: wangang wang <wen.gang.wang@oracle.com>
Date: Mon, 22 Sep 2008 17:15:01 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add spin lock when accessing
	inode->i_nlink.
Message-ID: <200809220915.m8M9F1CR004450@wengang.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

add spin lock when accessing inode->i_nlink in ocfs2_drop_inode().

the patch is against 1.2 svn.

Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
--
Index: fs/ocfs2/inode.c
===================================================================
--- fs/ocfs2/inode.c	(revision 3101)
+++ fs/ocfs2/inode.c	(working copy)
@@ -991,10 +991,12 @@
 	/* Testing ip_orphaned_slot here wouldn't work because we may
 	 * not have gotten a delete_inode vote from any other nodes
 	 * yet. */
+	spin_lock(&oi->ip_lock);
 	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED) {
 		mlog(0, "Inode was orphaned on another node, clearing nlink.\n");
 		inode->i_nlink = 0;
 	}
+	spin_unlock(&oi->ip_lock);
 
 	generic_drop_inode(inode);
 
