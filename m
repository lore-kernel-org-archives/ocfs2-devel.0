From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Thu Jun 24 13:21:36 2004
Subject: [Ocfs2-devel] 
	Patch to fix the build error for dist target in ocfs-tools
Message-ID: <40DB17D7.2000202@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Build failed during the dist portion for me.  This patch is for ocfs-tools.

Index: ocfs2/debugfs.ocfs2/Makefile
===================================================================
--- ocfs2/debugfs.ocfs2/Makefile        (revision 96)
+++ ocfs2/debugfs.ocfs2/Makefile        (working copy)
@@ -12,7 +12,7 @@
  CFLAGS += -Wall -O2

  CFILES = main.c commands.c dump.c readfs.c
-HFILES = main.h commands.h dump.h readfs.h
+HFILES = include/main.h include/commands.h include/dump.h include/readfs.h

  OBJS = $(subst .c,.o,$(CFILES))
