From: Adrian Bunk <bunk@kernel.org>
Date: Sun Feb 17 00:21:16 2008
Subject: [Ocfs2-devel] [2.6 patch] ocfs: make dlm_do_assert_master() static
Message-ID: <20080217082041.GV3848@cs181133002.pp.htv.fi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

This patch makes the needlessly global dlm_do_assert_master() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d30e20106688e15d199297957c5fe1f6d79f23c9 diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index a54d33d..c92d1b1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1695,9 +1695,9 @@ send_response:
  * can periodically run all locks owned by this node
  * and re-assert across the cluster...
  */
-int dlm_do_assert_master(struct dlm_ctxt *dlm,
-			 struct dlm_lock_resource *res,
-			 void *nodemap, u32 flags)
+static int dlm_do_assert_master(struct dlm_ctxt *dlm,
+				struct dlm_lock_resource *res,
+				void *nodemap, u32 flags)
 {
 	struct dlm_assert_master assert;
 	int to, tmpret;
