From: Coly Li <coyli@suse.de>
Date: Mon, 17 Nov 2008 12:38:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix return value set in init_dlmfs_fs()
Message-ID: <4920F53E.5010800@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In init_dlmfs_fs(), if calling kmem_cache_create() failed, the code will use return value from
calling bdi_init(). The correct behavior should be set status as -ENOMEM before going to "bail:".

Signed-off-by: Coly Li <coyli@suse.de>
---
 fs/ocfs2/dlm/dlmfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 533a789..ba962d7 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -608,8 +608,10 @@ static int __init init_dlmfs_fs(void)
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 					SLAB_MEM_SPREAD),
 				dlmfs_init_once);
-	if (!dlmfs_inode_cache)
+	if (!dlmfs_inode_cache) {
+		status = -ENOMEM;
 		goto bail;
+	}
 	cleanup_inode = 1;

 	user_dlm_worker = create_singlethread_workqueue("user_dlm");

-- 
Coly Li
SuSE PRC Labs
