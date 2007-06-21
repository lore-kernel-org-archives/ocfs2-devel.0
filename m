From: Marcus Alves Grando <marcus.grando@terra.com.br>
Date: Thu Jun 21 15:52:02 2007
Subject: [Ocfs2-devel] [PATCH] Fix rev 1359 (ocfs2-tools)
Message-ID: <467B010A.7050700@terra.com.br>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Trivial patch to add HFILES in DIST_FILES.

Index: tunefs.ocfs2/Makefile
===================================================================
--- tunefs.ocfs2/Makefile	(revision 1360)
+++ tunefs.ocfs2/Makefile	(working copy)
@@ -35,7 +35,7 @@

  OBJS = $(subst .c,.o,$(CFILES))

-DIST_FILES = $(CFILES) tunefs.ocfs2.8.in
+DIST_FILES = $(CFILES) $(HFILES) tunefs.ocfs2.8.in

  tunefs.ocfs2: $(OBJS) $(LIBOCFS2_DEPS) $(LIBO2DLM_DEPS) $(LIBO2CB_DEPS)
  	$(LINK) $(LIBOCFS2_LIBS) $(UUID_LIBS) $(LIBO2DLM_LIBS) 
$(LIBO2CB_LIBS) $(COM_ERR_LIBS)

-- 
Marcus Alves Grando <marcus.grando [] terra.com.br>
Suporte Engenharia 1
Terra Networks Brasil S/A
Tel: 55 (51) 3284-4238

Qual ? a sua Terra?
