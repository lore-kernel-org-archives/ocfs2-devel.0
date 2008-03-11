From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:22 2008
Subject: [Ocfs2-devel] [PATCH 10/18] ocfs2: Use dlm_print_one_lock_resource
	for lock resource print
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-11-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 2af37ce82d199d1d8cd6286f42f37d321627a807
Author: Tao Ma <tao.ma@oracle.com>
Date: Thu, 28 Feb 2008 10:41:55 +0800

__dlm_print_one_lock_resource must be called with spin_lock
the res->spinlock. While in some cases, we use it without this
precondition and lead to the failure of assert_spin_locked.
So call dlm_print_one_lock_resource instead.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmconvert.c  |    2 +-
 fs/ocfs2/dlm/dlmmaster.c   |    4 ++--
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index ecb4d99..75997b4 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -487,7 +487,7 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 			       "cookie=%u:%llu\n",
 		     dlm_get_lock_cookie_node(be64_to_cpu(cnv->cookie)),
 		     dlm_get_lock_cookie_seq(be64_to_cpu(cnv->cookie)));
-		__dlm_print_one_lock_resource(res);
+		dlm_print_one_lock_resource(res);
 		goto leave;
 	}
 
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index da627c8..5b27581 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2348,7 +2348,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 			mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
 		     	"but it is already dropped!\n", dlm->name,
 		     	res->lockname.len, res->lockname.name, node);
-			__dlm_print_one_lock_resource(res);
+			dlm_print_one_lock_resource(res);
 		}
 		ret = 0;
 		goto done;
@@ -2408,7 +2408,7 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 		mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
 		     "but it is already dropped!\n", dlm->name,
 		     res->lockname.len, res->lockname.name, node);
-		__dlm_print_one_lock_resource(res);
+		dlm_print_one_lock_resource(res);
 	}
 
 	dlm_lockres_put(res);
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 796fb73..3004f95 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1191,7 +1191,7 @@ static int dlm_add_lock_to_array(struct dlm_lock *lock,
 			    (ml->type == LKM_EXMODE ||
 			     memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))) {
 				mlog(ML_ERROR, "mismatched lvbs!\n");
-				__dlm_print_one_lock_resource(lock->lockres);
+				dlm_print_one_lock_resource(lock->lockres);
 				BUG();
 			}
 			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
-- 
1.5.3.4
