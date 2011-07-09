From: Julia Lawall <julia@diku.dk>
Date: Sat, 09 Jul 2011 16:04:48 -0000
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2/dlm/dlmlock.c: free
	kmem_cache_zalloc'd data using kmem_cache_free
Message-ID: <1310227479-14472-1-git-send-email-julia@diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: kernel-janitors@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, Wengang Wang <wen.gang.wang@oracle.com>, Tao Ma <boyu.mt@taobao.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memory allocated using kmem_cache_zalloc should be freed using
kmem_cache_free, not kfree.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e,e1,e2;
@@

x = kmem_cache_zalloc(e1,e2)
... when != x = e
?-kfree(x)
+kmem_cache_free(e1,x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ocfs2/dlm/dlmlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -440,7 +440,7 @@ struct dlm_lock * dlm_new_lock(int type,
 		/* zero memory only if kernel-allocated */
 		lksb = kzalloc(sizeof(*lksb), GFP_NOFS);
 		if (!lksb) {
-			kfree(lock);
+			kmem_cache_free(dlm_lock_cache, lock);
 			return NULL;
 		}
 		kernel_allocated = 1;
