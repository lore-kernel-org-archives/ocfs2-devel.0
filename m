From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:16 -0700
Subject: [Ocfs2-devel] [PATCH 03/26] ocfs2: Cleanup the lockname print in
	dlmglue.c
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit c74ff8bb2235d848beb67fcfddae71ecbe3f92b1

The dentry lock has a different format than other locks. This patch fixes
ocfs2_log_dlm_error() macro to make it print the dentry lock correctly.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 2580e4e..bacb092 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -334,10 +334,18 @@ static void ocfs2_schedule_blocked_lock(struct ocfs2_super *osb,
 					struct ocfs2_lock_res *lockres);
 static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 						int convert);
-#define ocfs2_log_dlm_error(_func, _stat, _lockres) do {	\
-	mlog(ML_ERROR, "Dlm error \"%s\" while calling %s on "	\
-		"resource %s: %s\n", dlm_errname(_stat), _func,	\
-		_lockres->l_name, dlm_errmsg(_stat));		\
+#define ocfs2_log_dlm_error(_func, _stat, _lockres) do {		\
+	if ((_lockres)->l_type != OCFS2_LOCK_TYPE_DENTRY)		\
+		mlog(ML_ERROR, "DLM error %s while calling %s on "	\
+		     "resource %s: %s\n", dlm_errname(_stat), _func,	\
+		     _lockres->l_name, dlm_errmsg(_stat));		\
+	else								\
+		mlog(ML_ERROR, "DLM error %s while calling %s on "	\
+		     "resource %.*s%08x: %s\n",	dlm_errname(_stat),	\
+		     _func, OCFS2_DENTRY_LOCK_INO_START - 1,		\
+		     _lockres->l_name,					\
+		     (unsigned int)ocfs2_get_dentry_lock_ino(_lockres),	\
+		     dlm_errmsg(_stat));				\
 } while (0)
 static int ocfs2_downconvert_thread(void *arg);
 static void ocfs2_downconvert_on_unlock(struct ocfs2_super *osb,
-- 
1.5.6.3
