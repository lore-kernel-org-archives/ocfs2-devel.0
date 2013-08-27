From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:11 -0700
Subject: [Ocfs2-devel] [patch 17/22] ocfs2: fix possible double free in
	ocfs2_reflink_xattr_rec
Message-ID: <20130827210511.6BC765A4276@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix possible double free in ocfs2_reflink_xattr_rec

In ocfs2_reflink_xattr_rec(), meta_ac and data_ac are allocated by calling
ocfs2_lock_reflink_xattr_rec_allocators().

Once an error occurs when allocating *data_ac, it frees *meta_ac which is
allocated before.  Here it mistakenly sets meta_ac to NULL but *meta_ac. 
Then ocfs2_reflink_xattr_rec() will try to free meta_ac again which is
already invalid.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec
+++ a/fs/ocfs2/xattr.c
@@ -6802,7 +6802,7 @@ out:
 	if (ret) {
 		if (*meta_ac) {
 			ocfs2_free_alloc_context(*meta_ac);
-			meta_ac = NULL;
+			*meta_ac = NULL;
 		}
 	}
 
_
