From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Nov 2009 17:47:35 -0800
Subject: [Ocfs2-devel] [PATCH 14/18] ocfs2: Handle older prototype of simple
	attribute get()
In-Reply-To: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258076859-13538-15-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 8b88b0998e35d239e74446cc30f354bdab86df89 changed prototype
of simple attribute get() by returning the value via an argument. Patch detects
older kernels and uses the older prototype that just return(ed) the value.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in        |    1 +
 configure.in          |    5 +++++
 fs/ocfs2/Makefile     |    4 ++++
 fs/ocfs2/blockcheck.c |    8 ++++++++
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index a0330b9..355bf2a 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -75,6 +75,7 @@ OLD_PERMISSION = @OLD_PERMISSION@
 KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
 OLD_BIO_END_IO_T = @OLD_BIO_END_IO_T@
 NO_FAULT_IN_VMOPS = @NO_FAULT_IN_VMOPS@
+GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index 56315a6..b8f1bd8 100644
--- a/configure.in
+++ b/configure.in
@@ -384,6 +384,11 @@ OCFS2_CHECK_KERNEL([inode_permision in fs.h], fs.h,
   , inode_permission_header=inode_permission.h, [^extern int inode_permission(struct inode \*])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $inode_permission_header"
 
+GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN=
+OCFS2_CHECK_KERNEL([	get() return u64 in simple_attr_open() in fs.h], fs.h,
+ GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN=yes, , [u64 (\*get)(void \*), void (\*set)(void \*, u64),])
+AC_SUBST(GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN)
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 401a1f5..6960f40 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -100,6 +100,10 @@ ifdef NO_FAULT_IN_VMOPS
 EXTRA_CFLAGS += -DNO_FAULT_IN_VMOPS
 endif
 
+ifdef GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN
+EXTRA_CFLAGS += -DGET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
index a1163b8..4927bf9 100644
--- a/fs/ocfs2/blockcheck.c
+++ b/fs/ocfs2/blockcheck.c
@@ -232,11 +232,19 @@ void ocfs2_hamming_fix_block(void *data, unsigned int blocksize,
 
 #ifdef CONFIG_DEBUG_FS
 
+#ifdef GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN
+static u64 blockcheck_u64_get(void *data)
+{
+	return *(u64 *)data;
+}
+#else
 static int blockcheck_u64_get(void *data, u64 *val)
 {
 	*val = *(u64 *)data;
 	return 0;
 }
+#endif
+
 DEFINE_SIMPLE_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
 
 static struct dentry *blockcheck_debugfs_create(const char *name,
-- 
1.5.6.5
