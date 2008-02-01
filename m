From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Feb  1 16:49:56 2008
Subject: [Ocfs2-devel] [PATCH 03/12] ocfs2_dlm: lockres/lock refcounting
	fixed
In-Reply-To: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
References: <1201913371-1522-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1201913371-1522-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c   |    1 +
 fs/ocfs2/dlm/dlmrecovery.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 939b863..e469e49 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2973,6 +2973,7 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
 				dlm_lockres_clear_refmap_bit(lock->ml.node, res);
 				list_del_init(&lock->list);
 				dlm_lock_put(lock);
+				dlm_lock_put(lock);
 			}
 		}
 		queue++;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 4294d76..ae2b2b6 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1515,6 +1515,8 @@ again:
 	}
 
 leave:
+	if (res)
+		dlm_lockres_put(res);
 	kfree(data);
 	mlog_exit(ret);
 }
@@ -1919,6 +1921,7 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
 		     "Recovering res %s:%.*s, is already on recovery list!\n",
 		     dlm->name, res->lockname.len, res->lockname.name);
 		list_del_init(&res->recovering);
+		dlm_lockres_put(res);
 	}
 	/* We need to hold a reference while on the recovery list */
 	dlm_lockres_get(res);
-- 
1.5.2.5
