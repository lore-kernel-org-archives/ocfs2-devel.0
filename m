From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 25 Jan 2010 16:57:41 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2/dlm: Handle EAGAIN for compatibility
In-Reply-To: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
References: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1264467461-1881-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit aad1b15310b9bcd59fa81ab8f2b1513b59553ea8 made
dlm_begin_reco_handler() return -EAGAIN instead of EAGAIN.

This patch makes dlm_send_begin_reco_message() handle both
error numbers for compatibility reasons.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index cfb2ae9..ad71221 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2639,7 +2639,13 @@ retry:
 			     "begin reco msg (%d)\n", dlm->name, nodenum, ret);
 			ret = 0;
 		}
-		if (ret == -EAGAIN) {
+
+		/*
+		 * Prior to commit aad1b15310b9bcd59fa81ab8f2b1513b59553ea8,
+		 * dlm_begin_reco_handler() returned EAGAIN and not -EAGAIN.
+		 * We are handling both for compatibility reasons.
+		 */
+		if (ret == -EAGAIN || ret == EAGAIN) {
 			mlog(0, "%s: trying to start recovery of node "
 			     "%u, but node %u is waiting for last recovery "
 			     "to complete, backoff for a bit\n", dlm->name,
-- 
1.5.6.5
