From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:04 -0800
Subject: [Ocfs2-devel] [PATCH 2/6] Don't use controld if kernel supports DLM
	callbacks
In-Reply-To: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
References: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
Message-ID: <1422483128-32471-3-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

This requires dlm_lt libraries and they have been added wherever
required.

Note, we can possibly remove runtime load of dlm_lt and should use
compile time options. We are detecting the presence of libdlm during
compile time anyways.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 debugfs.ocfs2/Makefile               |  3 +++
 fsck.ocfs2/Makefile                  |  5 ++++-
 fswreck/Makefile                     |  4 ++++
 libo2cb/Makefile                     |  3 +++
 libo2cb/o2cb_abi.c                   | 38 ++++++++++++++++++++++++++++++++++++
 libocfs2/Makefile                    |  4 ++++
 listuuid/Makefile                    |  4 ++++
 mkfs.ocfs2/Makefile                  |  3 +++
 mount.ocfs2/Makefile                 |  5 ++++-
 mounted.ocfs2/Makefile               |  5 ++++-
 o2cb_ctl/Makefile                    |  7 +++++--
 o2image/Makefile                     |  4 ++++
 ocfs2_controld/Makefile              |  2 +-
 ocfs2_hb_ctl/Makefile                |  5 ++++-
 ocfs2cdsl/Makefile                   |  4 ++++
 ocfs2console/ocfs2interface/Makefile |  4 ++++
 tunefs.ocfs2/Makefile                |  5 ++++-
 17 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/debugfs.ocfs2/Makefile b/debugfs.ocfs2/Makefile
index ff00e69..3db7b60 100644
--- a/debugfs.ocfs2/Makefile
+++ b/debugfs.ocfs2/Makefile
@@ -33,6 +33,9 @@ OBJS = $(subst .c,.o,$(CFILES))
 
 LIBOCFS2_LIBS = -L$(TOPDIR)/libocfs2 -locfs2
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
diff --git a/fsck.ocfs2/Makefile b/fsck.ocfs2/Makefile
index c49940e..051ed74 100644
--- a/fsck.ocfs2/Makefile
+++ b/fsck.ocfs2/Makefile
@@ -13,10 +13,13 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
-LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 LIBTOOLS_INTERNAL_LIBS = -L$(TOPDIR)/libtools-internal -ltools-internal
 LIBTOOLS_INTERNAL_DEPS = $(TOPDIR)/libtools-internal/libtools-internal.a
 
diff --git a/fswreck/Makefile b/fswreck/Makefile
index ffbd6ea..9856e0d 100644
--- a/fswreck/Makefile
+++ b/fswreck/Makefile
@@ -41,7 +41,11 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
+else
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 dist-subdircreate:
diff --git a/libo2cb/Makefile b/libo2cb/Makefile
index 0ae177b..5f12b07 100644
--- a/libo2cb/Makefile
+++ b/libo2cb/Makefile
@@ -15,6 +15,9 @@ ifneq ($(BUILD_CMAP_SUPPORT),)
 DEFINES += -DHAVE_CMAP
 endif
 
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+DEFINES += -DHAVE_FSDLM
+endif
 
 ifneq ($(OCFS2_DEBUG_EXE),)
 DEBUG_EXE_FILES = $(shell awk '/DEBUG_EXE/{if (k[FILENAME] == 0) {print FILENAME; k[FILENAME] = 1;}}' $(CFILES))
diff --git a/libo2cb/o2cb_abi.c b/libo2cb/o2cb_abi.c
index 2d86c8e..2867fea 100644
--- a/libo2cb/o2cb_abi.c
+++ b/libo2cb/o2cb_abi.c
@@ -40,6 +40,9 @@
 #ifdef HAVE_CMAP
 #include <corosync/cmap.h>
 #endif
+#ifdef HAVE_FSDLM
+#include <libdlm.h>
+#endif
 
 #include "o2cb/o2cb.h"
 #include "o2cb/o2cb_client_proto.h"
@@ -50,6 +53,7 @@
 #define LOCKING_PROTOCOL_FILE	"/sys/fs/ocfs2/max_locking_protocol"
 #define OCFS2_STACK_LABEL_LEN	4
 #define CONTROL_DEVICE		"/dev/misc/ocfs2_control"
