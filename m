From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 25 Oct 2010 19:09:49 +0800
Subject: [Ocfs2-devel] [PATCH 5/6] O2info: Add running codes for '--volinfo'.
In-Reply-To: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
References: <1288004990-20076-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1288004990-20076-6-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch teaches o2info to dump volume's basic info.

Task of '--volinfo' will also be capable of two approaches, including
libocfs2 and ioctl solutions.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 o2info/o2info.1.in  |   26 ++++++++-
 o2info/o2info.c     |   15 +++++
 o2info/operations.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+), 1 deletions(-)

diff --git a/o2info/o2info.1.in b/o2info/o2info.1.in
index 2622a8e..a814d54 100644
--- a/o2info/o2info.1.in
+++ b/o2info/o2info.1.in
@@ -2,7 +2,7 @@
 .SH "NAME"
 o2info \- Dump \fIOCFS2\fR file system information on disk.
 .SH "SYNOPSIS"
-\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] [\fB\-\-fs\-features\fR] <\fBdevice or file\fR>
+\fBo2info\fR [\fB\-C|\-\-cluster\-coherent\fR] [\fB\-\-fs\-features\fR] [\fB\-\-volinfo\fR] <\fBdevice or file\fR>
 
 .SH "DESCRIPTION"
 .PP
@@ -18,6 +18,10 @@ Enable cluster (in)coherency for mounted case, means it will attempt to acquire
 List all compat, incompat and ro-compat fs features on \fIOCFS2\fR filesystem.
 
 .TP
+\fB\-\-volinfo\fR
+Dump basic volume information, such as blocksize, clustersize, volume label and UUID etc.
+
+.TP
 \fB\-V, \-\-version\fR
 Show version and exit.
 
@@ -25,6 +29,26 @@ Show version and exit.
 \fB\-h, \-\-help\fR
 Display help and exit.
 
+.SH "EXAMPLES"
+[oracle at node1 ~]# o2info --volinfo /storage/testfile      # For none-privileged users.
+.br
+[root at node1 ~]# o2info --volinfo /dev/sda1
+.br
+       Label: ocfs2-volume
+.br
+        UUID: 976D8E630B3A4F1F95497311A92901FC
+.br
+  Block Size: 4096
+.br
+Cluster Size: 4096
+.br
+  Node Slots: 4
+.br
+    Features: backup-super strict-journal-super sparse inline-data xattr
+.br
+    Features: unwritten
+
+
 .SH "SEE ALSO"
 .BR debugfs.ocfs2(8)
 .BR tunefs.ocfs2(8)
diff --git a/o2info/o2info.c b/o2info/o2info.c
index c91317a..3ad3c90 100644
--- a/o2info/o2info.c
+++ b/o2info/o2info.c
@@ -35,6 +35,7 @@
 #include "utils.h"
 
 extern struct o2info_operation fs_features_op;
+extern struct o2info_operation volinfo_op;
 
 static LIST_HEAD(o2info_op_task_list);
 static int o2info_op_task_count;
@@ -113,11 +114,25 @@ static struct o2info_option fs_features_option = {
 	.opt_private	= NULL,
 };
 
+static struct o2info_option volinfo_option = {
+	.opt_option	= {
+		.name		= "volinfo",
+		.val		= CHAR_MAX,
+		.has_arg	= 0,
+		.flag		= NULL,
+	},
+	.opt_help	= "   --volinfo",
+	.opt_handler	= NULL,
+	.opt_op		= &volinfo_op,
+	.opt_private	= NULL,
+};
+
 static struct o2info_option *options[] = {
 	&help_option,
 	&version_option,
 	&coherency_option,
 	&fs_features_option,
+	&volinfo_option,
 	NULL,
 };
 
diff --git a/o2info/operations.c b/o2info/operations.c
index 3aaf7b5..7d667ae 100644
--- a/o2info/operations.c
+++ b/o2info/operations.c
@@ -284,3 +284,167 @@ out:
 DEFINE_O2INFO_OP(fs_features,
 		 fs_features_run,
 		 NULL);
