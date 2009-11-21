From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:53 -0800
Subject: [Ocfs2-devel] [PATCH 06/10] ocfs2/dlm: Handle missing name in
	backing_dev_info
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit d993831fa7ffeb89e994f046f93eeb09ec91df08 added name
in struct backing_dev_info. When built on older kernels, patch ifdefs
out the name in the structure.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in        |    1 +
 configure.in          |    5 +++++
 fs/ocfs2/dlm/Makefile |    4 ++++
 fs/ocfs2/dlm/dlmfs.c  |    2 ++
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 5a81e44..0107e2e 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -80,6 +80,7 @@ NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
+NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index d042f9c..0a3a356 100644
--- a/configure.in
+++ b/configure.in
@@ -435,6 +435,11 @@ OCFS2_CHECK_KERNEL([struct jbd2_buffer_trigger_type in jbd2.h], jbd2.h,
 AC_SUBST(SKIP_BUFFER_TRIGGERS)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $SKIP_BUFFER_TRIGGERS"
 
+NO_NAME_IN_BACKING_DEV_INFO=
+OCFS2_CHECK_KERNEL([name in backing-dev.h], backing-dev.h,
+ , NO_NAME_IN_BACKING_DEV_INFO=yes, [char.*\*name;$])
+AC_SUBST(NO_NAME_IN_BACKING_DEV_INFO)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index 907e390..f868c0e 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -46,6 +46,10 @@ ifdef KMEM_CACHE_CREATE_DTOR
 EXTRA_CFLAGS += -DKMEM_CACHE_CREATE_DTOR
 endif
 
+ifdef NO_NAME_IN_BACKING_DEV_INFO
+EXTRA_CFLAGS += -DNO_NAME_IN_BACKING_DEV_INFO
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 6d97173..576d3ec 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -340,7 +340,9 @@ clear_fields:
 }
 
 static struct backing_dev_info dlmfs_backing_dev_info = {
+#ifndef NO_NAME_IN_BACKING_DEV_INFO
 	.name		= "ocfs2-dlmfs",
+#endif
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
-- 
1.5.6.5
