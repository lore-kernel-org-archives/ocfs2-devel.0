From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:24 2008
Subject: [Ocfs2-devel] [PATCH 16/18] ocfs2_dlm: Small fix regarding
	dlm_print_one_lock_resource()
In-Reply-To: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1203970862-8790-17-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some fucntions were calling __dlm_print_one_lock_resource() instead
of dlm_print_one_lock_resource()

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmconvert.c |    2 +-
 fs/ocfs2/dlm/dlmdebug.c   |    3 ---
 fs/ocfs2/dlm/dlmmaster.c  |    4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

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
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 24d2f5c..2a1c27c 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -67,9 +67,6 @@ static void dlm_print_lockres_refmap(struct dlm_lock_resource *res)
 
 void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 {
-	mlog(ML_NOTICE, "lockres: %.*s, owner=%u, state=%u\n",
-	       res->lockname.len, res->lockname.name,
-	       res->owner, res->state);
 	spin_lock(&res->spinlock);
 	__dlm_print_one_lock_resource(res);
 	spin_unlock(&res->spinlock);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 3d681fe..0af2532 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2283,7 +2283,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 			mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
 		     	"but it is already dropped!\n", dlm->name,
 		     	res->lockname.len, res->lockname.name, node);
-			__dlm_print_one_lock_resource(res);
+			dlm_print_one_lock_resource(res);
 		}
 		ret = 0;
 		goto done;
@@ -2343,7 +2343,7 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 		mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
 		     "but it is already dropped!\n", dlm->name,
 		     res->lockname.len, res->lockname.name, node);
-		__dlm_print_one_lock_resource(res);
+		dlm_print_one_lock_resource(res);
 	}
 
 	dlm_lockres_put(res);
-- 
1.5.2.5
