From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 26 Feb 2014 07:19:33 -0600
Subject: [Ocfs2-devel] [PATCH] Add dlm_recover_callback_support in sysfs
Message-ID: <20140226131929.GA3182@shrek.hsd1.tn.comcast.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a part of the nocontrold feature which was incorporated sometime
back.

This is required for backward compatibility of the tools, specifically the
scenario where the tools with recovery callback is used with a kernel
not using the recovery callbacks (older kernel + newer tools). The tools
look for this file to understand if the kernel supports DLM recovery
callbacks.

For kernels which support recovery callbacks but will miss this patch,
ocfs2 will continue to use the older API and would still be able to
mount the filesystem.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
--- 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 1324e66..526e4bc 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -601,11 +601,23 @@ static struct kobj_attribute ocfs2_attr_cluster_stack =
 	       ocfs2_cluster_stack_show,
 	       ocfs2_cluster_stack_store);
 
+static ssize_t ocfs2_dlm_recover_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "1\n");
+}
+
+static struct kobj_attribute ocfs2_attr_dlm_recover_support =
+	__ATTR(dlm_recover_callback_support, S_IFREG | S_IRUGO,
+	       ocfs2_dlm_recover_show, NULL);
+
 static struct attribute *ocfs2_attrs[] = {
 	&ocfs2_attr_max_locking_protocol.attr,
 	&ocfs2_attr_loaded_cluster_plugins.attr,
 	&ocfs2_attr_active_cluster_plugin.attr,
 	&ocfs2_attr_cluster_stack.attr,
+	&ocfs2_attr_dlm_recover_support.attr,
 	NULL,
 };
 

-- 
Goldwyn
