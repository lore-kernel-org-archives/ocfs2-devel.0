From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 18 Dec 2015 11:26:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: return appropriate value when
 dlm_grab() returns NULL
Message-ID: <56737CF5.8070304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Function dlm_grab() may return NULL when the node is doing unmount.
When doing code review, we found that some dlm handlers may return
error to caller when dlm_grab() returns NULL and make caller
BUG or other problems. Here is an example:

Node 1                                 Node 2
receives migration message
from node 3, and send
migrate request to others
                                     start unmounting

                                     receives migrate request
                                     from node 1 and call
                                     dlm_migrate_request_handler()

                                     unmount thread unregisters
                                     domain handlers and removes
                                     dlm_context from dlm_domains
      
                                     dlm_migrate_request_handlers()
                                     returns -EINVAL to node 1
Exit migration neither clearing the
migration state nor sending
assert master message to node 3 which
cause node 3 hung.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 2 +-
 fs/ocfs2/dlm/dlmunlock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index ce38b4c..c43da7f 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3048,7 +3048,7 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 	int ret = 0;
 
 	if (!dlm_grab(dlm))
-		return -EINVAL;
+		return 0;
 
 	name = migrate->name;
 	namelen = migrate->namelen;
diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 2e3c9db..1082b2c 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -421,7 +421,7 @@ int dlm_unlock_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 
 	if (!dlm_grab(dlm))
-		return DLM_REJECTED;
+		return DLM_FORWARD;
 
 	mlog_bug_on_msg(!dlm_domain_fully_joined(dlm),
 			"Domain %s not fully joined!\n", dlm->name);
-- 
1.8.4.3
