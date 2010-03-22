From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 22 Mar 2010 16:50:47 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] dlm: fix a race in lockres mastery
Message-ID: <1269301847-32101-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_assert_master_handler, spinlock is released little sooner which creates
a window for two nodes to race during mastery.

In a scenario where node A had a head start during lock mastery and dlm
spinlock is just released on node B in dlm_assert_master_handler. Right then
a process on node B started to master the resource. It finds the mle but
doesn't find lockres. Since mle *master* is not set it creates a lockres and
waits for the mastery and doesn't send a master request.

dlm_assert_master_handler doesn't know about this and doesn't set
have_lockres_ref(doesn't set DLM_ASSERT_RESPONSE_MASTERY_REF) which creates a
hole that results in loss of refmap bit on the master node.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 83bcaf2..6e694b6 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1875,7 +1875,6 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 ok:
 		spin_unlock(&res->spinlock);
 	}
-	spin_unlock(&dlm->spinlock);
 
 	// mlog(0, "woo!  got an assert_master from node %u!\n",
 	// 	     assert->node_idx);
@@ -1926,7 +1925,6 @@ ok:
 		/* master is known, detach if not already detached.
 		 * ensures that only one assert_master call will happen
 		 * on this mle. */
-		spin_lock(&dlm->spinlock);
 		spin_lock(&dlm->master_lock);
 
 		rr = atomic_read(&mle->mle_refs.refcount);
@@ -1959,7 +1957,6 @@ ok:
 			__dlm_put_mle(mle);
 		}
 		spin_unlock(&dlm->master_lock);
-		spin_unlock(&dlm->spinlock);
 	} else if (res) {
 		if (res->owner != assert->node_idx) {
 			mlog(0, "assert_master from %u, but current "
@@ -1967,6 +1964,7 @@ ok:
 			     res->owner, namelen, name);
 		}
 	}
+	spin_unlock(&dlm->spinlock);
 
 done:
 	ret = 0;
-- 
1.5.6.5
