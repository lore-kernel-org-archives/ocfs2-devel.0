From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:17 2008
Subject: [Ocfs2-devel] [PATCH 05/18] ocfs2_dlm: Add missing
	dlm_lockres_put()s
In-Reply-To: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
References: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1203970862-8790-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds few missing puts in dlm_master_request_handler().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 8e3c40e..d07a30a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1718,7 +1718,13 @@ send_response:
 		if (ret < 0) {
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
+			/* incase dlm_assert_master_worker() was not called */
+			dlm_lockres_put(res);
 		}
+	} else {
+		/* match the put in dlm_assert_master_worker() */
+		if (res)
+			dlm_lockres_put(res);
 	}
 
 	dlm_put(dlm);
-- 
1.5.2.5
