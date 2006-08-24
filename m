From: GONG Jie <jie.gong@oracle.com>
Date: Thu Aug 24 00:05:44 2006
Subject: [Ocfs2-devel] debugfs.ocfs2 usage message fix
Message-ID: <200608241511.10028.jie.gong@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

The help message in debufs.ocfs2 is not consist among ``extent'', 
``findpath'', ``locate'', ``ncheck'' and ``help''.

``help'' show that extent accept a block number as its argument.
---8<---
extent <block#>                         Show extent block
---8<---

But ``extent'' says its argument is an inode number.
---8<---
debugfs: extent
usage: extent <inode#>
---8<---

It is confused.  So I change function process_inodestr_args() to fix that.

---8<---
Index: debugfs.ocfs2/commands.c
===================================================================
--- debugfs.ocfs2/commands.c	(revision 1225)
+++ debugfs.ocfs2/commands.c	(working copy)
@@ -285,7 +285,7 @@ static int process_inodestr_args(char **
 	--i;
 
 	if (!i) {
-		fprintf(stderr, "usage: %s <inode#>\n", args[0]);
+		fprintf(stderr, "usage: %s <block#>\n", args[0]);
 		return -1;
 	}
 
---8<---

-- 
Regards,

GONG Jie
Linux Engineering, Emerging Technology & Solution Development
Oracle Software Research and Development Center
Tel:    +86-10-82786289
Mobile: +86-13011102030
Email:  jie.gong@oracle.com
