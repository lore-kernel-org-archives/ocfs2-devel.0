From: Zhen Wei <zwei@novell.com>
Date: Sat Dec  9 22:46:56 2006
Subject: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=EF=BC=9A=20[Ocfs2-devel]=20[patch?=
	=?UTF-8?Q?=202/3]OCFS2:=20allow=20the=20ocfs2=20heartbeat=20thread=20to?=
	=?UTF-8?Q?=20prioritize=20I/O=20--revision=204?=
Message-ID: <457C47F90200000400262EEC@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hi, Mark:
according your suggestion, I modified the patch:
- define the "/usr/bin/ionice" path
- verify the input args like other option
- remove the printing errors code 

zhen wei
zwei@novell.com
+86 10 65339225

>>> Mark Fasheh <mark.fasheh@oracle.com> 06?12?09? ?? 9:20 >>>
Hi Zwei,

On Fri, Dec 08, 2006 at 12:48:26AM -0700, Zhen Wei wrote:
> - replace calling syscall interface with running ionice
> - fix the running ionice return code
> - use device name instead of uuid for mount.ocfs2

The kernel patch and the mount.ocfs2 patches look good. I only have a couple
of comments for this one below.


> @@ -289,6 +292,41 @@ static errcode_t start_heartbeat(struct 
>  	return err;
>  }
>  
> +static errcode_t adjust_priority(struct hb_ctl_options *hbo)
> +{
> +	int ret, child_status;
> +	pid_t hb_pid, child_pid;
> +	char level_arg[16], pid_arg[16];
> +
> +	if (access ("/usr/bin/ionice", X_OK) != 0)

You might want to make "/usr/bin/ionice" a #define at the top of this file,
since we use it at least twice.


> +		return OCFS2_ET_NO_IONICE;
> +
> +	get_uuid (hbo->dev_str, hbo->uuid_str);

You shouldn't have to call get_uuid() here -- see my comments below.


> @@ -385,6 +432,13 @@ static int process_options(struct hb_ctl
>  			ret = -EINVAL;
>  		break;
>  
> +	case HB_ACTION_IONICE:
> +		/* ionice needs uuid and priority */
> +		if (!hbo->dev_str || hbo->io_prio < 0 ||
> +		    hbo->io_prio > 7)
> +			ret = -EINVAL;
> +		break;

The ionice option should be just like the other options and allow the user
to specify an uuid _or_ a device. The main function will call get_uuid() if
the device was specified.

This will also help avoid the manual call to get_uuid() you have up in
adjust_priority().


> @@ -483,6 +538,14 @@ int main(int argc, char **argv)
>  		}
>  		break;
>  
> +	case HB_ACTION_IONICE:
> +		err = adjust_priority(&hbo);
> +		if (err) {
> +			com_err(progname, err, "while adjusting heartbeat thread I/O priority");
> +			ret = err;
> +		}

You're still printing errors unconditionally.

To break it down, the two errors we don't want to print for are:

* Not finding that the heartbeat region 'pid' attribute exists in configfs.
  (Should be an O2CB_ET_SERVICE_UNAVAILABLE return)

* Not being able to run /usr/bin/ionice because it doesn't exist.
  (Should be an OCFS2_ET_NO_IONICE return)

Neither of those two errors should be fatal, or should print to the user.
You'll have to filter them from the com_err.

Right now the rule is that all versions of ocfs2-tools must be compatible
with old versions of the file system module.

Thanks for the patches so far,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

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
+++ trunk/ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-12-10 14:24:41.000000000 +0800
@@ -29,6 +29,7 @@
 #define _GNU_SOURCE /* Because libc really doesn't want us using O_DIRECT? */
 
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <inttypes.h>
 
 #include <stdio.h>
@@ -46,6 +47,7 @@
 
 #define DEV_PREFIX      "/dev/"
 #define PROC_IDE_FORMAT "/proc/ide/%s/media"
+#define IONICE_PATH	"/usr/bin/ionice"
 
 enum hb_ctl_action {
 	HB_ACTION_UNKNOWN,
@@ -53,12 +55,14 @@ enum hb_ctl_action {
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
 
 
@@ -289,6 +293,40 @@ static errcode_t start_heartbeat(struct 
 	return err;
 }
 
+static errcode_t adjust_priority(struct hb_ctl_options *hbo)
+{
+	int ret, child_status;
+	pid_t hb_pid, child_pid;
+	char level_arg[16], pid_arg[16];
+
+	if (access (IONICE_PATH, X_OK) != 0)
+		return OCFS2_ET_NO_IONICE;
+
+	ret = o2cb_get_hb_thread_pid (NULL, hbo->uuid_str, &hb_pid);
+	if (ret != 0) 
+		return ret;
+
+	child_pid = fork ();
+	if (child_pid == 0) {
+		sprintf (level_arg, "-n%d", hbo->io_prio);
+		sprintf (pid_arg, "-p%d", hb_pid);
+		execlp (IONICE_PATH, "ionice", "-c1", level_arg, pid_arg, NULL);
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
@@ -385,6 +432,14 @@ static int process_options(struct hb_ctl
 			ret = -EINVAL;
 		break;
 
+	case HB_ACTION_IONICE:
+		/* ionice needs uuid and priority */
+		if ((hbo->uuid_str && hbo->dev_str) ||
+		    (!hbo->uuid_str && !hbo->dev_str) ||
+		    hbo->io_prio < 0 || hbo->io_prio > 7)
+			ret = -EINVAL;
+		break;
+
 	case HB_ACTION_UNKNOWN:
 		ret = -EINVAL;
 		break;
@@ -407,6 +462,8 @@ static void print_usage(int err)
 	fprintf(output, "       %s -K -u <uuid>\n", progname);
 	fprintf(output, "       %s -I -d <device>\n", progname);
 	fprintf(output, "       %s -I -u <uuid>\n", progname);
+	fprintf(output, "       %s -P -d <device> [-n <io_priority>]\n", progname);
+	fprintf(output, "       %s -P -u <uuid> [-n <io_priority>]\n", progname);
 	fprintf(output, "       %s -h\n", progname);
 }
 
@@ -414,7 +471,7 @@ int main(int argc, char **argv)
 {
 	errcode_t err = 0;
 	int ret = 0;
-	struct hb_ctl_options hbo = { HB_ACTION_UNKNOWN, NULL, NULL };
+	struct hb_ctl_options hbo = { HB_ACTION_UNKNOWN, NULL, NULL, 0 };
 	char hbuuid[33];
 
 	setbuf(stdout, NULL);
@@ -483,6 +540,12 @@ int main(int argc, char **argv)
 		}
 		break;
 
+	case HB_ACTION_IONICE:
+		err = adjust_priority(&hbo);
+		if (err) 
+			ret = err;
+		break;
+
 	case HB_ACTION_REFINFO:
 		err = print_hb_ref_info(&hbo);
 		if (err) {
