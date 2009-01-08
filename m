From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 7 Jan 2009 16:55:40 -0800
Subject: [Ocfs2-devel] [Ocfs2-tools-devel] [PATCH 1/2] mkfs.ocfs2:
	Update fs-features list in man page
In-Reply-To: <4963EDF0.3020600@oracle.com>
References: <1230330267-1975-1-git-send-email-mfasheh@suse.com>
	<4963EDF0.3020600@oracle.com>
Message-ID: <20090108005540.GW17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 06, 2009 at 03:49:04PM -0800, Sunil Mushran wrote:
> Comments inlined.
> 
> Mark Fasheh wrote:
> >The list of available options for the fs-features flag in mkfs.ocfs2.8 was
> >out-dated. Update the list by added information on the 'backup-super',
> >'inline-data' and 'extended-slotmap' options. Also, update the reported 
> >list
> >of set features for the --fs-feature-level=default option.
> >
> >At the same time, we remove the even more out of date list from the
> >tunefs.ocfs2 man page and provide a pointer to the mkfs.ocfs2 man page. 
> >This
> >way we only have one place to update.
> >
> >Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> >---
> > mkfs.ocfs2/mkfs.ocfs2.8.in     |   17 ++++++++++++++++-
> > tunefs.ocfs2/tunefs.ocfs2.8.in |   24 +-----------------------
> > 2 files changed, 17 insertions(+), 24 deletions(-)
> >
> >diff --git a/mkfs.ocfs2/mkfs.ocfs2.8.in b/mkfs.ocfs2/mkfs.ocfs2.8.in
> >index de43946..8b5dbed 100644
> >--- a/mkfs.ocfs2/mkfs.ocfs2.8.in
> >+++ b/mkfs.ocfs2/mkfs.ocfs2.8.in
> >@@ -108,6 +108,11 @@ Turn specific file system features on or off. A comma 
> >separated list of feature
> > The following flags are supported:
> > .RS 1.2i
> > .TP
> >+\fBbackup-super\fR
> >+When this is set, mkfs.ocfs2 will store a copy of the super block in 
> >several known locations so that it can be used for disaster recovery. This 
> >feature is fully compatible with all versions of Ocfs2 and generally 
> >shouldn't be disabled.
> 
> backup-super already exists below local. And then there is 
> --no-backup-super.
> All with different wording. How about we remove the other two and tweak the
> wording as follows:
> 
> \fBmkfs.ocfs2\fR, by default, makes upto 6 backup copies of the super block
> at offsets 1G, 4G, 16G, 64G, 256G and 1T depending on the size of the 
> volume.
> This can be useful in disaster recovery. This feature is fully compatible
> with all versions of the file system and generally should not be disabled.


Sounds good. I left the last one '--no-backup-super' there and marked it
deprecated though. I figure it's best to keep it documented until we remove
it from mkfs.ocfs2 altogether.


> Enable inline-data support. If this feature is turned on, /fIOCFS2/fR will
> store small files and directories inside the inode block. Data is
> transparently moved out to an extent when it no longer fits inside the
> inode block. In some cases, this can also make a positive impact on
> cold-cache directory and file operations. Available with the file system
> bundled with Linux kernels 2.6.24 and later.


> Change Ocfs2 to \fIOCFS2\fR. Also append:
> Available with the file system bundled with Linux kernels 2.6.27 and later.


Done, though I'm starting to wonder about us versioning the features like
that. A lot of distro kernels will have these features applied even though
the actual version number is lower.


