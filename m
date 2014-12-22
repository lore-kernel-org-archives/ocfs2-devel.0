From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 22 Dec 2014 20:05:09 +0100
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: remove unnecessary
	sizeof(char)
Message-ID: <1419275109-11641-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

sizeof(char) is always 1.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e238bbc..750597c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -129,8 +129,8 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
 	if (osb->replay_map)
 		return 0;
 
-	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
-			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
+	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) + osb->max_slots,
+			     GFP_KERNEL);
 
 	if (!replay_map) {
 		mlog_errno(-ENOMEM);
-- 
1.9.1
