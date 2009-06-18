From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 18 Jun 2009 15:53:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Don't init lvb of orphan lock in
	local mode.
In-Reply-To: <4A39F138.9050503@oracle.com>
References: <4A39F138.9050503@oracle.com>
Message-ID: <1245311605-28534-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If the volume is mkfsed and used locally, we only need to
intialize orphan_scan_lock, but no lvb is needed.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmglue.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index b4b5ea3..5760f58 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -667,8 +667,10 @@ static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
 	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_ORPHAN_SCAN, 0, 0, res->l_name);
 	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_ORPHAN_SCAN,
 				   &ocfs2_orphan_scan_lops, osb);
-	lvb = ocfs2_dlm_lvb(&res->l_lksb);
-	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
+	if (!ocfs2_mount_local(osb)) {
+		lvb = ocfs2_dlm_lvb(&res->l_lksb);
+		lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
+	}
 }
 
 void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
-- 
1.5.5
