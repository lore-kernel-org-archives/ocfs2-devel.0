From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Sep 2010 15:50:40 -0700
Subject: [Ocfs2-devel] [PATCH 04/20] ocfs2/dlm: Expose dlm_protocol in
	dlm_state
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1284504656-2434-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add dlm_protocol to the list of info shown by the debugfs file, dlm_state.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 5efdd37..51164a6 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -775,7 +775,9 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 
 	/* Domain: xxxxxxxxxx  Key: 0xdfbac769 */
 	out += snprintf(db->buf + out, db->len - out,
-			"Domain: %s  Key: 0x%08x\n", dlm->name, dlm->key);
+			"Domain: %s  Key: 0x%08x  Protocol: %d.%d\n",
+			dlm->name, dlm->key, dlm->dlm_locking_proto.pv_major,
+			dlm->dlm_locking_proto.pv_minor);
 
 	/* Thread Pid: xxx  Node: xxx  State: xxxxx */
 	out += snprintf(db->buf + out, db->len - out,
-- 
1.7.0.4
