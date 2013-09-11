From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Wed, 11 Sep 2013 11:40:30 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: ocfs2 dlm umount skip
	migrating lockres
Message-ID: <1378924830-16356-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

umount thread could race with migrate handler thread receiving resource
migration request from other node. When this happens, migrating thread
could set this node as the master along with DLM_LOCK_RES_MIGRATING flag.
umount thread should skip migrating this newly owned lockres until
DLM_LOCK_RES_MIGRATING flag is unset by migrate handler thread. umount
thread will ultimately migrate this lockres during another pass of the
lockres hash list.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com> 
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 33ecbe0..1643b58 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2360,6 +2360,10 @@ static int dlm_is_lockres_migrateable(struct dlm_ctxt *dlm,
 	if (res->owner != dlm->node_num)
 		return 0;
 
+	if (res->state & DLM_LOCK_RES_MIGRATING) {
+		return 0;
+	}
+
         for (idx = DLM_GRANTED_LIST; idx <= DLM_BLOCKED_LIST; idx++) {
 		queue = dlm_list_idx_to_ptr(res, idx);
 		list_for_each_entry(lock, queue, list) {
-- 
1.7.1
