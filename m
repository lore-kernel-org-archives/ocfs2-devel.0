From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 20 Oct 2008 09:24:52 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Add POSIX ACLs support
 in ocfs2
In-Reply-To: <20081018045523.GB32061@ca-server1.us.oracle.com>
References: <48F6F0A3.5060909@oracle.com>
	<1224143394-30970-1-git-send-email-tiger.yang@oracle.com>
	<20081016082042.GA22345@ca-server1.us.oracle.com>
	<48F75323.4050706@oracle.com>
	<20081018045523.GB32061@ca-server1.us.oracle.com>
Message-ID: <48FBDDE4.9080302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes. I can and I already did in the first patch of my v3 patches of acl.

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 57b51fc..fa154d3 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3,25 +3,20 @@
   *
   * xattr.c
   *
- * Copyright (C) 2008 Oracle.  All rights reserved.
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
   *
   * CREDITS:
- * Lots of code in this file is taken from ext3.
+ * Lots of code in this file is copy from linux/fs/ext3/xattr.c.
+ * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
   *
   * This program is free software; you can redistribute it and/or
   * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
+ * License version 2 as published by the Free Software Foundation.
   *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
   */

is this ok?

regards,
tiger

Joel Becker wrote:
> On Thu, Oct 16, 2008 at 10:43:47PM +0800, Tao Ma wrote:
>> hi tiger, you can use this new license. 
>> http://kernel.us.oracle.com/~smushran/license.txt
> 
> 	Can you fix the license in xattr.c too?  And the copyrights from
> there should go in your CREDITS section if you really did copy code.
> 
> Joel
> 
