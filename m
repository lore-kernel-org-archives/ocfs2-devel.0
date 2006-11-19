From: Adrian Bunk <bunk@stusta.de>
Date: Sun Nov 19 18:24:32 2006
Subject: [Ocfs2-devel] [2.6 patch] make ocfs2_create_new_lock() static
Message-ID: <20061120022428.GS31879@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

This patch makes the needlessly global ocfs2_create_new_lock() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/ocfs2/dlmglue.c |    8 ++++----
 fs/ocfs2/dlmglue.h |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.19-rc5-mm2/fs/ocfs2/dlmglue.h.old	2006-11-20 02:04:48.000000000 +0100
+++ linux-2.6.19-rc5-mm2/fs/ocfs2/dlmglue.h	2006-11-20 02:04:55.000000000 +0100
@@ -68,8 +68,6 @@
 				u64 parent, struct inode *inode);
 void ocfs2_lock_res_free(struct ocfs2_lock_res *res);
 int ocfs2_create_new_inode_locks(struct inode *inode);
-int ocfs2_create_new_lock(struct ocfs2_super *osb,
-			  struct ocfs2_lock_res *lockres, int ex, int local);
 int ocfs2_drop_inode_locks(struct inode *inode);
 int ocfs2_data_lock_full(struct inode *inode,
 			 int write,
--- linux-2.6.19-rc5-mm2/fs/ocfs2/dlmglue.c.old	2006-11-20 02:05:01.000000000 +0100
+++ linux-2.6.19-rc5-mm2/fs/ocfs2/dlmglue.c	2006-11-20 02:05:10.000000000 +0100
@@ -1063,10 +1063,10 @@
 	mlog_exit_void();
 }
 
-int ocfs2_create_new_lock(struct ocfs2_super *osb,
-			  struct ocfs2_lock_res *lockres,
-			  int ex,
-			  int local)
+static int ocfs2_create_new_lock(struct ocfs2_super *osb,
+				 struct ocfs2_lock_res *lockres,
+				 int ex,
+				 int local)
 {
 	int level =  ex ? LKM_EXMODE : LKM_PRMODE;
 	unsigned long flags;
