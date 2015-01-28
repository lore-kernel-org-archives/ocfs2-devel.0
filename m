From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:03 -0800
Subject: [Ocfs2-devel] [PATCH 1/6] Get cluster list info from corosync
In-Reply-To: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
References: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
Message-ID: <1422483128-32471-2-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

Instead of getting the cluster list from controld, we get the list
directly from Corosync's cmap.

This introduces a new config flag BUILD_CMAP_SUPPORT, which
translates to HAVE_CMAP defines for libo2cb.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 Config.make.in         |  1 +
 configure.in           | 19 +++++++++++++++++++
 debugfs.ocfs2/Makefile |  3 +++
 fsck.ocfs2/Makefile    |  3 +++
 libo2cb/Makefile       |  5 +++++
 libo2cb/o2cb_abi.c     | 28 ++++++++++++++++++++++++++++
 mkfs.ocfs2/Makefile    |  3 +++
 mount.ocfs2/Makefile   |  3 +++
 mounted.ocfs2/Makefile |  3 +++
 o2cb_ctl/Makefile      |  3 +++
 ocfs2_hb_ctl/Makefile  |  3 +++
 tunefs.ocfs2/Makefile  |  3 +++
 12 files changed, 77 insertions(+)

diff --git a/Config.make.in b/Config.make.in
index bf7c6fd..583a243 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -81,6 +81,7 @@ HAVE_COROSYNC = @HAVE_COROSYNC@
 BUILD_OCFS2_CONTROLD = @BUILD_OCFS2_CONTROLD@
 BUILD_PCMK_SUPPORT = @BUILD_PCMK_SUPPORT@
 BUILD_CMAN_SUPPORT = @BUILD_CMAN_SUPPORT@
+BUILD_CMAP_SUPPORT = @BUILD_CMAP_SUPPORT@
 BUILD_FSDLM_SUPPORT = @BUILD_FSDLM_SUPPORT@
 CPG_LDFLAGS = @CPG_LDFLAGS@
 AIS_LDFLAGS = @AIS_LDFLAGS@
diff --git a/configure.in b/configure.in
index 2ac25c1..de44013 100644
--- a/configure.in
+++ b/configure.in
@@ -382,6 +382,25 @@ if test "x$cpg_found" = "xyes" -a "x$ckpt_found" = "xyes" -a "x$libdlmcontrol_fo
 fi
 AC_SUBST(BUILD_OCFS2_CONTROLD)
 
+LIBCMAP_FOUND=
+AC_CHECK_HEADER(corosync/cmap.h, LIBCMAP_FOUND=yes,
+  [AC_MSG_WARN([corosync/cmap.h not found, cmap support will not be built. Older api will be used])])
+AC_SUBST(LIBCMAP_FOUND)
+
+fsdlm_found=
+if test "x$LIBCMAP_FOUND" = "xyes"; then
+  AC_CHECK_LIB(cmap, cmap_initialize, cmap_found=yes)
+  if test "x$cmap_found" = "xyes"; then
+    AC_MSG_WARN([libcmap not found, cmap support will not be built. Older api will be used])
+  fi
+fi
+
+BUILD_CMAP_SUPPORT=
+if test "x$cmap_found" = "xyes"; then
+  BUILD_CMAP_SUPPORT=yes
+fi
+AC_SUBST(BUILD_CMAP_SUPPORT)
+
 BUILD_PCMK_SUPPORT=
 if test "x$pcmk_found" = "xyes" -a "x$BUILD_OCFS2_CONTROLD" = "xyes"; then
   BUILD_PCMK_SUPPORT=yes
diff --git a/debugfs.ocfs2/Makefile b/debugfs.ocfs2/Makefile
index ca4c9a4..ff00e69 100644
--- a/debugfs.ocfs2/Makefile
+++ b/debugfs.ocfs2/Makefile
@@ -33,6 +33,9 @@ OBJS = $(subst .c,.o,$(CFILES))
 
 LIBOCFS2_LIBS = -L$(TOPDIR)/libocfs2 -locfs2
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 
 MANS = debugfs.ocfs2.8
 
diff --git a/fsck.ocfs2/Makefile b/fsck.ocfs2/Makefile
index edc8dc5..c49940e 100644
--- a/fsck.ocfs2/Makefile
+++ b/fsck.ocfs2/Makefile
@@ -13,6 +13,9 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 LIBTOOLS_INTERNAL_LIBS = -L$(TOPDIR)/libtools-internal -ltools-internal
 LIBTOOLS_INTERNAL_DEPS = $(TOPDIR)/libtools-internal/libtools-internal.a
