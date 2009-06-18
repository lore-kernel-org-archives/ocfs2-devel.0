From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 18 Jun 2009 13:12:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Wrap
	ocfs2_sysfile_cluster_lock_key within define.
Message-ID: <1245301926-17359-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Actually ocfs2_sysfile_cluster_lock_key is only used if we enable
CONFIG_DEBUG_LOCK_ALLOC. Wrap it so that we can avoid a building
warning.
fs/ocfs2/sysfile.c:53: warning: ?ocfs2_sysfile_cluster_lock_key?
defined but not used

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/sysfile.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 6f53f5e..40e5370 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -50,7 +50,9 @@ static inline int is_in_system_inode_array(struct ocfs2_super *osb,
 					   int type,
 					   u32 slot);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key ocfs2_sysfile_cluster_lock_key[NUM_SYSTEM_INODES];
+#endif
 
 static inline int is_global_system_inode(int type)
 {
-- 
1.6.2.rc2.16.gf474c
