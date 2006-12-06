From: Zhen Wei <zwei@novell.com>
Date: Wed Dec  6 18:38:45 2006
Subject: [Ocfs2-devel] [patch 2/2]OCFS2: allow the ocfs2 heartbeat thread to
	prioritize I/O
Message-ID: <4578193D0200000400262C06@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zhen Wei <zwei@novell.com>
Subject: allow the ocfs2 heartbeat thread to prioritize I/O
Patch-mainline: ocfs2-1.2.2

The patch allows the ocfs2 heartbeat thread to prioritize I/O which may
help cut down on spurious fencing. Most of this will be in the tools -
we can have a pid configfs attribute and let userspace (ocfs2_hb_ctl)
calls the ioprio_set syscall after starting heartbeat, but only cfq
scheduler supports I/O priorities now.

Signed-off-by: Zhen Wei <zwei@novell.com>

zhen wei
zwei@novell.com
+86 10 65339225
Novell, Inc.

-------------- next part --------------
--- /tmp/ocfs2-tools-1.2.2/libocfs2/ocfs2_err.et	2006-10-20 01:10:46.000000000 +0800
+++ libocfs2/ocfs2_err.et	2006-12-07 09:52:28.000000000 +0800
@@ -159,4 +159,7 @@ ec	OCFS2_ET_BLOCK_SIZE_TOO_SMALL_FOR_HAR
 ec	OCFS2_ET_INVALID_LOCKRES,
 	"The lock name is invalid"
 
+ec	OCFS2_ET_UNSUPPORTED_SYSCALL,
+	"Unsupported system call"
+
 	end
--- /tmp/ocfs2-tools-1.2.2/libo2cb/o2cb_abi.c	2006-10-20 01:10:53.000000000 +0800
+++ libo2cb/o2cb_abi.c	2006-12-06 16:10:56.000000000 +0800
@@ -1257,6 +1257,36 @@ void o2cb_free_nodes_list(char **nodes)
 	o2cb_free_dir_list(nodes);
 }
 
