From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:30:58 -0700
Subject: [Ocfs2-devel] [PATCH 04/13] ocfs2: Clean up messages in stack_o2cb.c
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2cb messages needed a facelift.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/stack_o2cb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 19965b0..be935d8 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -263,8 +263,8 @@ static void o2dlm_eviction_cb(int node_num, void *data)
 {
 	struct ocfs2_cluster_connection *conn = data;
 
-	mlog(ML_NOTICE, "o2dlm has evicted node %d from group %.*s\n",
-	     node_num, conn->cc_namelen, conn->cc_name);
+	printk(KERN_NOTICE "o2cb: o2dlm has evicted node %d from domain %.*s\n",
+	       node_num, conn->cc_namelen, conn->cc_name);
 
 	conn->cc_recovery_handler(node_num, conn->cc_recovery_data);
 }
-- 
1.7.4.1
