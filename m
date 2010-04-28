From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 29 Apr 2010 00:48:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make lockres lookup faster
Message-ID: <201004281649.o3S3tMKK007057@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lockres lookup is within the dlm->spinlock. We'd better finish the lookup as
fast as possible especially when the machine is with more cpus.

Existing lookup is comparing charactors starting on a non-aligned address which
takes more time. This patch improves the performance mostly by changing comparing
on non-aligned address to comparing on aligned address. Also it makes all lockres
have same name length so that comparing length is not needed. And thus the extra
comparing on the first charactor is not needed any longer.

This patch changes recovery lockres name length from 9 to 31. This change doesn't
have much badness.

Per my test on the loop comparations in user space, This change at most can get
15.7% faster.

Questions:
1. Is there other special lockres name with non-31 length?
2. If all lockres name length is changed to 32(including the tailing '\n'), it
gets at most 19% faster, but increase 1 byte network transfer for very request.
I don't know whether this is worthy.

Drawbacks:
1. It changes locking version which makes rolling upgrade impossible.

#I didn't test the patch yet.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h    |    5 +++--
 fs/ocfs2/dlm/dlmdomain.c    |    6 +-----
 fs/ocfs2/ocfs2_lockingver.h |    5 ++++-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0102be3..c41ebf5 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -91,8 +91,9 @@ enum dlm_ast_type {
 			 LKM_CANCEL | LKM_INVVALBLK | LKM_FORCE | \
 			 LKM_RECOVERY | LKM_LOCAL | LKM_NOQUEUE)
 
-#define DLM_RECOVERY_LOCK_NAME       "$RECOVERY"
-#define DLM_RECOVERY_LOCK_NAME_LEN   9
+#define DLM_RECOVERY_LOCK_NAME       "$RECOVERY0000000000000000000000"
+/* make the length of recovery lock name the same as normal ones */
+#define DLM_RECOVERY_LOCK_NAME_LEN   31
 
 static inline int dlm_is_recovery_lock(const char *lock_name, int name_len)
 {
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 988c905..7062d48 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -191,11 +191,7 @@ struct dlm_lock_resource * __dlm_lookup_lockres_full(struct dlm_ctxt *dlm,
 	hlist_for_each(list, bucket) {
 		struct dlm_lock_resource *res = hlist_entry(list,
 			struct dlm_lock_resource, hash_node);
-		if (res->lockname.name[0] != name[0])
-			continue;
-		if (unlikely(res->lockname.len != len))
-			continue;
-		if (memcmp(res->lockname.name + 1, name + 1, len - 1))
+		if (memcmp(res->lockname.name, name, len))
 			continue;
 		dlm_lockres_get(res);
 		return res;
diff --git a/fs/ocfs2/ocfs2_lockingver.h b/fs/ocfs2/ocfs2_lockingver.h
index 2e45c8d..7fd9260 100644
--- a/fs/ocfs2/ocfs2_lockingver.h
+++ b/fs/ocfs2/ocfs2_lockingver.h
@@ -25,8 +25,11 @@
  * more details.
  *
  * 1.0 - Initial locking version from ocfs2 1.4.
+ * 1.1 - Change recovery lock name from "$recovery" to
+ *       "$recovery00000000000000000000000". --make it 31 bytes long, same as
+ *       the length of normal lock name.
  */
 #define OCFS2_LOCKING_PROTOCOL_MAJOR 1
-#define OCFS2_LOCKING_PROTOCOL_MINOR 0
+#define OCFS2_LOCKING_PROTOCOL_MINOR 1
 
 #endif  /* OCFS2_LOCKINGVER_H */
-- 
1.6.6.1
