From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  3 Feb 2009 12:37:16 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2/dlm: Make
	dlm_assert_master_handler() kill itself instead of the asserter
In-Reply-To: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
References: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1233693436-29263-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_assert_master_handler(), if we get an incorrect assert master from a node
that, we reply with EINVAL asking the asserter to die. The problem is that an
assert is sent after so many hoops, it is invariably the node that thinks the
asserter is wrong, is actually wrong. So instead of killing the asserter, this
patch kills the assertee.

This patch papers over a race that is still being addressed.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 54e182a..0a28139 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1849,12 +1849,12 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 		if (!mle) {
 			if (res->owner != DLM_LOCK_RES_OWNER_UNKNOWN &&
 			    res->owner != assert->node_idx) {
-				mlog(ML_ERROR, "assert_master from "
-					  "%u, but current owner is "
-					  "%u! (%.*s)\n",
-				       assert->node_idx, res->owner,
-				       namelen, name);
-				goto kill;
+				mlog(ML_ERROR, "DIE! Mastery assert from %u, "
+				     "but current owner is %u! (%.*s)\n",
+				     assert->node_idx, res->owner, namelen,
+				     name);
+				__dlm_print_one_lock_resource(res);
+				BUG();
 			}
 		} else if (mle->type != DLM_MLE_MIGRATION) {
 			if (res->owner != DLM_LOCK_RES_OWNER_UNKNOWN) {
-- 
1.5.6.3
