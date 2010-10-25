From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 25 Oct 2010 19:09:48 +0800
Subject: [Ocfs2-devel] [PATCH 4/6] O2info: Add running codes for
	'--fs-features'.
In-Reply-To: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
References: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1288004990-20076-5-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch teaches o2info to dump fs's features on volume.

Task of dumping 'fs-features' will be capable of two approaches,
including libocfs2 and ioctl methods.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 o2info/o2info.1.in  |    6 +-
 o2info/o2info.c     |   16 ++++
 o2info/operations.c |  227 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 o2info/utils.c      |   75 +++++++++++++++++
 o2info/utils.h      |    4 +
 5 files changed, 326 insertions(+), 2 deletions(-)

diff --git a/o2info/o2info.1.in b/o2info/o2info.1.in
index d748df8..2622a8e 100644
--- a/o2info/o2info.1.in
+++ b/o2info/o2info.1.in
@@ -2,7 +2,7 @@
 .SH "NAME"
 o2info \- Dump \fIOCFS2\fR file system information on disk.
 .SH "SYNOPSIS"
-\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] <\fBdevice or file\fR>
+\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] [\fB\-\-fs\-features\fR] <\fBdevice or file\fR>
 
 .SH "DESCRIPTION"
 .PP
@@ -14,6 +14,10 @@ o2info \- Dump \fIOCFS2\fR file system information on disk.
 Enable cluster (in)coherency for mounted case, means it will attempt to acquire a global PR lock when querying info from a cluster filesystem, which may degrade the performance, default is none cluster-coherency.
 
 .TP
+\fB\-\-fs\-features\fR
+List all compat, incompat and ro-compat fs features on \fIOCFS2\fR filesystem.
+
+.TP
 \fB\-V, \-\-version\fR
 Show version and exit.
 
diff --git a/o2info/o2info.c b/o2info/o2info.c
index 3fa4627..c91317a 100644
--- a/o2info/o2info.c
+++ b/o2info/o2info.c
@@ -34,6 +34,8 @@
 
 #include "utils.h"
 
+extern struct o2info_operation fs_features_op;
+
 static LIST_HEAD(o2info_op_task_list);
 static int o2info_op_task_count;
 int cluster_coherent;
@@ -98,10 +100,24 @@ static struct o2info_option coherency_option = {
 	.opt_private = NULL,
 };
 
+static struct o2info_option fs_features_option = {
+	.opt_option	= {
+		.name		= "fs-features",
+		.val		= CHAR_MAX,
+		.has_arg	= 0,
+		.flag		= NULL,
+	},
+	.opt_help	= "   --fs-features",
+	.opt_handler	= NULL,
+	.opt_op		= &fs_features_op,
+	.opt_private	= NULL,
+};
+
 static struct o2info_option *options[] = {
 	&help_option,
 	&version_option,
 	&coherency_option,
+	&fs_features_option,
 	NULL,
 };
 
diff --git a/o2info/operations.c b/o2info/operations.c
index 14214fe..3aaf7b5 100644
--- a/o2info/operations.c
+++ b/o2info/operations.c
@@ -49,13 +49,238 @@ static inline void o2info_fill_request(struct ocfs2_info_request *req,
 	req->ir_flags = flags;
 }
 
+static void o2i_info(struct o2info_operation *op, const char *fmt, ...)
+{
+	va_list ap;
+
+	fprintf(stdout, "%s Info: ", op->to_name);
+	va_start(ap, fmt);
+	vfprintf(stdout, fmt, ap);
+
+	return;
+}
+
 static void o2i_error(struct o2info_operation *op, const char *fmt, ...)
 {
 	va_list ap;
 
-	fprintf(stderr, "%s: ", op->to_name);
+	fprintf(stderr, "%s Error: ", op->to_name);
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
 
 	return;
 }
