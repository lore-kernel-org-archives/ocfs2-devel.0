From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 2 Aug 2013 15:30:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix possible double free in
	ocfs2_reflink_xattr_rec
Message-ID: <51FB602E.7000600@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_reflink_xattr_rec(), meta_ac and data_ac are allocated by
calling ocfs2_lock_reflink_xattr_rec_allocators().
Once an error occurs when allocating *data_ac, it frees *meta_ac which
is allocated before. Here it mistakenly sets meta_ac to NULL but
*meta_ac. Then ocfs2_reflink_xattr_rec() will try to free meta_ac again
which is already invalid.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 87daa44..bd2a1f0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6799,7 +6799,7 @@ out:
 	if (ret) {
 		if (*meta_ac) {
 			ocfs2_free_alloc_context(*meta_ac);
-			meta_ac = NULL;
+			*meta_ac = NULL;
 		}
 	}

-- 
1.7.9.7
