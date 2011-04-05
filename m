From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  5 Apr 2011 15:21:07 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/dlm: Use negotiated o2dlm protocol
	version
In-Reply-To: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
References: <1302042069-25565-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1302042069-25565-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch fixes a bug in the o2dlm protocol negotiation in that it is using
the builtin version rather than the negotiated version during the domain
join. This causes join errors when a node having kernel >= 2.6.37 joins
a cluster with nodes having kernels < 2.6.37.

This only affects the o2cb cluster stack.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Reported-by: Jacek Stepniewski <Jacek.Stepniewski@agora.pl>
---
 fs/ocfs2/dlm/dlmdomain.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 7540a49..3b179d6 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1614,7 +1614,8 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 	spin_unlock(&dlm->spinlock);
 
 	/* Support for global heartbeat and node info was added in 1.1 */
-	if (dlm_protocol.pv_major > 1 || dlm_protocol.pv_minor > 0) {
+	if (dlm->dlm_locking_proto.pv_major > 1 ||
+	    dlm->dlm_locking_proto.pv_minor > 0) {
 		status = dlm_send_nodeinfo(dlm, ctxt->yes_resp_map);
 		if (status) {
 			mlog_errno(status);
-- 
1.7.1
