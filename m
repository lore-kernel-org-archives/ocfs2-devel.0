From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 2 Feb 2015 10:59:16 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] tunefs.ocfs2: support append direct io ro
	compat feature
Message-ID: <54CEE804.7020305@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Support turn on/off the feature. This is mostly for the existing ocfs2
volume upgrade.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 tunefs.ocfs2/Makefile             |   3 +-
 tunefs.ocfs2/feature_append_dio.c | 123 ++++++++++++++++++++++++++++++++++++++
 tunefs.ocfs2/op_features.c        |   2 +
 3 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 tunefs.ocfs2/feature_append_dio.c

diff --git a/tunefs.ocfs2/Makefile b/tunefs.ocfs2/Makefile
index 585a68c..62a5e8e 100644
--- a/tunefs.ocfs2/Makefile
+++ b/tunefs.ocfs2/Makefile
@@ -29,7 +29,8 @@ OCFS2NE_FEATURES =			\
 	feature_xattr			\
 	feature_indexed_dirs		\
 	feature_quota			\
-	feature_clusterinfo
+	feature_clusterinfo		\
+	feature_append_dio

 OCFS2NE_OPERATIONS =			\
 	op_cloned_volume		\
diff --git a/tunefs.ocfs2/feature_append_dio.c b/tunefs.ocfs2/feature_append_dio.c
new file mode 100644
index 0000000..791dd64
--- /dev/null
+++ b/tunefs.ocfs2/feature_append_dio.c
@@ -0,0 +1,123 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * feature_append_dio.c
+ *
+ * ocfs2 tune utility for enabling and disabling the append direct
+ * io feature.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <ctype.h>
+#include <inttypes.h>
+#include <assert.h>
+
+#include "ocfs2/ocfs2.h"
+
+#include "libocfs2ne.h"
+
+
+static int enable_append_dio(ocfs2_filesys *fs, int flags)
+{
+	errcode_t ret = 0;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	struct tools_progress *prog;
+
+	if (ocfs2_supports_append_dio(super)) {
+		verbosef(VL_APP,
+			 "Append direct io feature is already enabled; "
+			 "nothing to enable\n");
+		goto out;
+	}
+
+	if (!tools_interact("Enable the append direct io feature on "
+			    "device \"%s\"? ",
+			    fs->fs_devname))
+		goto out;
+
+	prog = tools_progress_start("Enable append direct io", "append-dio", 1);
+	if (!prog) {
+		ret = TUNEFS_ET_NO_MEMORY;
+		tcom_err(ret, "while initializing the progress display");
+		goto out;
+	}
+
+	OCFS2_SET_RO_COMPAT_FEATURE(super,
+				    OCFS2_FEATURE_RO_COMPAT_APPEND_DIO);
+	tunefs_block_signals();
+	ret = ocfs2_write_super(fs);
+	tunefs_unblock_signals();
+	if (ret)
+		tcom_err(ret, "while writing out the superblock");
+
+	tools_progress_step(prog, 1);
+	tools_progress_stop(prog);
+out:
+	return ret;
+}
+
+static int disable_append_dio(ocfs2_filesys *fs, int flags)
+{
+	errcode_t ret = 0;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	struct tools_progress *prog = NULL;
+
+	if (!ocfs2_supports_append_dio(super)) {
+		verbosef(VL_APP,
+			 "Append direct io feature is not enabled; "
+			 "nothing to disable\n");
+		goto out;
+	}
+
+	if (!tools_interact("Disable the append direct io feature on "
+			    "device \"%s\"? ",
+			    fs->fs_devname))
+		goto out;
+
+	prog = tools_progress_start("Disabling append direct io", "noappend-dio", 0);
+	if (!prog) {
+		ret = TUNEFS_ET_NO_MEMORY;
+		tcom_err(ret, "while initializing the progress display");
+		goto out;
+	}
+
+	OCFS2_CLEAR_RO_COMPAT_FEATURE(super,
+				      OCFS2_FEATURE_RO_COMPAT_APPEND_DIO);
+	tunefs_block_signals();
+	ret = ocfs2_write_super(fs);
+	tunefs_unblock_signals();
+	if (ret)
+		tcom_err(ret, "while writing out the superblock");
+
+	tools_progress_step(prog, 1);
+
+out:
+	if (prog)
+		tools_progress_stop(prog);
+	return ret;
+}
+
+DEFINE_TUNEFS_FEATURE_RO_COMPAT(append_dio,
+				OCFS2_FEATURE_RO_COMPAT_APPEND_DIO,
+				TUNEFS_FLAG_RW | TUNEFS_FLAG_ONLINE,
+				enable_append_dio,
+				disable_append_dio);
+
+#ifdef DEBUG_EXE
+int main(int argc, char *argv[])
+{
+	return tunefs_feature_main(argc, argv, &append_dio_feature);
+}
+#endif
diff --git a/tunefs.ocfs2/op_features.c b/tunefs.ocfs2/op_features.c
index 20b65a5..b6235aa 100644
--- a/tunefs.ocfs2/op_features.c
+++ b/tunefs.ocfs2/op_features.c
@@ -47,6 +47,7 @@ extern struct tunefs_feature refcount_feature;
 extern struct tunefs_feature indexed_dirs_feature;
 extern struct tunefs_feature discontig_bg_feature;
 extern struct tunefs_feature clusterinfo_feature;
+extern struct tunefs_feature append_dio_feature;

 /* List of features supported by ocfs2ne */
 static struct tunefs_feature *features[] = {
@@ -64,6 +65,7 @@ static struct tunefs_feature *features[] = {
 	&indexed_dirs_feature,
 	&discontig_bg_feature,
 	&clusterinfo_feature,
+	&append_dio_feature,
 	NULL,
 };

-- 
1.8.4.3
