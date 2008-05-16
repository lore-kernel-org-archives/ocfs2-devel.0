From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 16 May 2008 14:04:23 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Fix two typos
In-Reply-To: <1210917863-6809-3-git-send-email-tiger.yang@oracle.com>
References: <1210917863-6809-1-git-send-email-tiger.yang@oracle.com>
	<1210917863-6809-2-git-send-email-tiger.yang@oracle.com>
	<1210917863-6809-3-git-send-email-tiger.yang@oracle.com>
Message-ID: <1210917863-6809-4-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Fixed typos added in ocfs2 1.4 git
commit b77f15f3bfc3bcf747f05e5d120fa38d69f3e7ad and
commit 2a96d67a1c49dbbe3eb10bb4957c93f9d74bec62

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 configure.in |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index 14a0316..bd4fe02 100644
--- a/configure.in
+++ b/configure.in
@@ -233,7 +233,7 @@ KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sysctl_compat_header"
 
 configfs_compat_header=""
 OCFS2_CHECK_KERNEL([configfs_depend_item() in configfs.h], configfs.h,
-  , configfs_compat_header="configfs.h", [configfs_depend_item()])
+  , configfs_compat_header="configfs.h", [configfs_depend_item(])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $configfs_compat_header"
 
 REGISTER_SYSCTL_TWO_ARGS=
@@ -413,7 +413,7 @@ AC_SUBST(NO_SYSTEM_UTSNAME)
 
 HAS_MS_LOOP_NO_AOPS=
 OCFS2_CHECK_KERNEL([MS_LOOP_NO_AOPS flag defined], fs.h,
-  HAS_MS_LOOP_NO_AOPS==yes, , [MS_LOOP_NO_AOPS])
+  HAS_MS_LOOP_NO_AOPS=yes, , [MS_LOOP_NO_AOPS])
 AC_SUBST(HAS_MS_LOOP_NO_AOPS)
 
 HAS_FOPS_SENDFILE=
-- 
1.5.4.4