diff --git a/libo2cb/Makefile b/libo2cb/Makefile
index 7728bb3..0ae177b 100644
--- a/libo2cb/Makefile
+++ b/libo2cb/Makefile
@@ -11,6 +11,11 @@ LIBRARIES = libo2cb.a
 
 CFLAGS += -fPIC
 
+ifneq ($(BUILD_CMAP_SUPPORT),)
+DEFINES += -DHAVE_CMAP
+endif
+
+
 ifneq ($(OCFS2_DEBUG_EXE),)
 DEBUG_EXE_FILES = $(shell awk '/DEBUG_EXE/{if (k[FILENAME] == 0) {print FILENAME; k[FILENAME] = 1;}}' $(CFILES))
 DEBUG_EXE_PROGRAMS = $(addprefix debug_,$(subst .c,,$(DEBUG_EXE_FILES)))
diff --git a/libo2cb/o2cb_abi.c b/libo2cb/o2cb_abi.c
index cc50689..2d86c8e 100644
--- a/libo2cb/o2cb_abi.c
+++ b/libo2cb/o2cb_abi.c
@@ -37,6 +37,9 @@
 #include <ctype.h>
 
 #include <linux/types.h>
+#ifdef HAVE_CMAP
+#include <corosync/cmap.h>
+#endif
 
 #include "o2cb/o2cb.h"
 #include "o2cb/o2cb_client_proto.h"
@@ -1962,6 +1965,30 @@ static errcode_t classic_list_clusters(char ***clusters)
 	return o2cb_list_dir(path, clusters);
 }
 
+#ifdef HAVE_CMAP
+static errcode_t user_list_clusters(char ***clusters)
+{
+	cmap_handle_t handle;
+	char **list;
+	int rv;
+
+	rv = cmap_initialize(&handle);
+	if (rv != CS_OK)
+		return O2CB_ET_SERVICE_UNAVAILABLE;
+
+	/* We supply only one cluster_name */
+	list = (char **)malloc(sizeof(char *) * 2);
+	rv = cmap_get_string(handle, "totem.cluster_name", &list[0]);
+	if (rv != CS_OK) {
+		free(list);
+		return O2CB_ET_INTERNAL_FAILURE;
+	}
+
+	list[1] = NULL;
+	*clusters = list;
+	return 0;
+}
+#else
 static errcode_t user_list_clusters(char ***clusters)
 {
 	errcode_t err = O2CB_ET_SERVICE_UNAVAILABLE;
@@ -2011,6 +2038,7 @@ out:
 
 	return err;
 }
+#endif
 
 errcode_t o2cb_list_clusters(char ***clusters)
 {
diff --git a/mkfs.ocfs2/Makefile b/mkfs.ocfs2/Makefile
index 5631e01..ee246db 100644
--- a/mkfs.ocfs2/Makefile
+++ b/mkfs.ocfs2/Makefile
@@ -10,6 +10,9 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
diff --git a/mount.ocfs2/Makefile b/mount.ocfs2/Makefile
index cf316bf..3715120 100644
--- a/mount.ocfs2/Makefile
+++ b/mount.ocfs2/Makefile
@@ -11,6 +11,9 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 DEFINES = -DVERSION=\"$(VERSION)\"
diff --git a/mounted.ocfs2/Makefile b/mounted.ocfs2/Makefile
index 8a574fb..21f3824 100644
--- a/mounted.ocfs2/Makefile
+++ b/mounted.ocfs2/Makefile
@@ -9,6 +9,9 @@ LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 LIBTOOLS_INTERNAL_LIBS = -L$(TOPDIR)/libtools-internal -ltools-internal
diff --git a/o2cb_ctl/Makefile b/o2cb_ctl/Makefile
index 5efcab4..76ddef8 100644
--- a/o2cb_ctl/Makefile
+++ b/o2cb_ctl/Makefile
@@ -14,6 +14,9 @@ LIBOCFS2_LIBS = -L$(TOPDIR)/libocfs2 -locfs2
 LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 
 LIBO2CB_LIBS  = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
diff --git a/ocfs2_hb_ctl/Makefile b/ocfs2_hb_ctl/Makefile
index 10fd8b1..7049c11 100644
--- a/ocfs2_hb_ctl/Makefile
+++ b/ocfs2_hb_ctl/Makefile
@@ -11,6 +11,9 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 ifndef OCFS2_DYNAMIC_CTL
diff --git a/tunefs.ocfs2/Makefile b/tunefs.ocfs2/Makefile
index 585a68c..35564e5 100644
--- a/tunefs.ocfs2/Makefile
+++ b/tunefs.ocfs2/Makefile
@@ -12,6 +12,9 @@ LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_CMAP_SUPPORT),)
+LIBO2CB_LIBS += -lcmap
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 UNINST_LIBRARIES = libocfs2ne.a
-- 
2.1.2
