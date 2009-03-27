From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri, 27 Mar 2009 15:06:56 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: 64-bit inode number for getattr()
	instead of 32-bit value
Message-ID: <200903270708.n2R78IMi021731@acsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_getattr() uses generic_fillattr() to set inode number(and other
attributes). generic_fillattr() inturn fills inode number with inode->i_ino
which is a 32-bit(unsigned long) value.

if the ocfs2 partition is huge enough, that may become an incorrect
value.
the fix is filling it again after generic_fillattr() with ip_blkno(u64).

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a5887df..ffe7d34 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1076,6 +1076,8 @@ int ocfs2_getattr(struct vfsmount *mnt,
 	/* We set the blksize from the cluster size for performance */
 	stat->blksize = osb->s_clustersize;
 
+	stat->ino = OCFS2_I(inode)->ip_blkno;
+
 bail:
 	mlog_exit(err);
 
