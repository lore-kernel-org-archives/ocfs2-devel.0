From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 21 Aug 2013 08:09:45 -0500
Subject: [Ocfs2-devel] [PATCH 2/5] Add clustername while creating new
	lockspace
Message-ID: <20130821130940.GA3999@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Cluster name is required by DLM for cross-checking if the running
stack is the one requester is requesting for. Pass the cluster_name
to cluster_connect.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/dlmglue.c    | 2 ++
 fs/ocfs2/ocfs2.h      | 1 +
 fs/ocfs2/stack_user.c | 3 ++-
 fs/ocfs2/stackglue.c  | 9 +++++++--
 fs/ocfs2/stackglue.h  | 7 +++++++
 fs/ocfs2/super.c      | 3 +++
 6 files changed, 22 insertions(+), 3 deletions(-)

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
index d355e6e..ee56a3d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -388,6 +388,7 @@ struct ocfs2_super
 	u8 osb_stackflags;
 
 	char osb_cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
+	char osb_cluster_name[OCFS2_CLUSTER_NAME_LEN + 1];
 	struct ocfs2_cluster_connection *cconn;
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 1b18193..2ef6ad5 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -847,7 +847,8 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 		goto out;
 	}
 
-	rc = dlm_new_lockspace(conn->cc_name, NULL, DLM_LSFL_FS, DLM_LVB_LEN,
+	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
+			       DLM_LSFL_FS, DLM_LVB_LEN,
 			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
 	if (rc) {
 		ocfs2_live_connection_drop(control);
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..9acee13 100644
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
@@ -344,6 +346,8 @@ int ocfs2_cluster_connect(const char *stack_name,
 
 	memcpy(new_conn->cc_name, group, grouplen);
 	new_conn->cc_namelen = grouplen;
+	memcpy(new_conn->cc_cluster_name, cluster_name, cluster_name_len);
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
index 01b8516..60f3d8e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2239,6 +2239,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 			status = -EINVAL;
 			goto bail;
 		}
+		memcpy(osb->osb_cluster_name,
+			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
+			OCFS2_CLUSTER_NAME_LEN);
 	} else {
 		/* The empty string is identical with classic tools that
 		 * don't know about s_cluster_info. */
-- 
1.8.1.4


-- 
Goldwyn