+
+struct o2info_volinfo {
+	uint32_t blocksize;
+	uint32_t clustersize;
+	uint32_t maxslots;
+	uint8_t label[OCFS2_MAX_VOL_LABEL_LEN];
+	uint8_t uuid_str[OCFS2_TEXT_UUID_LEN + 1];
+	struct o2info_fs_features ofs;
+};
+
+static int get_volinfo_libocfs2(struct o2info_operation *op,
+				ocfs2_filesys *fs,
+				struct o2info_volinfo *vf)
+{
+	int rc = 0;
+	struct ocfs2_super_block *sb = NULL;
+
+	memset(vf, 0, sizeof(*vf));
+
+	sb = OCFS2_RAW_SB(fs->fs_super);
+	vf->blocksize = fs->fs_blocksize;
+	vf->clustersize = fs->fs_clustersize;
+	vf->maxslots = sb->s_max_slots;
+	memcpy(vf->label, sb->s_label, OCFS2_MAX_VOL_LABEL_LEN);
+	memcpy(vf->uuid_str, fs->uuid_str, OCFS2_TEXT_UUID_LEN + 1);
+	rc = get_fs_features_libocfs2(op, fs, &(vf->ofs));
+
+	return rc;
+}
+
+static int get_volinfo_ioctl(struct o2info_operation *op,
+			     int fd,
+			     struct o2info_volinfo *vf)
+{
+	int rc = 0, flags = 0;
+	uint32_t unknowns = 0, errors = 0, fills = 0;
+	struct ocfs2_info_blocksize oib;
+	struct ocfs2_info_clustersize oic;
+	struct ocfs2_info_maxslots oim;
+	struct ocfs2_info_label oil;
+	struct ocfs2_info_uuid oiu;
+	uint64_t reqs[5];
+	struct ocfs2_info info;
+
+	memset(vf, 0, sizeof(*vf));
+
+	if (!cluster_coherent)
+		flags |= OCFS2_INFO_FL_NON_COHERENT;
+
+	o2info_fill_request((struct ocfs2_info_request *)&oib, sizeof(oib),
+			    OCFS2_INFO_BLOCKSIZE, flags);
+	o2info_fill_request((struct ocfs2_info_request *)&oic, sizeof(oic),
+			    OCFS2_INFO_CLUSTERSIZE, flags);
+	o2info_fill_request((struct ocfs2_info_request *)&oim, sizeof(oim),
+			    OCFS2_INFO_MAXSLOTS, flags);
+	o2info_fill_request((struct ocfs2_info_request *)&oil, sizeof(oil),
+			    OCFS2_INFO_LABEL, flags);
+	o2info_fill_request((struct ocfs2_info_request *)&oiu, sizeof(oiu),
+			    OCFS2_INFO_UUID, flags);
+
+	reqs[0] = (unsigned long)&oib;
+	reqs[1] = (unsigned long)&oic;
+	reqs[2] = (unsigned long)&oim;
+	reqs[3] = (unsigned long)&oil;
+	reqs[4] = (unsigned long)&oiu;
+
+	info.oi_requests = (uint64_t)reqs;
+	info.oi_count = 5;
+
+	rc = ioctl(fd, OCFS2_IOC_INFO, &info);
+	if (rc) {
+		rc = errno;
+		o2i_error(op, "ioctl failed: %s\n", strerror(rc));
+		o2i_scan_requests(op, info, &unknowns, &errors, &fills);
+		goto out;
+	}
+
+	if (oib.ib_req.ir_flags & OCFS2_INFO_FL_FILLED)
+		vf->blocksize = oib.ib_blocksize;
+
+	if (oic.ic_req.ir_flags & OCFS2_INFO_FL_FILLED)
+		vf->clustersize = oic.ic_clustersize;
+
+	if (oim.im_req.ir_flags & OCFS2_INFO_FL_FILLED)
+		vf->maxslots = oim.im_max_slots;
+
+	if (oil.il_req.ir_flags & OCFS2_INFO_FL_FILLED)
+		memcpy(vf->label, oil.il_label, OCFS2_MAX_VOL_LABEL_LEN);
+
+	if (oiu.iu_req.ir_flags & OCFS2_INFO_FL_FILLED)
+		memcpy(vf->uuid_str, oiu.iu_uuid_str, OCFS2_TEXT_UUID_LEN + 1);
+
+	rc = get_fs_features_ioctl(op, fd, &(vf->ofs));
+
+out:
+	return rc;
+}
+
+static int volinfo_run(struct o2info_operation *op,
+		       struct o2info_method *om,
+		       void *arg)
+{
+	int rc = 0;
+	static struct o2info_volinfo vf;
+
+	char *compat = NULL;
+	char *incompat = NULL;
+	char *rocompat = NULL;
+	char *features = NULL;
+
+#define VOLINFO "       Label: %s\n" \
+		"        UUID: %s\n" \
+		"  Block Size: %u\n" \
+		"Cluster Size: %u\n" \
+		"  Node Slots: %u\n"
+
+	if (om->om_method == O2INFO_USE_IOCTL)
+		rc = get_volinfo_ioctl(op, om->om_fd, &vf);
+	else
+		rc = get_volinfo_libocfs2(op, om->om_fs, &vf);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_compat_flag(vf.ofs.compat, &compat);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_incompat_flag(vf.ofs.incompat, &incompat);
+	if (rc)
+		goto out;
+
+	rc = o2info_get_rocompat_flag(vf.ofs.rocompat, &rocompat);
+	if (rc)
+		goto out;
+
+	features = malloc(strlen(compat) + strlen(incompat) +
+			  strlen(rocompat) + 3);
+
+	sprintf(features, "%s %s %s", compat, incompat, rocompat);
+
+	fprintf(stdout, VOLINFO, vf.label, vf.uuid_str, vf.blocksize,
+		vf.clustersize, vf.maxslots);
+
+	o2info_print_line("    Features: ", features, ' ');
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
+DEFINE_O2INFO_OP(volinfo,
+		 volinfo_run,
+		 NULL);
-- 
1.5.5
