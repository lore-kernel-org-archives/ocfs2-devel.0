From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 23 Oct 2008 16:33:03 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: fix license in xattr
In-Reply-To: <49003524.3090405@oracle.com>
References: <49003524.3090405@oracle.com>
Message-ID: <1224750783-10880-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fix license in xattr.c and xattr.h.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   13 ++++---------
 fs/ocfs2/xattr.h |   12 ++----------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0239078..baa4825 100644
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
 
 #include <linux/capability.h>
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index c25c7c6..e4e45c8 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -3,24 +3,16 @@
  *
  * xattr.h
  *
- * Function prototypes
- *
- * Copyright (C) 2008 Oracle.  All rights reserved.
+ * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
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
 
 #ifndef OCFS2_XATTR_H
-- 
1.5.4.1
