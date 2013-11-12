From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 12 Nov 2013 08:06:31 -0600
Subject: [Ocfs2-devel] [PATCH 1/6] Add clustername to cluster connection
Message-ID: <20131112140627.GA3928@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/dlmglue.c   |  2 ++
 fs/ocfs2/ocfs2.h     |  1 +
 fs/ocfs2/stackglue.c | 11 ++++++++---
 fs/ocfs2/stackglue.h |  7 +++++++
 fs/ocfs2/super.c     |  8 +++++---
 5 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3a44a64..7c57de3 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2996,6 +2996,8 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 
 	/* for now, uuid == domain */
 	status = ocfs2_cluster_connect(osb->osb_cluster_stack,
+				       osb->osb_cluster_name,
+				       strlen(osb->osb_cluster_name),
 				       osb->uuid_str,
 				       strlen(osb->uuid_str),
 				       &lproto, ocfs2_do_node_down, osb,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3a90347..553f53c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -387,6 +387,7 @@ struct ocfs2_super
 	u8 osb_stackflags;
 
 	char osb_cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
+	char osb_cluster_name[OCFS2_CLUSTER_NAME_LEN + 1];
 	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..58b53f9 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -309,6 +309,8 @@ int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
 EXPORT_SYMBOL_GPL(ocfs2_plock);
 
 int ocfs2_cluster_connect(const char *stack_name,
+			  const char *cluster_name,
+			  int cluster_name_len,
 			  const char *group,
 			  int grouplen,
 			  struct ocfs2_locking_protocol *lproto,
@@ -342,8 +344,10 @@ int ocfs2_cluster_connect(const char *stack_name,
 		goto out;
 	}
 
-	memcpy(new_conn->cc_name, group, grouplen);
+	strlcpy(new_conn->cc_name, group, grouplen + 1);
 	new_conn->cc_namelen = grouplen;
+	strlcpy(new_conn->cc_cluster_name, cluster_name, cluster_name_len + 1);
+	new_conn->cc_cluster_name_len = cluster_name_len;
 	new_conn->cc_recovery_handler = recovery_handler;
 	new_conn->cc_recovery_data = recovery_data;
 
@@ -386,8 +390,9 @@ int ocfs2_cluster_connect_agnostic(const char *group,
 
 	if (cluster_stack_name[0])
 		stack_name = cluster_stack_name;
-	return ocfs2_cluster_connect(stack_name, group, grouplen, lproto,
-				     recovery_handler, recovery_data, conn);
+	return ocfs2_cluster_connect(stack_name, NULL, 0, group, grouplen,
+				     lproto, recovery_handler, recovery_data,
+				     conn);
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_connect_agnostic);
 
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 1ec56fd..b46fd51 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -45,6 +45,9 @@ struct file_lock;
  */
 #define GROUP_NAME_MAX		64
 
+/* This shadows  OCFS2_CLUSTER_NAME_LEN */
+#define CLUSTER_NAME_MAX	16
+
 
 /*
  * ocfs2_protocol_version changes when ocfs2 does something different in
@@ -99,6 +102,8 @@ struct ocfs2_locking_protocol {
 struct ocfs2_cluster_connection {
 	char cc_name[GROUP_NAME_MAX];
 	int cc_namelen;
+	char cc_cluster_name[CLUSTER_NAME_MAX];
+	int cc_cluster_name_len;
 	struct ocfs2_protocol_version cc_version;
 	struct ocfs2_locking_protocol *cc_proto;
 	void (*cc_recovery_handler)(int node_num, void *recovery_data);
@@ -239,6 +244,8 @@ struct ocfs2_stack_plugin {
 
 /* Used by the filesystem */
 int ocfs2_cluster_connect(const char *stack_name,
+			  const char *cluster_name,
+			  int cluster_name_len,
 			  const char *group,
 			  int grouplen,
 			  struct ocfs2_locking_protocol *lproto,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 121da2d..33beb99 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2225,10 +2225,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	if (ocfs2_clusterinfo_valid(osb)) {
 		osb->osb_stackflags =
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_stackflags;
-		memcpy(osb->osb_cluster_stack,
+		strlcpy(osb->osb_cluster_stack,
 		       OCFS2_RAW_SB(di)->s_cluster_info.ci_stack,
-		       OCFS2_STACK_LABEL_LEN);
-		osb->osb_cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
+		       OCFS2_STACK_LABEL_LEN + 1);
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
@@ -2237,6 +2236,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			status = -EINVAL;
 			goto bail;
 		}
+		strlcpy(osb->osb_cluster_name,
+			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
+			OCFS2_CLUSTER_NAME_LEN + 1);
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
-- 
1.8.1.4


-- 
Goldwyn
