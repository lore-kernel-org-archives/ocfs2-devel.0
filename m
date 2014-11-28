From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 28 Nov 2014 11:30:40 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: remove unneeded NULL check
Message-ID: <20141128083040.GA10252@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In 1faf289454b9 ('ocfs2_dlm: disallow a domain join if node maps
mismatch') then we introduced a new earlier NULL check so this one is
not needed.  Also static checkers complain because we dereference it
first and then check for NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 02d315f..50a59d2 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -877,7 +877,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 	 * to be put in someone's domain map.
 	 * Also, explicitly disallow joining at certain troublesome
 	 * times (ie. during recovery). */
-	if (dlm && dlm->dlm_state != DLM_CTXT_LEAVING) {
+	if (dlm->dlm_state != DLM_CTXT_LEAVING) {
 		int bit = query->node_idx;
 		spin_lock(&dlm->spinlock);
 
