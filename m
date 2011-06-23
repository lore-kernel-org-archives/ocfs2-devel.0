From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:31:01 -0700
Subject: [Ocfs2-devel] [PATCH 07/13] ocfs2/dlm: Trace insert/remove of
	resource to/from hash
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add mlog to trace adding and removing the resource from/to the hash table.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    5 ++---
 fs/ocfs2/dlm/dlmdomain.c |   19 ++++++++++++-------
 fs/ocfs2/dlm/dlmthread.c |    2 +-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 4a5d580..b1748ac 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -877,9 +877,8 @@ static inline void dlm_lockres_get(struct dlm_lock_resource *res)
 	kref_get(&res->refs);
 }
 void dlm_lockres_put(struct dlm_lock_resource *res);
-void __dlm_unhash_lockres(struct dlm_lock_resource *res);
-void __dlm_insert_lockres(struct dlm_ctxt *dlm,
-			  struct dlm_lock_resource *res);
+void __dlm_unhash_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);
+void __dlm_insert_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);
 struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
 						     const char *name,
 						     unsigned int len,
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index ce225fb..200d988 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -157,16 +157,18 @@ static int dlm_protocol_compare(struct dlm_protocol_version *existing,
 
 static void dlm_unregister_domain_handlers(struct dlm_ctxt *dlm);
 
-void __dlm_unhash_lockres(struct dlm_lock_resource *lockres)
+void __dlm_unhash_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 {
-	if (!hlist_unhashed(&lockres->hash_node)) {
-		hlist_del_init(&lockres->hash_node);
-		dlm_lockres_put(lockres);
-	}
+	if (hlist_unhashed(&res->hash_node))
+		return;
+
+	mlog(0, "%s: Unhash res %.*s\n", dlm->name, res->lockname.len,
+	     res->lockname.name);
+	hlist_del_init(&res->hash_node);
+	dlm_lockres_put(res);
 }
 
-void __dlm_insert_lockres(struct dlm_ctxt *dlm,
-		       struct dlm_lock_resource *res)
+void __dlm_insert_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 {
 	struct hlist_head *bucket;
 	struct qstr *q;
@@ -180,6 +182,9 @@ void __dlm_insert_lockres(struct dlm_ctxt *dlm,
 	dlm_lockres_get(res);
 
 	hlist_add_head(&res->hash_node, bucket);
+
+	mlog(0, "%s: Hash res %.*s\n", dlm->name, res->lockname.len,
+	     res->lockname.name);
 }
 
 struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 46faac2..4eff65e 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -207,7 +207,7 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
 		BUG();
 	}
 
-	__dlm_unhash_lockres(res);
+	__dlm_unhash_lockres(dlm, res);
 
 	/* lockres is not in the hash now.  drop the flag and wake up
 	 * any processes waiting in dlm_get_lock_resource. */
-- 
1.7.4.1
