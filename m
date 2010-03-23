From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 23 Mar 2010 11:07:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix a race in o2dlm lockres
	mastery(backport to 1.4)
Message-ID: <1269367679-22584-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In o2dlm, the master of a lock resource keeps a map of all interested
nodes.  This prevents the master from purging the resource before an
interested node can create a lock.

A race between the mastery thread and the mastery handler allowed an
interested node to discover who the master is without informing the
master directly.  This is easily fixed by holding the dlm spinlock a
little longer in the mastery handler.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 047e7bc..a1cd7b1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1876,7 +1876,6 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 ok:
 		spin_unlock(&res->spinlock);
 	}
-	spin_unlock(&dlm->spinlock);
 
 	// mlog(0, "woo!  got an assert_master from node %u!\n",
 	// 	     assert->node_idx);
@@ -1927,7 +1926,6 @@ ok:
 		/* master is known, detach if not already detached.
 		 * ensures that only one assert_master call will happen
 		 * on this mle. */
-		spin_lock(&dlm->spinlock);
 		spin_lock(&dlm->master_lock);
 
 		rr = atomic_read(&mle->mle_refs.refcount);
@@ -1960,7 +1958,6 @@ ok:
 			__dlm_put_mle(mle);
 		}
 		spin_unlock(&dlm->master_lock);
-		spin_unlock(&dlm->spinlock);
 	} else if (res) {
 		if (res->owner != assert->node_idx) {
 			mlog(0, "assert_master from %u, but current "
@@ -1968,6 +1965,7 @@ ok:
 			     res->owner, namelen, name);
 		}
 	}
+	spin_unlock(&dlm->spinlock);
 
 done:
 	ret = 0;
-- 
1.5.6.5
