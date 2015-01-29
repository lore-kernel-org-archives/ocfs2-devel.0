From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Thu, 29 Jan 2015 19:49:54 +0900
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: remove unreachable code in
 __ocfs2_recovery_thread()
Message-ID: <20150129104953.GA6094@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/journal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ca11c83..ff53192 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1462,7 +1462,6 @@ bail:
 	 * requires that we call do_exit().  And it isn't exported, but
 	 * complete_and_exit() seems to be a minimal wrapper around it. */
 	complete_and_exit(NULL, status);
-	return status;
 }
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
-- 
1.7.1