> 
> > 
> > .TP
> > \fB\-\-fs\-feature\-level=\fR\fR\fIfeature\-level\fR
> >@@ -138,7 +153,7 @@ Chooses fewer features but ensures that the file 
> >system can be mounted from olde
> > .RS 1.2i
> > .TP
> > \fBdefault\fR
> >-The default feature set tries to strike a balance between providing new 
> >features and maintaining compatibility with relatively recent versions of 
> >\fIOCFS2\fR. It currently enables \fBsparse\fR.
> >+The default feature set tries to strike a balance between providing new 
> >features and maintaining compatibility with relatively recent versions of 
> >\fIOCFS2\fR. It currently enables \fBsparse\fR and \fBunwritten\fR.
> > .RE
> > .RS 1.2i
> > .TP
> >diff --git a/tunefs.ocfs2/tunefs.ocfs2.8.in 
> >b/tunefs.ocfs2/tunefs.ocfs2.8.in
> >index da6c713..96e55d9 100644
> >--- a/tunefs.ocfs2/tunefs.ocfs2.8.in
> >+++ b/tunefs.ocfs2/tunefs.ocfs2.8.in
> >@@ -13,29 +13,7 @@ This tool requires the \fIO2CB\fR cluster to be online.
> > .SH "OPTIONS"
> > .TP
> > \fB\-\-fs\-features=\fR\fR\fI[no]sparse...\fR
> >-Turn specific file system features on or off. \fItunefs.ocfs2\fR will 
> >attempt to enable or disable the feature list provided. To enable a 
> >feature, include it in the list. To disable a feature, prepend \fBno\fR to 
> >the name.
> >-The following features are supported:
> >-.RS 1.2i
> >-.TP
> >-\fBsparse\fR
> >-Enable support for sparse files. With this, \fIOCFS2\fR can avoid 
> >allocating (and zeroing) data to fill holes. Available with the file 
> >system bundled with Linux kernels 2.6.22 and later.
> >-.RE
> >-.RS 1.2i
> >-.TP
> >-\fBunwritten\fR
> >-Enable unwritten extents support. With this turned on, an application can 
> >request that a range of clusters be pre-allocated within a file. 
> >\fIOCFS2\fR will mark those extents with a special flag so that expensive 
> >data zeroing doesn't have to be performed. Reads and writes to a 
> >pre-allocated region act as reads and writes to a hole, except a write 
> >will not fail due to lack of data allocation. This feature requires 
> >\fBsparse\fR file support to be turned on. Available with the file system 
> >bundled with Linux kernels 2.6.23 and later.
> >-.RE
> >-
> >-.TP
> >-\fB\-J, \-\-journal\-options\fR \fIoptions\fR
> >-Modify the journal using options specified on the command\-line.
> >-Journal options are comma separated, and may take an argument using
> >-the equals ('=') sign. The following options are supported:
> >-.RS 1.2i
> >-.TP
> >-\fBsize\fR=\fIjournal\-size\fR
> >-Grow the size of journal files for all the slots. Minimum size is 4M.
> >-.RE
> >+Turn specific file system features on or off. \fItunefs.ocfs2\fR will 
> >attempt to enable or disable the feature list provided. To enable a 
> >feature, include it in the list. To disable a feature, prepend \fBno\fR to 
> >the name. For a list of feature names, see the man page for 
> >\fBmkfs.ocfs2\fR.
> > 
> > .TP
> > \fB\-L, \-\-label\fR \fIvolume\-label\fR
> 
> --journal-option is not a fs-feature per se. We should leave it as is.
> Rest is ok.

Erm, and then we'll be left with the same situation as --fs-features where
one gets updated and the other doesn't, etc... I think what *was* a mistake
was me not putting a pointer to mkfs.ocfs2.8 for --journal-options...
	--Mark

--
Mark Fasheh


From: Mark Fasheh <mfasheh@suse.com>

mkfs.ocfs2: Update fs-features list in man page

The list of available options for the fs-features flag in mkfs.ocfs2.8 was
out-dated. Update the list by added information on the 'backup-super',
'inline-data' and 'extended-slotmap' options. Also, update the reported list
of set features for the --fs-feature-level=default option.

At the same time, we remove the even more out of date list from the
tunefs.ocfs2 man page and provide a pointer to the mkfs.ocfs2 man page. This
way we only have one place to update.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 mkfs.ocfs2/mkfs.ocfs2.8.in     |   26 +++++++++++++++++---------
 tunefs.ocfs2/tunefs.ocfs2.8.in |   22 ++--------------------
 2 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/mkfs.ocfs2/mkfs.ocfs2.8.in b/mkfs.ocfs2/mkfs.ocfs2.8.in
index de43946..0e5c3a3 100644
--- a/mkfs.ocfs2/mkfs.ocfs2.8.in
+++ b/mkfs.ocfs2/mkfs.ocfs2.8.in
@@ -2,7 +2,7 @@
 .SH "NAME"
 mkfs.ocfs2 \- Creates an \fIOCFS2\fR file system.
 .SH "SYNOPSIS"
-\fBmkfs.ocfs2\fR [\fB\-b\fR \fIblock\-size\fR] [\fB\-C\fR \fIcluster\-size\fR] [\fB\-L\fR \fIvolume\-label\fR] [\fB\-M\fR \fImount-type\fR] [\fB\-N\fR \fInumber\-of\-nodes\fR] [\fB\-J\fR \fIjournal\-options\fR] [\fB\-\-fs\-features=\fR\fI[no]sparse...\fR] [\fB\-\-fs\-feature\-level=\fR\fIfeature\-level\fR] [\fB\-T\fR \fIfilesystem\-type\fR] [\fB\-FqvV\fR] [\fB\-\-no\-backup\-super\fR] \fIdevice\fR [\fIblocks-count\fI]
+\fBmkfs.ocfs2\fR [\fB\-b\fR \fIblock\-size\fR] [\fB\-C\fR \fIcluster\-size\fR] [\fB\-L\fR \fIvolume\-label\fR] [\fB\-M\fR \fImount-type\fR] [\fB\-N\fR \fInumber\-of\-nodes\fR] [\fB\-J\fR \fIjournal\-options\fR] [\fB\-\-fs\-features=\fR\fI[no]sparse...\fR] [\fB\-\-fs\-feature\-level=\fR\fIfeature\-level\fR] [\fB\-T\fR \fIfilesystem\-type\fR] [\fB\-FqvV\fR] \fIdevice\fR [\fIblocks-count\fI]
 .SH "DESCRIPTION"
 .PP
 \fBmkfs.ocfs2\fR is used to create an \fIOCFS2\fR file system on a \fIdevice\fR,
