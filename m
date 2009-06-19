From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 16:53:18 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Do not initialize lvb in
	ocfs2_orphan_scan_lock_res_init()
In-Reply-To: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245455599-23348-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

No need to call ocfs2_dlm_lvb() in ocfs2_orphan_scan_lock_res_init().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |    7 +++----
 fs/ocfs2/journal.c |    1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6cdeaa7..667701e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -644,14 +644,10 @@ static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_lock_res *res,
 static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
 					    struct ocfs2_super *osb)
 {
-	struct ocfs2_orphan_scan_lvb *lvb;
-
 	ocfs2_lock_res_init_once(res);
 	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_ORPHAN_SCAN, 0, 0, res->l_name);
 	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_ORPHAN_SCAN,
 				   &ocfs2_orphan_scan_lops, osb);
-	lvb = ocfs2_dlm_lvb(&res->l_lksb);
-	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
 }
 
 void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
@@ -2384,6 +2380,9 @@ int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	if (lvb->lvb_version == OCFS2_ORPHAN_LVB_VERSION)
 		*seqno = be32_to_cpu(lvb->lvb_os_seqno);
+	else
+		*seqno = osb->osb_orphan_scan.os_seqno + 1;
+ 
 	return status;
 }
 
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 70215a2..0b2c27a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1952,6 +1952,7 @@ int ocfs2_orphan_scan_init(struct ocfs2_super *osb)
 	atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
 	os->os_osb = osb;
 	os->os_count = 0;
+	os->os_seqno = 0;
 	os->os_scantime = CURRENT_TIME;
 	mutex_init(&os->os_lock);
 
-- 
1.6.0.4
