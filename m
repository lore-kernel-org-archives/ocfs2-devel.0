From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:16 -0800
Subject: [Ocfs2-devel] [PATCH 2/9] ocfs2: Add missing copyright in few files
In-Reply-To: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
References: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1330630463-30305-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/mmap.h         |   18 ++++++++++++++++++
 fs/ocfs2/ocfs2_trace.h  |   19 +++++++++++++++++++
 fs/ocfs2/quota.h        |   16 ++++++++++++++--
 fs/ocfs2/quota_global.c |   20 ++++++++++++++++++--
 fs/ocfs2/quota_local.c  |   19 +++++++++++++++++--
 5 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/mmap.h b/fs/ocfs2/mmap.h
index 1274ee0..63ca43e 100644
--- a/fs/ocfs2/mmap.h
+++ b/fs/ocfs2/mmap.h
@@ -1,3 +1,21 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * mmap.h
+ *
+ * Copyright (C) 2004, 2011 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ * Copyright (C) 2004, 2011 Oracle.  All rights reserved.
+ */
+
 #ifndef OCFS2_MMAP_H
 #define OCFS2_MMAP_H
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 3b481f4..6f3f5b4 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1,3 +1,22 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * ocfs2_trace.h
+ *
+ * Trace event macros
+ *
+ * Copyright (C) 2010, 2011 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ocfs2
 
diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index d5ab56c..36ef1e2 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -1,9 +1,21 @@
-/*
- * quota.h for OCFS2
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * quota.h
  *
  * On disk quota structures for local and global quota file, in-memory
  * structures.
  *
+ * Copyright (C) 2008, 2011 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
  */
 
 #ifndef _OCFS2_QUOTA_H
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 92fcd57..b24eab3 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -1,6 +1,22 @@
-/*
- *  Implementation of operations over global quota file
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * quota_global.c
+ *
+ * Implementation of operations over global quota file
+ *
+ * Copyright (C) 2008, 2011 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
  */
+
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f100bf7..eeb9c0c 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1,5 +1,20 @@
-/*
- *  Implementation of operations over local quota file
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * quota_local.c
+ *
+ * Implementation of operations over local quota file
+ *
+ * Copyright (C) 2008, 2011 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
  */
 
 #include <linux/fs.h>
-- 
1.7.7.6
