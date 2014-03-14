From: jiangyiwen <jiangyiwen@huawei.com>
Date: Fri, 14 Mar 2014 17:57:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: iput inode alloc when failed locally
Message-ID: <5322D286.4010506@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_info_handle_freeinode() and ocfs2_test_inode_bit() func,
after calls ocfs2_get_system_file_inode() to get inode ref, if
calls ocfs2_info_scan_inode_alloc() or ocfs2_inode_lock() failed,
we should iput inode alloc to avoid inode alloc be left over.

Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
---
 fs/ocfs2/ioctl.c    | 5 +++--
 fs/ocfs2/suballoc.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 8ca3c29..490229f 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -413,11 +413,12 @@ int ocfs2_info_handle_freeinode(struct inode *inode,
 		}

 		status = ocfs2_info_scan_inode_alloc(osb, inode_alloc, blkno, oifi, i);
-		if (status < 0)
-			goto bail;

 		iput(inode_alloc);
 		inode_alloc = NULL;
+
+		if (status < 0)
+			goto bail;
 	}

 	o2info_set_request_filled(&oifi->ifi_req);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 47ae266..5843420 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2870,6 +2870,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
 	if (status < 0) {
 		mutex_unlock(&inode_alloc_inode->i_mutex);
+		iput(inode_alloc_inode);
 		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
 		     (u32)suballoc_slot, status);
 		goto bail;
