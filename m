From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:20 2008
Subject: [Ocfs2-devel] [PATCH 15/18] ocfs2/dlm: Add missing
	dlm_lockres_put()s
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-16-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit b31cfc0237f89c3a8bc8f31b5da996e71b543214
Author: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat, 1 Mar 2008 14:04:22 -0800

dlm_master_request_handler() forgot to put a lockres when
dlm_assert_master_worker() failed or was skipped.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index e5ceda9..c31fee7 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1663,7 +1663,12 @@ way_up_top:
 		dlm_put_mle(tmpmle);
 	}
 send_response:
-
+	/*
+	 * __dlm_lookup_lockres() grabbed a reference to this lockres.
+	 * The reference is released by dlm_assert_master_worker() under
+	 * the call to dlm_dispatch_assert_master().  If
+	 * dlm_assert_master_worker() isn't called, we drop it here.
+	 */
 	if (dispatch_assert) {
 		if (response != DLM_MASTER_RESP_YES)
 			mlog(ML_ERROR, "invalid response %d\n", response);
@@ -1678,7 +1683,11 @@ send_response:
 		if (ret < 0) {
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
+			dlm_lockres_put(res);
 		}
+	} else {
+		if (res)
+			dlm_lockres_put(res);
 	}
 
 	dlm_put(dlm);
-- 
1.5.3.4
