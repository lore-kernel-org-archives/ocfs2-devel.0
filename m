From: Jie Liu <jeff.liu@oracle.com>
Date: Mon, 20 Sep 2010 14:59:14 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] build: distribute new file, fiemap.h v4
In-Reply-To: <1284965955-24712-1-git-send-email-jeff.liu@oracle.com>
References: <>
 <1284965955-24712-1-git-send-email-jeff.liu@oracle.com>
Message-ID: <1284965955-24712-2-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

* src/Makefile.am (noinst_HEADERS): Add fiemap.h.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 coreutils-6.9/src/Makefile.am |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/coreutils-6.9/src/Makefile.am b/coreutils-6.9/src/Makefile.am
index 863a32b..af132e1 100644
--- a/coreutils-6.9/src/Makefile.am
+++ b/coreutils-6.9/src/Makefile.am
@@ -43,7 +43,8 @@ noinst_HEADERS = \
   remove.h \
   system.h \
   wheel-size.h \
-  wheel.h
+  wheel.h \
+  fiemap.h
 
 EXTRA_DIST = dcgen dircolors.hin tac-pipe.c \
   groups.sh wheel-gen.pl extract-magic c99-to-c89.diff
-- 
1.5.4.3