+
+/*
+ * Helper to scan all requests:
+ *
+ * - Print all errors and unknown requests.
+ * - Return number of unknown requests.
+ * - Return number of errors.
+ * - Return number of handled requesets.
+ * - Return first and last error code.
+ */
+static void o2i_scan_requests(struct o2info_operation *op,
+			      struct ocfs2_info info, uint32_t *unknowns,
+			      uint32_t *errors, uint32_t *fills)
+{
+	uint32_t i, num_unknown = 0, num_error = 0, num_filled = 0;
+	uint64_t *reqs;
+	struct ocfs2_info_request *req;
+
+	for (i = 0; i < info.oi_count; i++) {
+
+		reqs = (uint64_t *)info.oi_requests;
+		req = (struct ocfs2_info_request *)reqs[i];
+		if (req->ir_flags & OCFS2_INFO_FL_ERROR) {
+			o2i_error(op, "o2info request(%d) failed.\n",
+				  req->ir_code);
+			num_error++;
+			continue;
+		}
+
+		if (!(req->ir_flags & OCFS2_INFO_FL_FILLED)) {
+			o2i_info(op, "o2info request(%d) is unsupported.\n",
+				 req->ir_code);
+			num_unknown++;
+			continue;
+		}
+
+		num_filled++;
+	}
+
+	*unknowns = num_unknown;
+	*errors = num_error;
+	*fills = num_filled;
+}
+
+struct o2info_fs_features {
+	uint32_t compat;
+	uint32_t incompat;
+	uint32_t rocompat;
+};
+
+static int get_fs_features_ioctl(struct o2info_operation *op,
+				 int fd,
+				 struct o2info_fs_features *ofs)
+{
+	int rc = 0, flags = 0;
+	uint32_t unknowns = 0, errors = 0, fills = 0;
+	uint64_t reqs[1];
+	struct ocfs2_info_fs_features oif;
+	struct ocfs2_info info;
+
+	memset(ofs, 0, sizeof(*ofs));
+
+	if (!cluster_coherent)
+		flags |= OCFS2_INFO_FL_NON_COHERENT;
+
+	o2info_fill_request((struct ocfs2_info_request *)&oif, sizeof(oif),
+			    OCFS2_INFO_FS_FEATURES, flags);
+
+	reqs[0] = (unsigned long)&oif;
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
+	if (oif.if_req.ir_flags & OCFS2_INFO_FL_FILLED) {
+		ofs->compat = oif.if_compat_features;
+		ofs->incompat = oif.if_incompat_features;
+		ofs->rocompat = oif.if_ro_compat_features;
+	}
+
+out:
+	return rc;
+}
+
+static int get_fs_features_libocfs2(struct o2info_operation *op,
+				    ocfs2_filesys *fs,
+				    struct o2info_fs_features *ofs)
+{
+	int rc = 0;
+	struct ocfs2_super_block *sb = NULL;
+
+	memset(ofs, 0, sizeof(*ofs));
+
+	sb = OCFS2_RAW_SB(fs->fs_super);
+	ofs->compat = sb->s_feature_compat;
+	ofs->incompat = sb->s_feature_incompat;
+	ofs->rocompat = sb->s_feature_ro_compat;
+
+	return rc;
+}
+
+static void o2info_print_line(char const *qualifier, char *content,
+			      char splitter)
+{
+	char *ptr = NULL, *token = NULL, *tmp = NULL;
+	uint32_t max_len = 80, len = 0;
+
+	tmp = malloc(max_len);
+	ptr = content;
+
+	snprintf(tmp, max_len, "%s", qualifier);
+	fprintf(stdout, "%s", tmp);
+	len += strlen(tmp);
+
+	while (ptr) {
+
+		token = ptr;
+		ptr = strchr(ptr, splitter);
+
+		if (ptr)
+			*ptr = 0;
+
+		if (strcmp(token, "") != 0) {
+			snprintf(tmp, max_len, "%s ", token);
+			len += strlen(tmp);
+			if (len > max_len) {
+				fprintf(stdout, "\n");
+				len = 0;
+				snprintf(tmp, max_len, "%s", qualifier);
+				fprintf(stdout, "%s", tmp);
+				len += strlen(tmp);
+				snprintf(tmp, max_len, "%s ", token);
+				fprintf(stdout, "%s", tmp);
+				len += strlen(tmp);
+			} else
+				fprintf(stdout, "%s", tmp);
+		}
+
+		if (!ptr)
+			break;
+
+		ptr++;
+	}
+
+	fprintf(stdout, "\n");
+
+	if (tmp)
+		ocfs2_free(&tmp);
+}
+
+static int fs_features_run(struct o2info_operation *op,
+			   struct o2info_method *om,
+			   void *arg)
+{
+	int rc = 0;
+	static struct o2info_fs_features ofs;
+
+	char *compat = NULL;
+	char *incompat = NULL;
+	char *rocompat = NULL;
+	char *features = NULL;
+
+	if (om->om_method == O2INFO_USE_IOCTL)
+		rc = get_fs_features_ioctl(op, om->om_fd, &ofs);
+	else
+		rc = get_fs_features_libocfs2(op, om->om_fs, &ofs);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_compat_flag(ofs.compat, &compat);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_incompat_flag(ofs.incompat, &incompat);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_rocompat_flag(ofs.rocompat, &rocompat);
+	if (rc)
+		goto out;
+
+	features = malloc(strlen(compat) + strlen(incompat) +
+			  strlen(rocompat) + 3);
+
+	sprintf(features, "%s %s %s", compat, incompat, rocompat);
+
+	o2info_print_line("", features, ' ');
+
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
+DEFINE_O2INFO_OP(fs_features,
+		 fs_features_run,
+		 NULL);
diff --git a/o2info/utils.c b/o2info/utils.c
index 0911c50..ed980ed 100644
--- a/o2info/utils.c
+++ b/o2info/utils.c
@@ -31,6 +31,81 @@
 
 #include "utils.h"
 
+int o2info_get_compat_flag(uint32_t flag, char **compat)
+{
+	errcode_t err;
+	char buf[PATH_MAX];
+	ocfs2_fs_options flags = {
+		.opt_compat = flag,
+	};
+
+	*buf = '\0';
+	err = ocfs2_snprint_feature_flags(buf, PATH_MAX, &flags);
+	if (err) {
+		tcom_err(err, "while processing feature flags");
+		goto bail;
+	}
+
+	*compat = strdup(buf);
+	if (!*compat) {
+		errorf("No memory for allocation\n");
+		err = -1;
+	}
+
+bail:
+	return err;
+}
+
+int o2info_get_incompat_flag(uint32_t flag, char **incompat)
+{
+	errcode_t err;
+	char buf[PATH_MAX];
+	ocfs2_fs_options flags = {
+		.opt_incompat = flag,
+	};
+
+	*buf = '\0';
+	err = ocfs2_snprint_feature_flags(buf, PATH_MAX, &flags);
+	if (err) {
+		tcom_err(err, "while processing feature flags");
+		goto bail;
+	}
+
+	*incompat = strdup(buf);
+	if (!*incompat) {
+		errorf("No memory for allocation\n");
+		err = -1;
+	}
+
+bail:
+	return err;
+}
+
+int o2info_get_rocompat_flag(uint32_t flag, char **rocompat)
+{
+	errcode_t err;
+	char buf[PATH_MAX];
+	ocfs2_fs_options flags = {
+		.opt_ro_compat = flag,
+	};
+
+	*buf = '\0';
+	err = ocfs2_snprint_feature_flags(buf, PATH_MAX, &flags);
+	if (err) {
+		tcom_err(err, "while processing feature flags");
+		goto bail;
+	}
+
+	*rocompat = strdup(buf);
+	if (!*rocompat) {
+		errorf("No memory for allocation\n");
+		err = -1;
+	}
+
+bail:
+	return err;
+}
+
 errcode_t o2info_open(struct o2info_method *om, int flags)
 {
 	errcode_t err = 0;
diff --git a/o2info/utils.h b/o2info/utils.h
index 6d55d39..69446c2 100644
--- a/o2info/utils.h
+++ b/o2info/utils.h
@@ -22,6 +22,10 @@
 
 #include "o2info.h"
 
+int o2info_get_compat_flag(uint32_t flag, char **compat);
+int o2info_get_incompat_flag(uint32_t flag, char **incompat);
+int o2info_get_rocompat_flag(uint32_t flag, char **rocompat);
+
 int o2info_method(const char *path);
 
 errcode_t o2info_open(struct o2info_method *om, int flags);
-- 
1.5.5
