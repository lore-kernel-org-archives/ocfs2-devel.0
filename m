From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:50 -0800
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Handle missing mnt_want_write()
	and mnt_drop_write()
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 8366025eb80dfa0d8d94b286d53027081c280ef1 added mnt_want_write()
and mnt_drop_write() to protect writes to a filesystem.

This patch disables this functionality when built on older EL5 kernels.

TODO: We should look into enabling this functionality for EL5.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Makefile                             |    3 ++-
 configure.in                         |    5 +++++
 kapi-compat/include/mnt_want_write.h |    7 +++++++
 3 files changed, 14 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/mnt_want_write.h

diff --git a/Makefile b/Makefile
index 7d9e0a9..a642c13 100644
--- a/Makefile
+++ b/Makefile
@@ -35,7 +35,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/inode_permission.h		\
 	kapi-compat/include/should_remove_suid.h	\
 	kapi-compat/include/user_path_at.h		\
-	kapi-compat/include/filemap_fdatawait_range.h
+	kapi-compat/include/filemap_fdatawait_range.h	\
+	kapi-compat/include/mnt_want_write.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index f028444..c9ddf88 100644
--- a/configure.in
+++ b/configure.in
@@ -419,6 +419,11 @@ OCFS2_CHECK_KERNEL([splice.h], splice.h,
   , SKIP_SPLICE=yes, [struct splice_desc {])
 AC_SUBST(SKIP_SPLICE)
 
+mnt_want_write=
+OCFS2_CHECK_KERNEL([mnt_want_write.h() and mnt_drop_write() in mount.h], mount.h,
+ , mnt_want_write=mnt_want_write.h, [^extern int mnt_want_write(])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $mnt_want_write"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/kapi-compat/include/mnt_want_write.h b/kapi-compat/include/mnt_want_write.h
new file mode 100644
index 0000000..2f234a8
--- /dev/null
+++ b/kapi-compat/include/mnt_want_write.h
@@ -0,0 +1,7 @@
+#ifndef KAPI_MNT_WANT_WRITE_H
+#define KAPI_MNT_WANT_WRITE_H
+
+#define mnt_want_write(a)	0
+#define mnt_drop_write(a)
+
+#endif
-- 
1.5.6.5
