From: Subrata Modak <subrata@linux.vnet.ibm.com>
Date: Mon, 13 Jul 2009 19:49:50 -0000
Subject: [Ocfs2-devel] [PATCH] Fix compilation warning for fs/ocfs2/xattr.c
Message-ID: <20090713194928.32372.56679.sendpatchset@subratamodak.linux.ibm.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Subrata Modak <subrata@linux.vnet.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>

Hi,

gcc 4.4.1 generates the following build warning on i386:

CC [M]  fs/ocfs2/xattr.o
fs/ocfs2/xattr.c: In function ???ocfs2_xattr_block_get???:
fs/ocfs2/xattr.c:1055: warning: ???block_off??? may be used uninitialized in this function

The following fix is based on a similar approach by David Howells
few days back: http://lkml.org/lkml/2009/7/9/109,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/fs/ocfs2/xattr.c	2009-06-17 17:47:21.000000000 +0530
+++ b/fs/ocfs2/xattr.c	2009-07-14 01:02:22.000000000 +0530
@@ -1052,7 +1052,8 @@ static int ocfs2_xattr_block_get(struct 
 	struct ocfs2_xattr_block *xb;
 	struct ocfs2_xattr_value_root *xv;
 	size_t size;
-	int ret = -ENODATA, name_offset, name_len, block_off, i;
+	int ret = -ENODATA, name_offset, name_len, i;
+	int uninitialized_var(block_off);
 
 	xs->bucket = ocfs2_xattr_bucket_new(inode);
 	if (!xs->bucket) {

---
Regards--
Subrata
