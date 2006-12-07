From: Zhen Wei <zwei@novell.com>
Date: Thu Dec  7 23:49:43 2006
Subject: [Ocfs2-devel] [patch 2/3]OCFS2: allow the ocfs2 heartbeat thread to
	prioritize I/O --revision 3
Message-ID: <4579B3B70200000400262DAC@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

- replace calling syscall interface with running ionice
- fix the running ionice return code
- use device name instead of uuid for mount.ocfs2

zhen wei
zwei@novell.com
+86 10 65339225

-------------- next part --------------
--- trunk.orig/libocfs2/ocfs2_err.et	2006-12-08 15:09:42.000000000 +0800
+++ trunk/libocfs2/ocfs2_err.et	2006-12-08 15:14:49.000000000 +0800
@@ -159,4 +159,7 @@ ec	OCFS2_ET_BLOCK_SIZE_TOO_SMALL_FOR_HAR
 ec	OCFS2_ET_INVALID_LOCKRES,
 	"The lock name is invalid"
 
+ec	OCFS2_ET_NO_IONICE,
+	"Can't find ionice"
+
 	end
--- trunk.orig/libo2cb/include/o2cb.h	2006-12-08 15:09:42.000000000 +0800
+++ trunk/libo2cb/include/o2cb.h	2006-12-08 15:09:55.000000000 +0800
@@ -98,6 +98,10 @@ errcode_t o2cb_start_heartbeat_region_pe
 errcode_t o2cb_stop_heartbeat_region_perm(const char *cluster_name,
 					  const char *region_name);
 
+errcode_t o2cb_get_hb_thread_pid (const char *cluster_name, 
+				  const char *region_name, 
+				  pid_t *pid);
+
 errcode_t o2cb_get_region_ref(const char *region_name,
 			      int undo);
 errcode_t o2cb_put_region_ref(const char *region_name,
--- trunk.orig/libo2cb/o2cb_abi.c	2006-12-08 15:09:42.000000000 +0800
+++ trunk/libo2cb/o2cb_abi.c	2006-12-08 15:09:55.000000000 +0800
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
--- trunk.orig/ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-12-08 15:09:42.000000000 +0800
+++ trunk/ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-12-08 15:15:24.000000000 +0800
@@ -29,6 +29,7 @@
 #define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
 
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <inttypes.h>
 
 #include <stdio.h>
@@ -53,12 +54,14 @@ enum hb_ctl_action {
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
 
 
@@ -289,6 +292,41 @@ static errcode_t start_heartbeat(struct 
 	return err;
 }
 
+static errcode_t adjust_priority(struct hb_ctl_options *hbo)
+{
+	int ret, child_status;
+	pid_t hb_pid, child_pid;
+	char level_arg[16], pid_arg[16];
+
+	if (access ("/usr/bin/ionice", X_OK) != 0)
+		return OCFS2_ET_NO_IONICE;
+
+	get_uuid (hbo->dev_str, hbo->uuid_str);
+	ret = o2cb_get_hb_thread_pid (NULL, hbo->uuid_str, &hb_pid);
+	if (ret != 0) 
+		return ret;
+
+	child_pid = fork ();
+	if (child_pid == 0) {
+		sprintf (level_arg, "-n%d", hbo->io_prio);
+		sprintf (pid_arg, "-p%d", hb_pid);
+		execlp ("/usr/bin/ionice", "ionice", "-c1", level_arg, pid_arg, NULL);
+
+		ret = errno;
+		exit (ret);
+	} else if (child_pid > 0) {
+		ret = waitpid (child_pid, &child_status, 0);
+		if (ret == 0)
+			ret = WEXITSTATUS(child_status);
+		else
+			ret = errno;
+	} else {
+		ret = errno;
+	}
+
+	return ret;
+}
+
 static errcode_t stop_heartbeat(struct hb_ctl_options *hbo)
 {
 	errcode_t err;
@@ -317,7 +355,7 @@ static int read_options(int argc, char *
 	ret = 0;
 
 	while(1) {
-		c = getopt(argc, argv, "ISKd:u:h");
+		c = getopt(argc, argv, "ISKPd:u:n:h");
 		if (c == -1)
 			break;
 
@@ -334,6 +372,10 @@ static int read_options(int argc, char *
 			hbo->action = HB_ACTION_START;
 			break;
 
+		case 'P':
+			hbo->action = HB_ACTION_IONICE;
+			break;
+
 		case 'd':
 			if (optarg)
 				hbo->dev_str = strdup(optarg);
@@ -344,6 +386,11 @@ static int read_options(int argc, char *
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
@@ -385,6 +432,13 @@ static int process_options(struct hb_ctl
 			ret = -EINVAL;
 		break;
 
+	case HB_ACTION_IONICE:
+		/* ionice needs uuid and priority */
+		if (!hbo->dev_str || hbo->io_prio < 0 ||
+		    hbo->io_prio > 7)
+			ret = -EINVAL;
+		break;
+
 	case HB_ACTION_UNKNOWN:
 		ret = -EINVAL;
 		break;
@@ -407,6 +461,7 @@ static void print_usage(int err)
 	fprintf(output, "       %s -K -u <uuid>\n", progname);
 	fprintf(output, "       %s -I -d <device>\n", progname);
 	fprintf(output, "       %s -I -u <uuid>\n", progname);
+	fprintf(output, "       %s -P -d <device> -n <io_priority>\n", progname);
 	fprintf(output, "       %s -h\n", progname);
 }
 
@@ -414,7 +469,7 @@ int main(int argc, char **argv)
 {
 	errcode_t err = 0;
 	int ret = 0;
-	struct hb_ctl_options hbo = { HB_ACTION_UNKNOWN, NULL, NULL };
+	struct hb_ctl_options hbo = { HB_ACTION_UNKNOWN, NULL, NULL, 0 };
 	char hbuuid[33];
 
 	setbuf(stdout, NULL);
@@ -483,6 +538,14 @@ int main(int argc, char **argv)
 		}
 		break;
 
+	case HB_ACTION_IONICE:
+		err = adjust_priority(&hbo);
+		if (err) {
+			com_err(progname, err, "while adjusting heartbeat thread I/O priority");
+			ret = err;
+		}
+		break;
+
 	case HB_ACTION_REFINFO:
 		err = print_hb_ref_info(&hbo);
 		if (err) {
