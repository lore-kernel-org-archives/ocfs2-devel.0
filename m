From: Coly Li <coly.li@suse.de>
Date: Fri, 04 Dec 2009 02:02:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: explicit declare uninitialized var in
	user_cluster_connect()
Message-ID: <4B17FD3B.1050503@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch explicitly declares an uninitialized local variable in user_cluster_connect(), to remove a compiling warning.

Signed-off-by: Coly Li <coly.li@suse.de>
---
 fs/ocfs2/stack_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index ff4c798..da78a2a 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -814,7 +814,7 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *control;
+	struct ocfs2_live_connection *uninitialized_var(control);
 	int rc = 0;

 	BUG_ON(conn == NULL);
-- 
Coly Li
SuSE Labs
