From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  8 10:50:09 2008
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add CDSL
In-Reply-To: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
References: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1202496577-21982-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is a forward port of the CDSL implementation in OCFS2 1.2.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/symlink.c |  244 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 244 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 9794649..0cc45d0 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -131,6 +131,246 @@ out:
 	return ret;
 }
 
+#ifdef OCFS2_CDSL
+
+struct ocfs2_symlink_ops {
+	const char *name;
+	const unsigned int len;
+	unsigned int (*subst_fn) (char *str, void *data);
+};
+
+/**
+ *** sym_hostname - Substitute system host name
+ *** @str: String for result
+ *** @len: Length of result buffer
+ ***
+ *** Returns: Length of hostname
+ ***/
+static unsigned int
+sym_hostname(char *str, void *data)
+{
+	  unsigned int l = strlen(system_utsname.nodename);
+
+	  if (str)
+		memcpy(str, system_utsname.nodename, l);
+
+	  return l;
+}
+
+/**
+ *** sym_machine - Substitute machine type
+ *** @str: String for result
+ *** @len: Length of result buffer
+ ***
+ *** Returns: Length of machine type
+ ***/
+
+static unsigned int
+sym_machine(char *str, void *data)
+{
+	unsigned int l = strlen(system_utsname.machine);
+
+	if (str)
+	       memcpy(str, system_utsname.machine, l);
+
+	return l;
+}
+
+/**
+ *** sym_os - Substitute OS name
+ *** @str: String for result
+ *** @len: Length of result buffer
+ ***
+ *** Returns: Length of OS name
+ ***/
+
+static unsigned int
+sym_os(char *str, void *data)
+{
+	unsigned int l = strlen(system_utsname.sysname);
+
+	if (str)
+	       memcpy(str, system_utsname.sysname, l);
+
+	return l;
+}
+
+/**
+ *** sym_nodenum - Substitute node number
+ *** @str: String for result
+ *** @len: Length of result buffer
+ ***
+ *** Returns: Length of  nodeNum
+ ***/
+
+static unsigned int
+sym_nodenum(char *str, void *data)
+{
+	unsigned int l;
+	char buf[10];
+	struct inode *inode = data;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	l = sprintf(buf, "%lu", (unsigned long)osb->node_num);
+
+	if (str) {
+	      memcpy(str, buf, l);
+	      str[l] = '\0';
+	}
+
+	return l;
+}
+
+static unsigned int
+sym_system(char *str, void *data)
+{
+	unsigned int ml = strlen(system_utsname.machine);
+	unsigned int sl = strlen(system_utsname.sysname);
+	unsigned int l = ml + sl + 1;
+
+	if (str) {
+	       memcpy(str, system_utsname.machine, ml);
+	       str[ml] = '_';
+	       memcpy(str + ml + 1, system_utsname.sysname, sl);
+	       str[l] = '\0';
+	};
+
+	return l;
+}
+
+static unsigned int
+sym_uid(char *str, void *data)
+{
+	unsigned int l;
+	char buf[10];
+
+	l = sprintf(buf, "%lu", (unsigned long)current->fsuid);
+
+	if (str) {
+	      memcpy(str, buf, l);
+	      str[l] = '\0';
+	}
+
+	return l;
+}
+
+static unsigned int
+sym_gid(char *str, void *data)
+{
+	unsigned int l;
+	char buf[10];
+
+	l = sprintf(buf, "%lu", (unsigned long)current->fsgid);
+
+	if (str) {
+	      memcpy(str, buf, l);
+	      str[l] = '\0';
+	}
+
+	return l;
+}
+
+static struct ocfs2_symlink_ops symlink_ops[] = {
+	{"hostname}", 9, sym_hostname},
+	{"mach}", 5, sym_machine},
+	{"os}", 3, sym_os},
+	{"nodenum}", 8, sym_nodenum},
+	{"sys}", 4, sym_system},
+	{"uid}", 4, sym_uid},
+	{"gid}", 4, sym_gid},
+	{NULL, 0, NULL}
+};
+
+
+/**
+ *** ocfs2_link_expand - Expand a context sensitive symlink
+ *** @ops: The symlink substitution operations table
+ *** @out: Buffer to place result in
+ *** @in: Buffer to get symlink from
+ ***
+ *** Returns: 0 or error code
+ ***/
+
+static void ocfs2_link_expand(struct ocfs2_symlink_ops *ops, char *out, char *in, struct inode *inode)
+{
+	unsigned int i;
+
+	while (*in) {
+		*out++ = *in;
+		if (*in++ != '{')
+			continue;
+
+		for (i = 0; ops[i].name; i++) {
+			if (memcmp(in, ops[i].name, ops[i].len) == 0) {
+				out--;
+				out += ops[i].subst_fn(out, inode);
+				in += ops[i].len;
+			}
+		}
+	}
+
+	*out = 0;
+}
+
+
+/**
+ *** ocfs2_link_size - Return expanded size required to store a symlink
+ *** @str: The symlink
+ *** @ops: The symlink substitution operations table
+ ***
+ *** Returns: The size of the expanded symlink.
+ ***/
+
+
+static unsigned int ocfs2_link_size(struct ocfs2_symlink_ops *ops, char *str, struct inode *inode)
+{
+	unsigned int len = 0;
+	unsigned int i;
+
+	while (*str) {
+		len++;
+		if (*str++ != '{')
+			continue;
+
+		for (i = 0; ops[i].name; i++) {
+			if (memcmp(str, ops[i].name, ops[i].len) == 0) {
+				len--;
+				len += ops[i].subst_fn(NULL, inode);
+				str += ops[i].len;
+				break;
+			}
+		}
+	}
+
+	return len + 1;
+}
+
+static inline int ocfs2_cdsl_follow_link(struct nameidata *nd,
+					 char *old_link,
+					 struct inode *inode)
+{
+	int status;
+	char *new_link;
+	unsigned int len;
+
+	len = ocfs2_link_size(symlink_ops, old_link, inode);
+	new_link = kmalloc(len, GFP_KERNEL);
+	if (new_link == NULL) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
+	ocfs2_link_expand(symlink_ops, new_link, old_link, inode);
+
+	status = vfs_follow_link(nd, new_link);
+
+	kfree(new_link);
+bail:
+	return status;
+}
+#endif
+
 static void *ocfs2_follow_link(struct dentry *dentry,
 			       struct nameidata *nd)
 {
@@ -150,7 +390,11 @@ static void *ocfs2_follow_link(struct dentry *dentry,
 		goto bail;
 	}
 
+#ifdef OCFS2_CDSL
+	status = ocfs2_cdsl_follow_link(nd, link, inode);
+#else
 	status = vfs_follow_link(nd, link);
+#endif
 
 bail:
 	if (page) {
-- 
1.5.2.5
