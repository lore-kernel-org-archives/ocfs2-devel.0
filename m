From: Mark Fasheh <mfasheh@suse.de>
Date: Wed, 28 Jan 2015 14:12:05 -0800
Subject: [Ocfs2-devel] [PATCH 3/6] Auto setup cluster_stack based on what is
	on disk
In-Reply-To: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
References: <1422483128-32471-1-git-send-email-mfasheh@suse.de>
Message-ID: <1422483128-32471-4-git-send-email-mfasheh@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

This happens only the first time.
mount.ocfs2 reads the stack from the filesystems superblock. If the
stack is not setup, it will modprobe the modules and write the
appropriate stack name to cluster_stack file.
If it is already present, it tries to edit/re-write it, if different.
If it fails, the mount fails.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 include/o2cb/o2cb.h       |   1 +
 libo2cb/o2cb_abi.c        | 106 ++++++++++++++++++++++++++++++++++++++++++++++
 mount.ocfs2/mount.ocfs2.c |   6 +++
 3 files changed, 113 insertions(+)

diff --git a/include/o2cb/o2cb.h b/include/o2cb/o2cb.h
index d512cf9..5ef9754 100644
--- a/include/o2cb/o2cb.h
+++ b/include/o2cb/o2cb.h
@@ -208,5 +208,6 @@ void o2cb_control_close(void);
 errcode_t o2cb_control_node_down(const char *uuid, unsigned int nodeid);
 
 errcode_t o2cb_get_hb_ctl_path(char *buf, int count);
+errcode_t o2cb_setup_stack(char *stack_name);
 
 #endif  /* _O2CB_H */
diff --git a/libo2cb/o2cb_abi.c b/libo2cb/o2cb_abi.c
index 2867fea..4414ff2 100644
--- a/libo2cb/o2cb_abi.c
+++ b/libo2cb/o2cb_abi.c
@@ -29,6 +29,7 @@
 #include <sys/ioctl.h>
 #include <sys/ipc.h>
 #include <sys/sem.h>
+#include <sys/wait.h>
 #include <dirent.h>
 #include <fcntl.h>
 #include <unistd.h>
@@ -150,6 +151,22 @@ static ssize_t read_single_line_file(const char *file, char *line,
 	return ret;
 }
 
+static int write_single_line_file(char *filename, char *line, size_t count)
+{
+	ssize_t ret = 0;
+	FILE *f;
+
+	f = fopen(filename, "w");
+	if (f) {
+		if (fputs(line, f))
+			ret = strlen(line);
+		fclose(f);
+	} else
+		ret = -errno;
+
+	return ret;
+}
+
 static ssize_t read_stack_file(char *line, size_t count)
 {
 	return read_single_line_file(CLUSTER_STACK_FILE, line, count);
@@ -2582,3 +2599,92 @@ errcode_t o2cb_get_hb_ctl_path(char *buf, int count)
 
 	return 0;
 }
+
+#define MODPROBE_COMMAND	"/sbin/modprobe"
+#define USER_KERNEL_MODULE	"ocfs2_stack_user"
+#define O2CB_KERNEL_MODULE	"ocfs2_stack_o2cb"
+
+static int perform_modprobe(char *module_name)
+{
+	pid_t child;
+	int child_status;
+
+	char *argv[3];
+
+	argv[0] = MODPROBE_COMMAND;
+	argv[1] = module_name;
+	argv[2] = NULL;
+
+	child = fork();
+	if (child == 0) {
+		execv(MODPROBE_COMMAND, argv);
+		/* If execv fails, we have a problem */
+		return -EINVAL;
+	} else
+		wait(&child_status);
+
+	return child_status;
+}
+
+errcode_t o2cb_setup_stack(char *stack_name)
+{
+	char line[64];
+	int modprobe_performed = 0, write_performed = 0;
+	errcode_t err = O2CB_ET_SERVICE_UNAVAILABLE;
+	int len;
+
+redo:
+	len = read_single_line_file(CLUSTER_STACK_FILE, line, sizeof(line));
+
+	if (len > 0) {
+		if (line[len - 1] == '\n') {
+			line[len - 1] = '\0';
+			len--;
+		}
+
+		if (len != OCFS2_STACK_LABEL_LEN) {
+			err = O2CB_ET_INTERNAL_FAILURE;
+			goto out;
+		}
+
+		if (!strncmp(line, stack_name, OCFS2_STACK_LABEL_LEN)) {
+			err = 0;
+			goto out;
+		}
+
+		if (!write_performed) {
+			len = write_single_line_file(CLUSTER_STACK_FILE,
+					stack_name, strlen(stack_name));
+			if (len < 0)
+				goto out;
+			write_performed = 1;
+			goto redo;
+		}
+
+	} else if (len == -ENOENT) {
+		if (!modprobe_performed) {
+			perform_modprobe("ocfs2");
+			if ((!strncmp(stack_name, OCFS2_PCMK_CLUSTER_STACK,
+						OCFS2_STACK_LABEL_LEN)) ||
+				(!strncmp(stack_name, OCFS2_CMAN_CLUSTER_STACK,
+						OCFS2_STACK_LABEL_LEN)))
+				perform_modprobe(USER_KERNEL_MODULE);
+			else if (!strncmp(stack_name, classic_stack.s_name,
+						OCFS2_STACK_LABEL_LEN))
+				perform_modprobe(O2CB_KERNEL_MODULE);
+
+			write_single_line_file(CLUSTER_STACK_FILE, stack_name,
+					OCFS2_STACK_LABEL_LEN);
+			write_performed = 1;
+			goto redo;
+		} else
+			err = O2CB_ET_INTERNAL_FAILURE;
+	} else {
+		err = O2CB_ET_INTERNAL_FAILURE;
+		goto out;
+	}
+
+	err = 0;
+out:
+	return err;
+}
diff --git a/mount.ocfs2/mount.ocfs2.c b/mount.ocfs2/mount.ocfs2.c
index 2fa2c2f..a1c8698 100644
--- a/mount.ocfs2/mount.ocfs2.c
+++ b/mount.ocfs2/mount.ocfs2.c
@@ -358,6 +358,12 @@ int main(int argc, char **argv)
 	if (verbose)
 		printf("device=%s\n", mo.dev);
 
+	ret = o2cb_setup_stack((char *)OCFS2_RAW_SB(fs->fs_super)->s_cluster_info.ci_stack);
+	if (ret) {
+		com_err(progname, ret, "while setting up stack\n");
+		goto bail;
+	}
+
 	if (clustered) {
 		ret = o2cb_init();
 		if (ret) {
-- 
2.1.2
