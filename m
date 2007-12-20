From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Dec 20 15:29:58 2007
Subject: [Ocfs2-devel] [PATCH 22/30] ocfs2: Handles missing export
	should_remove_suid()
In-Reply-To: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1198193387-16606-21-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commits 01de85e057328ecbef36e108673b1e81059d54c1 and
d23a147bb6e8d467e8df73b6589888717da3b9ce in mainline added and exported
symbol should_remove_suid(). This patch allows one to build ocfs2 with
kernels having/not having these changes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/file.c   |   30 ++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 39fb02b..472e01a 100644
--- a/configure.in
+++ b/configure.in
@@ -257,6 +257,11 @@ OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
   , relatime_compat_header="mount.h", [^#define MNT_RELATIME])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
 
+SHOULD_REMOVE_SUID=
+OCFS2_CHECK_KERNEL([should_remove_suid() in fs.h], fs.h,
+  SHOULD_REMOVE_SUID=yes, , [should_remove_suid()])
+AC_SUBST(SHOULD_REMOVE_SUID)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 3cc7c74..a80a9fc 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -53,6 +53,10 @@ ifdef SPLICE_HEADER
 EXTRA_CFLAGS += -DSPLICE_HEADER
 endif
 
+ifdef SHOULD_REMOVE_SUID
+EXTRA_CFLAGS += -DSHOULD_REMOVE_SUID
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1c179fc..cee10ae 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1593,6 +1593,36 @@ out:
 	return ret;
 }
 
+#ifndef SHOULD_REMOVE_SUID
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	mode_t mode = dentry->d_inode->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID)))
+		return kill;
+
+	return 0;
+}
+#endif
+
 /*
  * Parts of this function taken from xfs_change_file_space()
  */
-- 
1.5.2.5
