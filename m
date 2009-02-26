From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 26 Feb 2009 15:00:45 -0800
Subject: [Ocfs2-devel] [PATCH 09/13] ocfs2/dlm: dlm_set_lockres_owner() and
	dlm_change_lockres_owner() inlined
In-Reply-To: <1235689249-2693-1-git-send-email-sunil.mushran@oracle.com>
References: <1235689249-2693-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1235689249-2693-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch inlines dlm_set_lockres_owner() and dlm_change_lockres_owner().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   21 ++++++++++++++++++---
 fs/ocfs2/dlm/dlmmaster.c |   19 -------------------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e5026ce..266fde9 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -858,9 +858,7 @@ struct dlm_lock_resource * dlm_lookup_lockres(struct dlm_ctxt *dlm,
 					      unsigned int len);
 
 int dlm_is_host_down(int errno);
-void dlm_change_lockres_owner(struct dlm_ctxt *dlm,
-			      struct dlm_lock_resource *res,
-			      u8 owner);
+
 struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
 						 const char *lockid,
 						 int namelen,
@@ -1123,6 +1121,23 @@ static inline int dlm_node_iter_next(struct dlm_node_iter *iter)
 	return bit;
 }
 
+static inline void dlm_set_lockres_owner(struct dlm_ctxt *dlm,
+					 struct dlm_lock_resource *res,
+					 u8 owner)
+{
+	assert_spin_locked(&res->spinlock);
+
+	res->owner = owner;
+}
 
+static inline void dlm_change_lockres_owner(struct dlm_ctxt *dlm,
+					    struct dlm_lock_resource *res,
+					    u8 owner)
+{
+	assert_spin_locked(&res->spinlock);
+
+	if (owner != res->owner)
+		dlm_set_lockres_owner(dlm, res, owner);
+}
 
 #endif /* DLMCOMMON_H */
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 13df364..2093133 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -511,25 +511,6 @@ void dlm_destroy_master_caches(void)
 		kmem_cache_destroy(dlm_lockres_cache);
 }
 
-static void dlm_set_lockres_owner(struct dlm_ctxt *dlm,
-				  struct dlm_lock_resource *res,
-				  u8 owner)
-{
-	assert_spin_locked(&res->spinlock);
-
-	res->owner = owner;
-}
-
-void dlm_change_lockres_owner(struct dlm_ctxt *dlm,
-			      struct dlm_lock_resource *res, u8 owner)
-{
-	assert_spin_locked(&res->spinlock);
-
-	if (owner != res->owner)
-		dlm_set_lockres_owner(dlm, res, owner);
-}
-
-
 static void dlm_lockres_release(struct kref *kref)
 {
 	struct dlm_lock_resource *res;
-- 
1.5.6.3
