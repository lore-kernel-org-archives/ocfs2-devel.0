From: Tao Ma <tao.ma@oracle.com>
Date: Wed Feb 27 19:07:34 2008
Subject: [Ocfs2-devel] Use dlm_print_one_lock_resource in
	dlm_add_lock_to_array.
Message-ID: <20080228030541.GA11530@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

__dlm_print_one_lock_resource must be called with spin_lock
the res->spinlock. While in this case, we use it without this
precondition and lead to the failure of assert_spin_locked.
So call dlm_print_one_lock_resource instead.

Signed-off-by: Tao Ma <tao.ma@oracle.com>

---

 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

c1c3be6574177eebc71c8c1ee70ead0a7f0ea659
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 91f747b..550d4e6 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1191,7 +1191,7 @@ static int dlm_add_lock_to_array(struct 
 			    (ml->type == LKM_EXMODE ||
 			     memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))) {
 				mlog(ML_ERROR, "mismatched lvbs!\n");
-				__dlm_print_one_lock_resource(lock->lockres);
+				dlm_print_one_lock_resource(lock->lockres);
 				BUG();
 			}
 			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
-- 
1.3.3
