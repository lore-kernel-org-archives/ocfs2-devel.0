From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Tue, 17 Feb 2015 16:14:24 +0900
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: remove unneeded 'rc' for kfree()
Message-ID: <20150217071424.GA9582@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

If kzalloc() is failed, just goto 'out' label and
'out_free' label doesn't need to check 'rc' variable.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/stack_o2cb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 813d726..46ab104 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -347,7 +347,7 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
 	priv = kzalloc(sizeof(struct o2dlm_private), GFP_KERNEL);
 	if (!priv) {
 		rc = -ENOMEM;
-		goto out_free;
+		goto out;
 	}
 
 	/* This just fills the structure in.  It is safe to pass conn. */
@@ -376,8 +376,7 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
 	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
 
 out_free:
-	if (rc)
-		kfree(conn->cc_private);
+	kfree(conn->cc_private);
 
 out:
 	return rc;
-- 
1.7.1
