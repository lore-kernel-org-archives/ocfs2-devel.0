From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:47 +0800
Subject: [Ocfs2-devel] [PATCH 41/42] ocfs2: Make transaction extend more
	efficient.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-41-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_extend_rotate_transaction, op_credits is the orignal
credits in the handle and we only want to extend the credits
for the rotation, but the old solution always double it. It
is harmless for some minor operations, but for actions like
reflink we may rotate tree many times and cause the credits
increase dramatically. So this patch try to only increase
the desired credits.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5957f8c..45e4398 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2274,10 +2274,18 @@ static int ocfs2_extend_rotate_transaction(handle_t *handle, int subtree_depth,
 					   int op_credits,
 					   struct ocfs2_path *path)
 {
+	int ret;
 	int credits = (path->p_tree_depth - subtree_depth) * 2 + 1 + op_credits;
 
-	if (handle->h_buffer_credits < credits)
-		return ocfs2_extend_trans(handle, credits);
+	if (handle->h_buffer_credits < credits) {
+		ret = ocfs2_extend_trans(handle,
+					 credits - handle->h_buffer_credits);
+		if (ret)
+			return ret;
+
+		if (unlikely(handle->h_buffer_credits < credits))
+			return ocfs2_extend_trans(handle, credits);
+	}
 
 	return 0;
 }
-- 
1.6.2.rc2.16.gf474c
