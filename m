From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar  5 17:14:30 2008
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Add the user stack module.
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1204766038-31721-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Add a skeleton for the stack_user module.  It's just the barebones module
code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stack_user.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 fs/ocfs2/stack_user.c

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
new file mode 100644
index 0000000..920eb11
--- /dev/null
+++ b/fs/ocfs2/stack_user.c
@@ -0,0 +1,38 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * stack_user.c
+ *
+ * Code which interfaces ocfs2 with fs/dlm and a userspace stack.
+ *
+ * Copyright (C) 2007 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+
+#include "stackglue.h"
+
+
+static int __init user_stack_init(void)
+{
+	return 0;
+}
+
+static void __exit user_stack_exit(void)
+{
+}
+
+MODULE_AUTHOR("Oracle");
+MODULE_DESCRIPTION("ocfs2 driver for userspace cluster stacks");
+MODULE_LICENSE("GPL");
+module_init(user_stack_init);
+module_exit(user_stack_exit);
-- 
1.5.3.8
