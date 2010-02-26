From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 26 Feb 2010 12:53:51 -0800
Subject: [Ocfs2-devel] [PATCH] dlm: allow dlm do recovery during shutdown
Message-ID: <1267217631-18593-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If a node down event happens while dlm shutdown in progress, dlm recovery
should be done before dlm is shutdown. But dlm_reco_thread only does recovery
if the dlm_state is in DLM_CTXT_JOINED.

dlm_reco_thread should do recovery if dlm_state is in DLM_CTXT_JOINED or
DLM_CTXT_IN_SHUTDOWN.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index d9fa3d2..e347b6a 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -310,7 +310,7 @@ static int dlm_recovery_thread(void *data)
 	mlog(0, "dlm thread running for %s...\n", dlm->name);
 
 	while (!kthread_should_stop()) {
-		if (dlm_joined(dlm)) {
+		if (dlm_domain_fully_joined(dlm)) {
 			status = dlm_do_recovery(dlm);
 			if (status == -EAGAIN) {
 				/* do not sleep, recheck immediately. */
-- 
1.5.6.5
