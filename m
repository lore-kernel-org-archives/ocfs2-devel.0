From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 20 Dec 2010 16:35:01 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/dlm: Hard code the values for enums
In-Reply-To: <1292891701-5111-1-git-send-email-sunil.mushran@oracle.com>
References: <1292891701-5111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292891701-5111-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In o2dlm, the enumerated message values are part of the protocol.
The patch hard codes each value so as to reduce the chance of an editing
error causing a protocol mismatch.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   86 +++++++++++++++++++++++-----------------------
 1 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index b36d0bf..4bdf7ba 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -50,10 +50,10 @@
 #define dlm_lockid_hash(_n, _l) full_name_hash(_n, _l)
 
 enum dlm_mle_type {
-	DLM_MLE_BLOCK,
-	DLM_MLE_MASTER,
-	DLM_MLE_MIGRATION,
-	DLM_MLE_NUM_TYPES
+	DLM_MLE_BLOCK = 0,
+	DLM_MLE_MASTER = 1,
+	DLM_MLE_MIGRATION = 2,
+	DLM_MLE_NUM_TYPES = 3,
 };
 
 struct dlm_master_list_entry {
@@ -82,8 +82,8 @@ struct dlm_master_list_entry {
 
 enum dlm_ast_type {
 	DLM_AST = 0,
-	DLM_BAST,
-	DLM_ASTUNLOCK
+	DLM_BAST = 1,
+	DLM_ASTUNLOCK = 2,
 };
 
 
@@ -119,9 +119,9 @@ struct dlm_recovery_ctxt
 
 enum dlm_ctxt_state {
 	DLM_CTXT_NEW = 0,
-	DLM_CTXT_JOINED,
-	DLM_CTXT_IN_SHUTDOWN,
-	DLM_CTXT_LEAVING,
+	DLM_CTXT_JOINED = 1,
+	DLM_CTXT_IN_SHUTDOWN = 2,
+	DLM_CTXT_LEAVING = 3,
 };
 
 struct dlm_ctxt
@@ -388,8 +388,8 @@ struct dlm_lock
 
 enum dlm_lockres_list {
 	DLM_GRANTED_LIST = 0,
-	DLM_CONVERTING_LIST,
-	DLM_BLOCKED_LIST
+	DLM_CONVERTING_LIST = 1,
+	DLM_BLOCKED_LIST = 2,
 };
 
 static inline int dlm_lvb_is_empty(char *lvb)
@@ -427,27 +427,27 @@ struct dlm_node_iter
 
 
 enum {
-	DLM_MASTER_REQUEST_MSG    = 500,
-	DLM_UNUSED_MSG1,         /* 501 */
-	DLM_ASSERT_MASTER_MSG,	 /* 502 */
-	DLM_CREATE_LOCK_MSG,	 /* 503 */
-	DLM_CONVERT_LOCK_MSG,	 /* 504 */
-	DLM_PROXY_AST_MSG,	 /* 505 */
-	DLM_UNLOCK_LOCK_MSG,	 /* 506 */
-	DLM_DEREF_LOCKRES_MSG,	 /* 507 */
-	DLM_MIGRATE_REQUEST_MSG, /* 508 */
-	DLM_MIG_LOCKRES_MSG, 	 /* 509 */
-	DLM_QUERY_JOIN_MSG,	 /* 510 */
-	DLM_ASSERT_JOINED_MSG,	 /* 511 */
-	DLM_CANCEL_JOIN_MSG,	 /* 512 */
-	DLM_EXIT_DOMAIN_MSG,	 /* 513 */
-	DLM_MASTER_REQUERY_MSG,	 /* 514 */
-	DLM_LOCK_REQUEST_MSG,	 /* 515 */
-	DLM_RECO_DATA_DONE_MSG,	 /* 516 */
-	DLM_BEGIN_RECO_MSG,	 /* 517 */
-	DLM_FINALIZE_RECO_MSG,	 /* 518 */
-	DLM_QUERY_REGION,	 /* 519 */
-	DLM_QUERY_NODEINFO,	 /* 520 */
+	DLM_MASTER_REQUEST_MSG		= 500,
+	DLM_UNUSED_MSG1			= 501,
+	DLM_ASSERT_MASTER_MSG		= 502,
+	DLM_CREATE_LOCK_MSG		= 503,
+	DLM_CONVERT_LOCK_MSG		= 504,
+	DLM_PROXY_AST_MSG		= 505,
+	DLM_UNLOCK_LOCK_MSG		= 506,
+	DLM_DEREF_LOCKRES_MSG		= 507,
+	DLM_MIGRATE_REQUEST_MSG		= 508,
+	DLM_MIG_LOCKRES_MSG		= 509,
+	DLM_QUERY_JOIN_MSG		= 510,
+	DLM_ASSERT_JOINED_MSG		= 511,
+	DLM_CANCEL_JOIN_MSG		= 512,
+	DLM_EXIT_DOMAIN_MSG		= 513,
+	DLM_MASTER_REQUERY_MSG		= 514,
+	DLM_LOCK_REQUEST_MSG		= 515,
+	DLM_RECO_DATA_DONE_MSG		= 516,
+	DLM_BEGIN_RECO_MSG		= 517,
+	DLM_FINALIZE_RECO_MSG		= 518,
+	DLM_QUERY_REGION		= 519,
+	DLM_QUERY_NODEINFO		= 520,
 };
 
 struct dlm_reco_node_data
@@ -460,19 +460,19 @@ struct dlm_reco_node_data
 enum {
 	DLM_RECO_NODE_DATA_DEAD = -1,
 	DLM_RECO_NODE_DATA_INIT = 0,
-	DLM_RECO_NODE_DATA_REQUESTING,
-	DLM_RECO_NODE_DATA_REQUESTED,
-	DLM_RECO_NODE_DATA_RECEIVING,
-	DLM_RECO_NODE_DATA_DONE,
-	DLM_RECO_NODE_DATA_FINALIZE_SENT,
+	DLM_RECO_NODE_DATA_REQUESTING = 1,
+	DLM_RECO_NODE_DATA_REQUESTED = 2,
+	DLM_RECO_NODE_DATA_RECEIVING = 3,
+	DLM_RECO_NODE_DATA_DONE = 4,
+	DLM_RECO_NODE_DATA_FINALIZE_SENT = 5,
 };
 
 
 enum {
 	DLM_MASTER_RESP_NO = 0,
-	DLM_MASTER_RESP_YES,
-	DLM_MASTER_RESP_MAYBE,
-	DLM_MASTER_RESP_ERROR
+	DLM_MASTER_RESP_YES = 1,
+	DLM_MASTER_RESP_MAYBE = 2,
+	DLM_MASTER_RESP_ERROR = 3,
 };
 
 
@@ -649,9 +649,9 @@ struct dlm_proxy_ast
 #define DLM_MOD_KEY (0x666c6172)
 enum dlm_query_join_response_code {
 	JOIN_DISALLOW = 0,
-	JOIN_OK,
-	JOIN_OK_NO_MAP,
-	JOIN_PROTOCOL_MISMATCH,
+	JOIN_OK = 1,
+	JOIN_OK_NO_MAP = 2,
+	JOIN_PROTOCOL_MISMATCH = 3,
 };
 
 struct dlm_query_join_packet {
-- 
1.7.1