@@ -108,13 +108,13 @@ Turn specific file system features on or off. A comma separated list of feature
 The following flags are supported:
 .RS 1.2i
 .TP
-\fBlocal\fR
-Create the file system as a local mount, so that it can be mounted without a cluster stack. Available with the file system bundled with Linux kernels 2.6.20 and later.
+\fBbackup-super\fR
+\fBmkfs.ocfs2\fR, by default, makes up to 6 backup copies of the super block at offsets 1G, 4G, 16G, 64G, 256G and 1T depending on the size of the volume.  This can be useful in disaster recovery. This feature is fully compatible with all versions of the file system and generally should not be disabled.
 .RE
 .RS 1.2i
 .TP
-\fBbackup-super\fR
-Create backup super blocks for this volume.
+\fBlocal\fR
+Create the file system as a local mount, so that it can be mounted without a cluster stack. Available with the file system bundled with Linux kernels 2.6.20 and later.
 .RE
 .RS 1.2i
 .TP
@@ -126,6 +126,16 @@ Enable support for sparse files. With this, \fIOCFS2\fR can avoid allocating (an
 \fBunwritten\fR
 Enable unwritten extents support. With this turned on, an application can request that a range of clusters be pre-allocated within a file. \fIOCFS2\fR will mark those extents with a special flag so that expensive data zeroing doesn't have to be performed. Reads and writes to a pre-allocated region act as reads and writes to a hole, except a write will not fail due to lack of data allocation. This feature requires \fBsparse\fR file support to be turned on. Available with the file system bundled with Linux kernels 2.6.23 and later.
 .RE
+.RS 1.2i
+.TP
+\fBinline-data\fR
+Enable inline-data support. If this feature is turned on, /fIOCFS2/fR will store small files and directories inside the inode block. Data is transparently moved out to an extent when it no longer fits inside the inode block. In some cases, this can also make a positive impact on cold-cache directory and file operations. Available with the file system bundled with Linux kernels 2.6.24 and later.
+.RE
+.RS 1.2i
+.TP
+\fBextended-slotmap\fR
+The slot-map is a hidden file on an \fIOCFS2\fR fs which is used to map mounted nodes to system file resources. The extended slot map allows a larger range of possible node numbers, which is useful for userspace cluster stacks. This feature is automatically turned on when needed, thus users have no need to turn this on manually. Available in the file system bundled with Linux kernels 2.6.27 and later.
+.RE
 
 .TP
 \fB\-\-fs\-feature\-level=\fR\fR\fIfeature\-level\fR
@@ -138,7 +148,7 @@ Chooses fewer features but ensures that the file system can be mounted from olde
 .RS 1.2i
 .TP
 \fBdefault\fR
-The default feature set tries to strike a balance between providing new features and maintaining compatibility with relatively recent versions of \fIOCFS2\fR. It currently enables \fBsparse\fR.
+The default feature set tries to strike a balance between providing new features and maintaining compatibility with relatively recent versions of \fIOCFS2\fR. It currently enables \fBsparse\fR and \fBunwritten\fR.
 .RE
 .RS 1.2i
 .TP
@@ -148,9 +158,7 @@ Choose the maximum amount of features available. This will typically provide the
 
 .TP
 \fB\-\-no-backup-super\fR
-\fBmkfs.ocfs2\fR, by default, makes upto 6 backup copies of the superblock
-at offsets 1G, 4G, 16G, 64G, 256G and 1T depending on the size of the volume.
-Use this option to make the volume with no backup superblocks.
+This option is deprecated, please use \fB--fs-features=nobackup-super\fR instead.
 
 .TP
 \fB\-q, \-\-quiet\fR
diff --git a/tunefs.ocfs2/tunefs.ocfs2.8.in b/tunefs.ocfs2/tunefs.ocfs2.8.in
index da6c713..7a9b66b 100644
--- a/tunefs.ocfs2/tunefs.ocfs2.8.in
+++ b/tunefs.ocfs2/tunefs.ocfs2.8.in
@@ -13,29 +13,11 @@ This tool requires the \fIO2CB\fR cluster to be online.
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
+Turn specific file system features on or off. \fItunefs.ocfs2\fR will attempt to enable or disable the feature list provided. To enable a feature, include it in the list. To disable a feature, prepend \fBno\fR to the name. For a list of feature names, see the man page for \fBmkfs.ocfs2\fR.
 
 .TP
 \fB\-J, \-\-journal\-options\fR \fIoptions\fR
-Modify the journal using options specified on the command\-line.
-Journal options are comma separated, and may take an argument using
-the equals ('=') sign. The following options are supported:
-.RS 1.2i
-.TP
-\fBsize\fR=\fIjournal\-size\fR
-Grow the size of journal files for all the slots. Minimum size is 4M.
-.RE
+Modify the journal using options specified on the command\-line. Journal options are comma separated, and may take an argument using the equals ('=') sign. For a list of possible options, see the man page for \fBmkfs.ocfs2\fR.
 
 .TP
 \fB\-L, \-\-label\fR \fIvolume\-label\fR
-- 
1.5.6
