From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 18 Jun 2009 15:53:25 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Don't call dlm for orphan scan
	lock if volume is local.
In-Reply-To: <4A39F138.9050503@oracle.com>
References: <4A39F138.9050503@oracle.com>
Message-ID: <1245311605-28534-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If the volume is mkfsed and mounted locally, orphan scan lock and
unlock don't need to call dlm. Just return directly like other operations.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmglue.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 5760f58..8210091 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2427,6 +2427,9 @@ int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
 	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 	int status = 0;
 
+	if (ocfs2_mount_local(osb))
+		goto bail;
+
 	lockres = &osb->osb_orphan_scan.os_lockres;
 	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
 	if (status < 0)
@@ -2435,6 +2438,8 @@ int ocfs2_orphan_scan_lock(struct ocfs2_super *osb, u32 *seqno, int ex)
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	if (lvb->lvb_version == OCFS2_ORPHAN_LVB_VERSION)
 		*seqno = be32_to_cpu(lvb->lvb_os_seqno);
+
+bail:
 	return status;
 }
 
@@ -2444,6 +2449,9 @@ void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, int ex)
 	struct ocfs2_orphan_scan_lvb *lvb;
 	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 
+	if (ocfs2_mount_local(osb))
+		return;
+
 	lockres = &osb->osb_orphan_scan.os_lockres;
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
-- 
1.5.5
