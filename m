From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  4 Feb 2010 16:55:03 -0800
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2_dlmfs: Enable the use of user
	cluster stacks.
In-Reply-To: <1265331303-19881-1-git-send-email-joel.becker@oracle.com>
References: <1265331303-19881-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1265331303-19881-11-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com

Unlike ocfs2, dlmfs has no permanent storage.  It can't store off a
cluster stack it is supposed to be using.  So it can't specify the stack
name in ocfs2_cluster_connect().

Instead, we create ocfs2_cluster_connect_agnostic(), which simply uses
the stack that is currently enabled.  This is find for dlmfs, which will
rely on the stack initialization.

We add the "stackglue" capability to dlmfs's capability list.  This lets
userspace know dlmfs can be used with all cluster stacks.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c      |    2 +-
 fs/ocfs2/dlmfs/userdlm.c    |    8 ++++----
 fs/ocfs2/ocfs2_lockingver.h |    2 ++
 fs/ocfs2/stackglue.c        |   18 ++++++++++++++++++
 fs/ocfs2/stackglue.h        |   11 +++++++++++
 5 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 3c836d7..dee874d 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -87,7 +87,7 @@ struct workqueue_struct *user_dlm_worker;
  * - bast	: POLLIN against the file descriptor of a held lock
  *		  signifies a bast fired on the lock.
  */
-#define DLMFS_CAPABILITIES "bast"
+#define DLMFS_CAPABILITIES "bast stackglue"
 extern int param_set_dlmfs_capabilities(const char *val,
 					struct kernel_param *kp)
 {
diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 1e2afe4..7c5097c 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -661,10 +661,10 @@ struct ocfs2_cluster_connection *user_dlm_register(struct qstr *name)
 	int rc;
 	struct ocfs2_cluster_connection *conn;
 
-	rc = ocfs2_cluster_connect("o2cb", name->name, name->len,
-				   &user_dlm_lproto,
-				   user_dlm_recovery_handler_noop,
-				   NULL, &conn);
+	rc = ocfs2_cluster_connect_agnostic(name->name, name->len,
+					    &user_dlm_lproto,
+					    user_dlm_recovery_handler_noop,
+					    NULL, &conn);
 	if (rc)
 		mlog_errno(rc);
 
diff --git a/fs/ocfs2/ocfs2_lockingver.h b/fs/ocfs2/ocfs2_lockingver.h
index 82d5eea..2e45c8d 100644
--- a/fs/ocfs2/ocfs2_lockingver.h
+++ b/fs/ocfs2/ocfs2_lockingver.h
@@ -23,6 +23,8 @@
 /*
  * The protocol version for ocfs2 cluster locking.  See dlmglue.c for
  * more details.
+ *
+ * 1.0 - Initial locking version from ocfs2 1.4.
  */
 #define OCFS2_LOCKING_PROTOCOL_MAJOR 1
 #define OCFS2_LOCKING_PROTOCOL_MINOR 0
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 31db2e8..39abf89 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -373,6 +373,24 @@ out:
 }
 EXPORT_SYMBOL_GPL(ocfs2_cluster_connect);
 
+/* The caller will ensure all nodes have the same cluster stack */
+int ocfs2_cluster_connect_agnostic(const char *group,
+				   int grouplen,
+				   struct ocfs2_locking_protocol *lproto,
+				   void (*recovery_handler)(int node_num,
+							    void *recovery_data),
+				   void *recovery_data,
+				   struct ocfs2_cluster_connection **conn)
+{
+	char *stack_name = NULL;
+
+	if (cluster_stack_name[0])
+		stack_name = cluster_stack_name;
+	return ocfs2_cluster_connect(stack_name, group, grouplen, lproto,
+				     recovery_handler, recovery_data, conn);
+}
+EXPORT_SYMBOL_GPL(ocfs2_cluster_connect_agnostic);
+
 /* If hangup_pending is 0, the stack driver will be dropped */
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 			     int hangup_pending)
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index b1981ba..8ce7398 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -246,6 +246,17 @@ int ocfs2_cluster_connect(const char *stack_name,
 						   void *recovery_data),
 			  void *recovery_data,
 			  struct ocfs2_cluster_connection **conn);
+/*
+ * Used by callers that don't store their stack name.  They must ensure
+ * all nodes have the same stack.
+ */
+int ocfs2_cluster_connect_agnostic(const char *group,
+				   int grouplen,
+				   struct ocfs2_locking_protocol *lproto,
+				   void (*recovery_handler)(int node_num,
+							    void *recovery_data),
+				   void *recovery_data,
+				   struct ocfs2_cluster_connection **conn);
 int ocfs2_cluster_disconnect(struct ocfs2_cluster_connection *conn,
 			     int hangup_pending);
 void ocfs2_cluster_hangup(const char *group, int grouplen);
-- 
1.6.6.1