+errcode_t o2cb_get_hb_thread_pid (const char *cluster_name, const char *region_name,
+			   pid_t *pid)
+{
+	char attr_path[PATH_MAX];
+	char _fake_cluster_name[NAME_MAX];
+	char attr_value[16];
+	errcode_t ret;
+
+	if (!cluster_name) {
+		ret = _fake_default_cluster(_fake_cluster_name);
+		if (ret)
+			return ret;
+		cluster_name = _fake_cluster_name;
+	}
+
+	ret = snprintf(attr_path, PATH_MAX - 1,
+		       O2CB_FORMAT_HEARTBEAT_REGION_ATTR,
+		       configfs_path, cluster_name, region_name,
+		       "pid");
+
+	if ((ret <= 0) || (ret == (PATH_MAX - 1)))
+		return O2CB_ET_INTERNAL_FAILURE;
+
+	ret = o2cb_get_attribute(attr_path, attr_value, sizeof(attr_value) - 1);
+	if (ret == 0)
+		*pid = atoi (attr_value);
+
+	return ret;
+}
+
 errcode_t o2cb_get_node_num(const char *cluster_name, const char *node_name,
 			    uint16_t *node_num)
 {
--- /tmp/ocfs2-tools-1.2.2/ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-10-20 01:10:46.000000000 +0800
+++ ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-12-07 10:04:10.000000000 +0800
@@ -29,6 +29,7 @@
 #define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
 
 #include <sys/types.h>
+#include <asm/unistd.h>
 #include <inttypes.h>
 
 #include <stdio.h>
@@ -47,18 +48,56 @@
 #define DEV_PREFIX      "/dev/"
 #define PROC_IDE_FORMAT "/proc/ide/%s/media"
 
+extern int ioprio_set(int, int, int);
+extern int ioprio_get(int, int);
+
+#if defined(__i386__)
+#define __NR_ioprio_set         289
+#define __NR_ioprio_get         290
+#elif defined(__ppc__)
+#define __NR_ioprio_set         273
+#define __NR_ioprio_get         274
+#elif defined(__x86_64__)
+#define __NR_ioprio_set         251
+#define __NR_ioprio_get         252
+#elif defined(__ia64__)
+#define __NR_ioprio_set         1274
+#define __NR_ioprio_get         1275
+#else
+#error "Unsupported arch"
+#endif
+
+_syscall3(int, ioprio_set, int, which, int, who, int, ioprio);
+_syscall2(int, ioprio_get, int, which, int, who);
+
+enum {
+        IOPRIO_CLASS_NONE,
+        IOPRIO_CLASS_RT,
+        IOPRIO_CLASS_BE,
+        IOPRIO_CLASS_IDLE,
+};
+
+enum {
+        IOPRIO_WHO_PROCESS = 1,
+        IOPRIO_WHO_PGRP,
+        IOPRIO_WHO_USER,
+};
+#define IOPRIO_CLASS_SHIFT      13
+
 enum hb_ctl_action {
 	HB_ACTION_UNKNOWN,
 	HB_ACTION_USAGE,
 	HB_ACTION_START,
 	HB_ACTION_STOP,
 	HB_ACTION_REFINFO,
+	HB_ACTION_IONICE,
 };
 
 struct hb_ctl_options {
 	enum hb_ctl_action action;
 	char *dev_str;
 	char *uuid_str;
+	int  io_prio;
 };
 
 
@@ -289,6 +328,22 @@ static errcode_t start_heartbeat(struct 
 	return err;
 }
 
+static errcode_t adjust_priority(struct hb_ctl_options *hbo)
+{
+	int ret;
+	pid_t pid;
+
+	ret = o2cb_get_hb_thread_pid (NULL, hbo->uuid_str, &pid);
+	if (ret == 0) {
+		if (ioprio_set(IOPRIO_WHO_PROCESS, pid, hbo->io_prio | 
+			    IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT) == -1) {
+			ret = OCFS2_ET_UNSUPPORTED_SYSCALL;
+		}
+	}
+
+	return ret;
+}
+
 static errcode_t stop_heartbeat(struct hb_ctl_options *hbo)
 {
 	errcode_t err;
@@ -317,7 +372,7 @@ static int read_options(int argc, char *
 	ret = 0;
 
 	while(1) {
-		c = getopt(argc, argv, "ISKd:u:h");
+		c = getopt(argc, argv, "ISKPd:u:n:h");
 		if (c == -1)
 			break;
 
@@ -334,6 +389,10 @@ static int read_options(int argc, char *
 			hbo->action = HB_ACTION_START;
 			break;
 
+		case 'P':
+			hbo->action = HB_ACTION_IONICE;
+			break;
+
 		case 'd':
 			if (optarg)
 				hbo->dev_str = strdup(optarg);
@@ -344,6 +403,11 @@ static int read_options(int argc, char *
 				hbo->uuid_str = strdup(optarg);
 			break;
 
+		case 'n':
+			if (optarg)
+				hbo->io_prio = atoi(optarg);
+			break;
+
 		case 'I':
 			hbo->action = HB_ACTION_REFINFO;
 			break;
@@ -385,6 +449,13 @@ static int process_options(struct hb_ctl
 			ret = -EINVAL;
 		break;
 
+	case HB_ACTION_IONICE:
+		/* ionice needs uuid and priority */
+		if (!hbo->uuid_str || hbo->io_prio < 0 ||
+		    hbo->io_prio > 7)
+			ret = -EINVAL;
+		break;
+
 	case HB_ACTION_UNKNOWN:
 		ret = -EINVAL;
 		break;
@@ -407,6 +478,7 @@ static void print_usage(int err)
 	fprintf(output, "       %s -K -u <uuid>\n", progname);
 	fprintf(output, "       %s -I -d <device>\n", progname);
 	fprintf(output, "       %s -I -u <uuid>\n", progname);
+	fprintf(output, "       %s -P -u <uuid> -n <io_priority>\n", progname);
 	fprintf(output, "       %s -h\n", progname);
 }
 
@@ -414,7 +486,7 @@ int main(int argc, char **argv)
 {
 	errcode_t err = 0;
 	int ret = 0;
-	struct hb_ctl_options hbo = { HB_ACTION_UNKNOWN, NULL, NULL };
+	struct hb_ctl_options hbo = { HB_ACTION_UNKNOWN, NULL, NULL, 0 };
 	char hbuuid[33];
 
 	setbuf(stdout, NULL);
@@ -483,6 +555,14 @@ int main(int argc, char **argv)
 		}
 		break;
 
+	case HB_ACTION_IONICE:
+		err = adjust_priority(&hbo);
+		if (err) {
+			com_err(progname, err, "while adjusting heartbeat thread I/O priority");
+			ret = -EINVAL;
+		}
+		break;
+
 	case HB_ACTION_REFINFO:
 		err = print_hb_ref_info(&hbo);
 		if (err) {
