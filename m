From: alex chen <alex.chen@huawei.com>
Date: Fri, 26 Sep 2014 16:41:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: call dlm_lockres_put without
	resource spinlock
Message-ID: <542526C3.2090302@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_lockres_put should be called without &res->spinlock, otherwise a
deadlock case may happen.

spin_lock(&res->spinlock)
...
dlm_lockres_put
  ->dlm_lockres_release
    ->dlm_print_one_lock_resource
      ->spin_lock(&res->spinlock)

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 45067fa..3365839 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1710,9 +1710,12 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 				BUG();
 			} else
 				__dlm_lockres_grab_inflight_worker(dlm, res);
-		} else /* put.. incase we are not the master */
+			spin_unlock(&res->spinlock);
+		} else {
+			/* put.. incase we are not the master */
+			spin_unlock(&res->spinlock);
 			dlm_lockres_put(res);
-		spin_unlock(&res->spinlock);
+		}
 	}
 	spin_unlock(&dlm->spinlock);

-- 
1.8.4.3
