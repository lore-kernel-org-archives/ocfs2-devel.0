From: xuejiufei <xuejiufei@huawei.com>
Date: Thu, 24 Dec 2015 15:20:27 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: clear migration_pending when
 migration target goes down
Message-ID: <567B9CBB.7000904@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have found a BUG on res->migration_pending when migrating
lock resources. The situation is as follows.

dlm_mark_lockres_migration
  res->migration_pending = 1;
  __dlm_lockres_reserve_ast
  dlm_lockres_release_ast returns with res->migration_pending remains
      because other threads reserve asts
  wait dlm_migration_can_proceed returns 1
  >>>>>>> o2hb found that target goes down and remove target
          from domain_map
  dlm_migration_can_proceed returns 1
  dlm_mark_lockres_migrating returns -ESHOTDOWN with
      res->migration_pending still remains.

When reentering dlm_mark_lockres_migrating(), it will trigger
the BUG_ON with res->migration_pending. So clear migration_pending
when target is down.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index c43da7f..936e11b 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2843,6 +2843,8 @@ again:
 	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
 	if (!ret)
 		BUG_ON(!(res->state & DLM_LOCK_RES_MIGRATING));
+	else
+		res->migration_pending = 0;
 	spin_unlock(&res->spinlock);

 	/*
-- 
1.8.4.3