+#define DLM_RECOVER_CALLBACK   "/sys/fs/ocfs2/dlm_recover_callback_support"
 
 static errcode_t o2cb_validate_cluster_name(struct o2cb_cluster_desc *desc);
 static errcode_t o2cb_validate_cluster_flags(struct o2cb_cluster_desc *desc,
@@ -1384,6 +1388,26 @@ static errcode_t user_begin_group_join(struct o2cb_cluster_desc *cluster,
 	char *argv[OCFS2_CONTROLD_MAXARGS + 1];
 	char buf[OCFS2_CONTROLD_MAXLINE];
 
+#ifdef HAVE_FSDLM
+	uint32_t maj, min, pat;
+
+	if (strncmp(cluster->c_stack, OCFS2_PCMK_CLUSTER_STACK, OCFS2_STACK_LABEL_LEN))
+			goto no_pcmk;
+
+	rc = dlm_kernel_version(&maj, &min, &pat);
+
+	if (rc < 0)
+		return O2CB_ET_SERVICE_UNAVAILABLE;
+
+	if (read_single_line_file(DLM_RECOVER_CALLBACK, buf, 3) > 0) {
+		/* Controld is not required */
+		if (maj < 6)
+			return O2CB_ET_INTERNAL_FAILURE;
+		return 0;
+	}
+no_pcmk:
+#endif
+
 	if (control_daemon_fd != -1) {
 		/* fprintf(stderr, "Join already in progress!\n"); */
 		err = O2CB_ET_INTERNAL_FAILURE;
@@ -1475,6 +1499,13 @@ static errcode_t user_complete_group_join(struct o2cb_cluster_desc *cluster,
 	char *argv[OCFS2_CONTROLD_MAXARGS + 1];
 	char buf[OCFS2_CONTROLD_MAXLINE];
 
+#ifdef HAVE_FSDLM
+	if (read_single_line_file(DLM_RECOVER_CALLBACK, buf, 3) > 0) {
+		/* Controld is not required */
+		return 0;
+	}
+#endif
+
 	if (control_daemon_fd == -1) {
 		/* fprintf(stderr, "Join not started!\n"); */
 		err = O2CB_ET_SERVICE_UNAVAILABLE;
@@ -1545,6 +1576,13 @@ static errcode_t user_group_leave(struct o2cb_cluster_desc *cluster,
 	char *argv[OCFS2_CONTROLD_MAXARGS + 1];
 	char buf[OCFS2_CONTROLD_MAXLINE];
 
+#ifdef HAVE_FSDLM
+	if (read_single_line_file(DLM_RECOVER_CALLBACK, buf, 3) > 0) {
+		/* Controld is not required */
+		return 0;
+	}
+#endif
+
 	if (control_daemon_fd != -1) {
 		/* fprintf(stderr, "Join in progress!\n"); */
 		err = O2CB_ET_INTERNAL_FAILURE;
diff --git a/libocfs2/Makefile b/libocfs2/Makefile
index a4027c2..9ed420a 100644
--- a/libocfs2/Makefile
+++ b/libocfs2/Makefile
@@ -9,7 +9,11 @@ LIBRARIES = libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
+else
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 CFLAGS += -fPIC
diff --git a/listuuid/Makefile b/listuuid/Makefile
index 7f03b9c..2859724 100644
--- a/listuuid/Makefile
+++ b/listuuid/Makefile
@@ -10,7 +10,11 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
+else
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 UNINST_PROGRAMS = listuuid
diff --git a/mkfs.ocfs2/Makefile b/mkfs.ocfs2/Makefile
index ee246db..604c522 100644
--- a/mkfs.ocfs2/Makefile
+++ b/mkfs.ocfs2/Makefile
@@ -13,6 +13,9 @@ LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
diff --git a/mount.ocfs2/Makefile b/mount.ocfs2/Makefile
index 3715120..73c3df8 100644
--- a/mount.ocfs2/Makefile
+++ b/mount.ocfs2/Makefile
@@ -11,10 +11,13 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
-LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 DEFINES = -DVERSION=\"$(VERSION)\"
 
diff --git a/mounted.ocfs2/Makefile b/mounted.ocfs2/Makefile
index 21f3824..a36ab29 100644
--- a/mounted.ocfs2/Makefile
+++ b/mounted.ocfs2/Makefile
@@ -9,10 +9,13 @@ LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
-LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 LIBTOOLS_INTERNAL_LIBS = -L$(TOPDIR)/libtools-internal -ltools-internal
 LIBTOOLS_INTERNAL_DEPS = $(TOPDIR)/libtools-internal/libtools-internal.a
diff --git a/o2cb_ctl/Makefile b/o2cb_ctl/Makefile
index 76ddef8..21d25b9 100644
--- a/o2cb_ctl/Makefile
+++ b/o2cb_ctl/Makefile
@@ -13,11 +13,14 @@ LIBTOOLS_INTERNAL_DEPS = $(TOPDIR)/libtools-internal/libtools-internal.a
 LIBOCFS2_LIBS = -L$(TOPDIR)/libocfs2 -locfs2
 LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 
-LIBO2CB_LIBS  = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
-LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
diff --git a/o2image/Makefile b/o2image/Makefile
index b0d9511..3bc1b58 100644
--- a/o2image/Makefile
+++ b/o2image/Makefile
@@ -13,7 +13,11 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
+else
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 sbindir = $(root_sbindir)
diff --git a/ocfs2_controld/Makefile b/ocfs2_controld/Makefile
index f6ac203..ef842d4 100644
--- a/ocfs2_controld/Makefile
+++ b/ocfs2_controld/Makefile
@@ -18,7 +18,7 @@ PCMK_INCLUDES = -I/usr/include/pacemaker -I/usr/include/heartbeat/ $(GLIB_CFLAGS
 endif
 
 INCLUDES = -I$(TOPDIR)/include -I. $(PCMK_INCLUDES)
-LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 LIBOCFS2_LIBS = -L$(TOPDIR)/libocfs2 -locfs2
 LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
diff --git a/ocfs2_hb_ctl/Makefile b/ocfs2_hb_ctl/Makefile
index 7049c11..b4d0490 100644
--- a/ocfs2_hb_ctl/Makefile
+++ b/ocfs2_hb_ctl/Makefile
@@ -11,10 +11,13 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
-LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 ifndef OCFS2_DYNAMIC_CTL
 LDFLAGS += -static
diff --git a/ocfs2cdsl/Makefile b/ocfs2cdsl/Makefile
index 391b553..f07bfaa 100644
--- a/ocfs2cdsl/Makefile
+++ b/ocfs2cdsl/Makefile
@@ -9,7 +9,11 @@ LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
+else
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+endif
 
 sbindir = $(root_sbindir)
 SBIN_PROGRAMS = ocfs2cdsl
diff --git a/ocfs2console/ocfs2interface/Makefile b/ocfs2console/ocfs2interface/Makefile
index 63fb56f..5409455 100644
--- a/ocfs2console/ocfs2interface/Makefile
+++ b/ocfs2console/ocfs2interface/Makefile
@@ -14,7 +14,11 @@ LIBOCFS2_DEPS = $(TOPDIR)/libocfs2/libocfs2.a
 LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb -ldlm_lt
+else
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+endif
 LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 ifdef HAVE_BLKID
diff --git a/tunefs.ocfs2/Makefile b/tunefs.ocfs2/Makefile
index 35564e5..ba603b9 100644
--- a/tunefs.ocfs2/Makefile
+++ b/tunefs.ocfs2/Makefile
@@ -12,10 +12,13 @@ LIBO2DLM_LIBS = -L$(TOPDIR)/libo2dlm -lo2dlm $(DL_LIBS)
 LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
 
 LIBO2CB_LIBS = -L$(TOPDIR)/libo2cb -lo2cb
+LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
+ifneq ($(BUILD_FSDLM_SUPPORT),)
+LIBO2CB_LIBS += -ldlm_lt
+endif
 ifneq ($(BUILD_CMAP_SUPPORT),)
 LIBO2CB_LIBS += -lcmap
 endif
-LIBO2CB_DEPS = $(TOPDIR)/libo2cb/libo2cb.a
 
 UNINST_LIBRARIES = libocfs2ne.a
 
-- 
2.1.2
