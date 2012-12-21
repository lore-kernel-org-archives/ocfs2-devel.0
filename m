From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 21 Dec 2012 18:29:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG_ON(res->migration_pending) in
 dlm_mark_lockres_migrating
Message-ID: <50D43A19.3070703@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  When dlm_lockres_release_ast() returns without clearing
res->migration_pending, dlm_mark_lockres_migrating() exits abnormally
with res->migration_pending setting to 1. When reentering
dlm_mark_lockres_migrating(), it will trigger the BUG_ON with
res->migration_pending. Clearing migration_pending when target is
down can resolve this issue.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..c491f97 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2751,6 +2751,9 @@ again:
 	if (!test_bit(target, dlm->domain_map)) {
 		mlog(ML_ERROR, "aha. migration target %u just went down\n",
 		     target);
+		spin_lock(&res->spinlock);
+		res->migration_pending = 0;
+		spin_unlock(&res->spinlock);
 		ret = -EHOSTDOWN;
 	}
 	spin_unlock(&dlm->spinlock);
-- 
1.7.8.6
