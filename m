From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 19:39:58 -0800
Subject: [Ocfs2-devel] [PATCH 1/8] ocfs2: Handle missing macro MNT_RELATIME
In-Reply-To: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
References: <1257997205-18055-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257997205-18055-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 47ae32d6a54955a041cdc30b06d0bb16e75f68d5 added macro MNT_RELATIME.

It should be noted that the functionality will not be available on EL5
as the vfs support is missing.

TODO: This feature needs to be enabled by parsing the realtime mount
option in ocfs2 itself.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                       |    3 ++-
 configure.in                   |    5 +++++
 kapi-compat/include/relatime.h |    6 ++++++
 3 files changed, 13 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/relatime.h

diff --git a/Makefile b/Makefile
index 06ddabf..6676daf 100644
--- a/Makefile
+++ b/Makefile
@@ -16,7 +16,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/sync_mapping.h		\
 	kapi-compat/include/fpath.h			\
 	kapi-compat/include/ushortmax.h			\
-	kapi-compat/include/fversion.h
+	kapi-compat/include/fversion.h			\
+	kapi-compat/include/relatime.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 26b9f80..07325c3 100644
--- a/configure.in
+++ b/configure.in
@@ -271,6 +271,11 @@ OCFS2_CHECK_KERNEL([seq_open() has const struct seq_operations * in seq_file.h],
  , SEQOP_IS_NOT_CONST=yes, [int seq_open(struct file \*, const struct seq_operations \*);])
 AC_SUBST(SEQOP_IS_NOT_CONST)
 
+relatime_compat_header=""
+OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
+  , relatime_compat_header=relatime.h, [^#define MNT_RELATIME])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
+
 
 # End kapi_compat checks
 
diff --git a/kapi-compat/include/relatime.h b/kapi-compat/include/relatime.h
new file mode 100644
index 0000000..34c5d38
--- /dev/null
+++ b/kapi-compat/include/relatime.h
@@ -0,0 +1,6 @@
+#ifndef KAPI_RELATIME_H
+#define KAPI_RELATIME_H
+
+#define MNT_RELATIME    0x20
+
+#endif
-- 
1.5.6.5
