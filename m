From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 26 Dec 2008 14:24:26 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] mkfs.ocfs2: Update fs-features list in
	man page
Message-ID: <1230330267-1975-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The list of available options for the fs-features flag in mkfs.ocfs2.8 was
out-dated. Update the list by added information on the 'backup-super',
'inline-data' and 'extended-slotmap' options. Also, update the reported list
of set features for the --fs-feature-level=default option.

At the same time, we remove the even more out of date list from the
tunefs.ocfs2 man page and provide a pointer to the mkfs.ocfs2 man page. This
way we only have one place to update.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 mkfs.ocfs2/mkfs.ocfs2.8.in     |   17 ++++++++++++++++-
 tunefs.ocfs2/tunefs.ocfs2.8.in |   24 +-----------------------
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/mkfs.ocfs2/mkfs.ocfs2.8.in b/mkfs.ocfs2/mkfs.ocfs2.8.in
index de43946..8b5dbed 100644
--- a/mkfs.ocfs2/mkfs.ocfs2.8.in
+++ b/mkfs.ocfs2/mkfs.ocfs2.8.in
@@ -108,6 +108,11 @@ Turn specific file system features on or off. A comma separated list of feature
 The following flags are supported:
 .RS 1.2i
 .TP
+\fBbackup-super\fR
+When this is set, mkfs.ocfs2 will store a copy of the super block in several known locations so that it can be used for disaster recovery. This feature is fully compatible with all versions of Ocfs2 and generally shouldn't be disabled.
+.RE
+.RS 1.2i
+.TP
 \fBlocal\fR
 Create the file system as a local mount, so that it can be mounted without a cluster stack. Available with the file system bundled with Linux kernels 2.6.20 and later.
 .RE
@@ -126,6 +131,16 @@ Enable support for sparse files. With this, \fIOCFS2\fR can avoid allocating (an
 \fBunwritten\fR
 Enable unwritten extents support. With this turned on, an application can request that a range of clusters be pre-allocated within a file. \fIOCFS2\fR will mark those extents with a special flag so that expensive data zeroing doesn't have to be performed. Reads and writes to a pre-allocated region act as reads and writes to a hole, except a write will not fail due to lack of data allocation. This feature requires \fBsparse\fR file support to be turned on. Available with the file system bundled with Linux kernels 2.6.23 and later.
 .RE
+.RS 1.2i
+.TP
+\fBinline-data\fR
+Enable inline-data support. If this feature is turned on, Ocfs2 will store small amounts of file and directory data inside of the inode block. Data is transparently moved out to an extent when it no longer fits inside the inode block. In some cases, this can also make a positive impact on cold-cache directory and file operations.
+.RE
+.RS 1.2i
+.TP
+\fBextended-slotmap\fR
+The slot-map is a hidden file on an Ocfs2 fs which is used to map mounted nodes to system file resources. The extended slot map allows a larger range of possible node numbers, which is useful for userspace cluster stacks. This feature is automatically turned on when needed, thus users have no need to turn this on manually.
+.RE
 
 .TP
 \fB\-\-fs\-feature\-level=\fR\fR\fIfeature\-level\fR
@@ -138,7 +153,7 @@ Chooses fewer features but ensures that the file system can be mounted from olde
 .RS 1.2i
 .TP
 \fBdefault\fR
-The default feature set tries to strike a balance between providing new features and maintaining compatibility with relatively recent versions of \fIOCFS2\fR. It currently enables \fBsparse\fR.
+The default feature set tries to strike a balance between providing new features and maintaining compatibility with relatively recent versions of \fIOCFS2\fR. It currently enables \fBsparse\fR and \fBunwritten\fR.
 .RE
 .RS 1.2i
 .TP
diff --git a/tunefs.ocfs2/tunefs.ocfs2.8.in b/tunefs.ocfs2/tunefs.ocfs2.8.in
index da6c713..96e55d9 100644
--- a/tunefs.ocfs2/tunefs.ocfs2.8.in
+++ b/tunefs.ocfs2/tunefs.ocfs2.8.in
@@ -13,29 +13,7 @@ This tool requires the \fIO2CB\fR cluster to be online.
 .SH "OPTIONS"
 .TP
 \fB\-\-fs\-features=\fR\fR\fI[no]sparse...\fR
-Turn specific file system features on or off. \fItunefs.ocfs2\fR will attempt to enable or disable the feature list provided. To enable a feature, include it in the list. To disable a feature, prepend \fBno\fR to the name.
-The following features are supported:
-.RS 1.2i
-.TP
-\fBsparse\fR
-Enable support for sparse files. With this, \fIOCFS2\fR can avoid allocating (and zeroing) data to fill holes. Available with the file system bundled with Linux kernels 2.6.22 and later.
-.RE
-.RS 1.2i
-.TP
-\fBunwritten\fR
-Enable unwritten extents support. With this turned on, an application can request that a range of clusters be pre-allocated within a file. \fIOCFS2\fR will mark those extents with a special flag so that expensive data zeroing doesn't have to be performed. Reads and writes to a pre-allocated region act as reads and writes to a hole, except a write will not fail due to lack of data allocation. This feature requires \fBsparse\fR file support to be turned on. Available with the file system bundled with Linux kernels 2.6.23 and later.
-.RE
-
-.TP
-\fB\-J, \-\-journal\-options\fR \fIoptions\fR
-Modify the journal using options specified on the command\-line.
-Journal options are comma separated, and may take an argument using
-the equals ('=') sign. The following options are supported:
-.RS 1.2i
-.TP
-\fBsize\fR=\fIjournal\-size\fR
-Grow the size of journal files for all the slots. Minimum size is 4M.
-.RE
+Turn specific file system features on or off. \fItunefs.ocfs2\fR will attempt to enable or disable the feature list provided. To enable a feature, include it in the list. To disable a feature, prepend \fBno\fR to the name. For a list of feature names, see the man page for \fBmkfs.ocfs2\fR.
 
 .TP
 \fB\-L, \-\-label\fR \fIvolume\-label\fR
-- 
1.5.6
