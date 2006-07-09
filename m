From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 10 Jul 2006 01:32:51 +0200
Subject: [Ocfs2-devel] [-mm patch] fs/ocfs2/ioctl.c should #include "ioctl.h"
In-Reply-To: <20060709021106.9310d4d1.akpm@osdl.org>
References: <20060709021106.9310d4d1.akpm@osdl.org>
Message-ID: <20060709233251.GW13938@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@osdl.org>, mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sun, Jul 09, 2006 at 02:11:06AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.17-mm6:
>...
>  git-ocfs2.patch
>...
>  git trees
>...

Every file should #include the headers containing the prototypes for its 
global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc1-mm1-full/fs/ocfs2/ioctl.c.old	2006-07-09 20:04:41.000000000 +0200
+++ linux-2.6.18-rc1-mm1-full/fs/ocfs2/ioctl.c	2006-07-09 20:07:00.000000000 +0200
@@ -18,6 +18,8 @@
 #include "journal.h"
 
 #include "ocfs2_fs.h"
+#include "ioctl.h"
+
 #include <linux/ext2_fs.h>
 
 static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
