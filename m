From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:28 -0700
Subject: [Ocfs2-devel] [PATCH 18/62] ocfs2: Abstract out a debugging
	function for underlying dlms.
In-Reply-To: <12071673543752-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
Message-ID: <1207167355295-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

From: Joel Becker <joel.becker@oracle.com>

dlmglue.c was still referencing a raw o2dlm lksb in one instance.  Let's
create a generic ocfs2_dlm_dump_lksb() function.  This allows underlying
DLMs to print whatever they want about their lock.

We then move the o2dlm dump into stackglue.c where it belongs.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c   |    3 +--
 fs/ocfs2/stackglue.c |    5 +++++
 fs/ocfs2/stackglue.h |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index b640423..f41ff1c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2803,8 +2803,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
 	if (ret) {
 		ocfs2_log_dlm_error("ocfs2_dlm_unlock", ret, lockres);
 		mlog(ML_ERROR, "lockres flags: %lu\n", lockres->l_flags);
-		/* XXX Need to abstract this */
-		dlm_print_one_lock(lockres->l_lksb.lksb_o2dlm.lockid);
+		ocfs2_dlm_dump_lksb(&lockres->l_lksb);
 		BUG();
 	}
 	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index abdb9f6..bd80541 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -252,6 +252,11 @@ void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 	return (void *)(lksb->lksb_o2dlm.lvb);
 }
 
+void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb)
+{
+	dlm_print_one_lock(lksb->lksb_o2dlm.lockid);
+}
+
 /*
  * Called from the dlm when it's about to evict a node. This is how the
  * classic stack signals node death.
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index 22af77b..01e3c9b 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -91,6 +91,7 @@ int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
 
 int ocfs2_dlm_lock_status(union ocfs2_dlm_lksb *lksb);
 void *ocfs2_dlm_lvb(union ocfs2_dlm_lksb *lksb);
+void ocfs2_dlm_dump_lksb(union ocfs2_dlm_lksb *lksb);
 
 void o2cb_get_stack(struct ocfs2_locking_protocol *proto);
 void o2cb_put_stack(void);
-- 
1.5.4.1
