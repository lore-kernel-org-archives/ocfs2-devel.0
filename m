From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 25 Oct 2010 19:09:50 +0800
Subject: [Ocfs2-devel] [PATCH 6/6] O2info: Add --mkfs support for o2info.
In-Reply-To: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
References: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1288004990-20076-7-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

'--mkfs' teaches o2info to output an oringal format of mkfs.ocfs's
arguments, which can be used conveniently for a fresh mkfs try:

$mkfs.ocfs2 "$(o2info --mkfs /dev/name/or/path/of/file)" /dev/sdaX

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 o2info/o2info.1.in  |    7 ++-
 o2info/o2info.c     |   15 ++++
 o2info/operations.c |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+), 1 deletions(-)

diff --git a/o2info/o2info.1.in b/o2info/o2info.1.in
index a814d54..3ddfba6 100644
--- a/o2info/o2info.1.in
+++ b/o2info/o2info.1.in
@@ -2,7 +2,7 @@
 .SH "NAME"
 o2info \- Dump \fIOCFS2\fR file system information on disk.
 .SH "SYNOPSIS"
-\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] [\fB\-\-fs\-features\fR] [\fB\-\-volinfo\fR] <\fBdevice or file\fR>
+\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] [\fB\-\-fs\-features\fR] [\fB\-\-volinfo\fR] [\fB\-\-mkfs\fR] <\fBdevice or file\fR>
 
 .SH "DESCRIPTION"
 .PP
@@ -22,6 +22,11 @@ List all compat, incompat and ro-compat fs features on \fIOCFS2\fR filesystem.
 Dump basic volume information, such as blocksize, clustersize, volume label and UUID etc.
 
 .TP
+\fB\-\-mkfs\fR
+Dump an original format of mkfs.ocfs's arguments, importantly, which can be used directly as a fresh mkfs retry:
+#mkfs.ocfs2 "$(o2info --mkfs /dev/name/or/path/of/file)" /dev/sdaX
+
+.TP
 \fB\-V, \-\-version\fR
 Show version and exit.
 
diff --git a/o2info/o2info.c b/o2info/o2info.c
index 3ad3c90..9e23cfb 100644
--- a/o2info/o2info.c
+++ b/o2info/o2info.c
@@ -36,6 +36,7 @@
 
 extern struct o2info_operation fs_features_op;
 extern struct o2info_operation volinfo_op;
+extern struct o2info_operation mkfs_op;
 
 static LIST_HEAD(o2info_op_task_list);
 static int o2info_op_task_count;
@@ -127,12 +128,26 @@ static struct o2info_option volinfo_option = {
 	.opt_private	= NULL,
 };
 
+static struct o2info_option mkfs_option = {
+	.opt_option	= {
+		.name		= "mkfs",
+		.val		= CHAR_MAX,
+		.has_arg	= 0,
+		.flag		= NULL,
+	},
+	.opt_help	= "   --mkfs",
+	.opt_handler	= NULL,
+	.opt_op		= &mkfs_op,
+	.opt_private	= NULL,
+};
+
 static struct o2info_option *options[] = {
 	&help_option,
 	&version_option,
 	&coherency_option,
 	&fs_features_option,
 	&volinfo_option,
+	&mkfs_option,
 	NULL,
 };
 
diff --git a/o2info/operations.c b/o2info/operations.c
index 7d667ae..39038bf 100644
--- a/o2info/operations.c
+++ b/o2info/operations.c
@@ -448,3 +448,190 @@ out:
 DEFINE_O2INFO_OP(volinfo,
 		 volinfo_run,
 		 NULL);
+
+struct o2info_mkfs {
+	struct o2info_volinfo ovf;
+	uint64_t journal_size;
+};
+
+static int get_mkfs_libocfs2(struct o2info_operation *op,
+			     ocfs2_filesys *fs,
+			     struct o2info_mkfs *oms)
+{
+	errcode_t err;
+	uint64_t blkno;
+	char *buf = NULL;
+	struct ocfs2_dinode *di = NULL;
+
+	memset(oms, 0, sizeof(*oms));
+
+	err = ocfs2_malloc_block(fs->fs_io, &buf);
+	if (err) {
+		tcom_err(err, "while allocating buffer");
+		goto out;
+	}
+
+	err = ocfs2_lookup_system_inode(fs, JOURNAL_SYSTEM_INODE, 0, &blkno);
+	if (err) {
+		tcom_err(err, "while looking up journal system inode");
+		goto out;
+	} else
+
+	err = ocfs2_read_inode(fs, blkno, buf);
+	if (err) {
+		tcom_err(err, "while reading journal system inode");
+		goto out;
+	}
+
+	di = (struct ocfs2_dinode *)buf;
+
+	oms->journal_size = di->i_size;
+
+	err = get_volinfo_libocfs2(op, fs, &(oms->ovf));
+
+out:
+	if (buf)
+		ocfs2_free(&buf);
+
+	return err;
+}
+
+static int get_mkfs_ioctl(struct o2info_operation *op, int fd,
+			  struct o2info_mkfs *oms)
+{
+	int rc = 0, flags = 0;
+	uint32_t unknowns = 0, errors = 0, fills = 0;
+	struct ocfs2_info_journal_size oij;
+	uint64_t reqs[1];
+	struct ocfs2_info info;
+
+	memset(oms, 0, sizeof(*oms));
+
+	if (!cluster_coherent)
+		flags |= OCFS2_INFO_FL_NON_COHERENT;
+
+	o2info_fill_request((struct ocfs2_info_request *)&oij, sizeof(oij),
+			    OCFS2_INFO_JOURNAL_SIZE, flags);
+
+	reqs[0] = (unsigned long)&oij;
+
+	info.oi_requests = (uint64_t)reqs;
+	info.oi_count = 1;
+
+	rc = ioctl(fd, OCFS2_IOC_INFO, &info);
+	if (rc) {
+		rc = errno;
+		o2i_error(op, "ioctl failed: %s\n", strerror(rc));
+		o2i_scan_requests(op, info, &unknowns, &errors, &fills);
+		goto out;
+	}
+
+	if (oij.ij_req.ir_flags & OCFS2_INFO_FL_FILLED)
+		oms->journal_size = oij.ij_journal_size;
+
+	rc = get_volinfo_ioctl(op, fd, &(oms->ovf));
+
+out:
+	return rc;
+}
+
+static int o2info_gen_mkfs_string(struct o2info_mkfs oms, char **mkfs)
+{
+	int rc = 0;
+	char *compat = NULL;
+	char *incompat = NULL;
+	char *rocompat = NULL;
+	char *features = NULL;
+	char *ptr = NULL;
+	char op_fs_features[PATH_MAX];
+	char op_label[PATH_MAX];
+	char buf[4096];
+
+#define MKFS "-N %u "		\
+	     "-J size=%llu "	\
+	     "-b %u "		\
+	     "-C %u "		\
+	     "%s "		\
+	     "%s "
+
+	rc = o2info_get_compat_flag(oms.ovf.ofs.compat, &compat);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_incompat_flag(oms.ovf.ofs.incompat, &incompat);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_rocompat_flag(oms.ovf.ofs.rocompat, &rocompat);
+	if (rc)
+		goto out;
+
+	features = malloc(strlen(compat) + strlen(incompat) +
+			  strlen(rocompat) + 3);
+
+	sprintf(features, "%s %s %s", compat, incompat, rocompat);
+
+	ptr = features;
+
+	while ((ptr = strchr(ptr, ' ')))
+		*ptr = ',';
+
+	if (strcmp("", features))
+		snprintf(op_fs_features, PATH_MAX, "--fs-features %s",
+			 features);
+	else
+		strcpy(op_fs_features, "");
+
+	if (strcmp("", (char *)oms.ovf.label))
+		snprintf(op_label, PATH_MAX, "-L %s", (char *)(oms.ovf.label));
+	else
+		strcpy(op_label, "");
+
+	snprintf(buf, 4096, MKFS, oms.ovf.maxslots, oms.journal_size,
+		 oms.ovf.blocksize, oms.ovf.clustersize, op_fs_features,
+		 op_label);
+
+	*mkfs = strdup(buf);
+out:
+	if (compat)
+		ocfs2_free(&compat);
+
+	if (incompat)
+		ocfs2_free(&incompat);
+
+	if (rocompat)
+		ocfs2_free(&rocompat);
+
+	if (features)
+		ocfs2_free(&features);
+
+	return rc;
+}
+
+static int mkfs_run(struct o2info_operation *op, struct o2info_method *om,
+		    void *arg)
+{
+	int rc = 0;
+	static struct o2info_mkfs oms;
+	char *mkfs = NULL;
+
+	if (om->om_method == O2INFO_USE_IOCTL)
+		rc = get_mkfs_ioctl(op, om->om_fd, &oms);
+	else
+		rc = get_mkfs_libocfs2(op, om->om_fs, &oms);
+	if (rc)
+		goto out;
+
+	o2info_gen_mkfs_string(oms, &mkfs);
+
+	fprintf(stdout, "%s\n", mkfs);
+out:
+	if (mkfs)
+		ocfs2_free(&mkfs);
+
+	return rc;
+}
+
+DEFINE_O2INFO_OP(mkfs,
+		 mkfs_run,
+		 NULL);
-- 
1.5.5
