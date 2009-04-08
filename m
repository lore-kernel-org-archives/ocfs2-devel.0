From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  9 Apr 2009 05:54:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Hold ip_lock when set/clear flags for
	indexed dir.
Message-ID: <1239227689-696-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we set/clear the dyn_features for an inode we hold the ip_lock.
So do it when we set/clear OCFS2_INDEXED_DIR_FL also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dir.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 07d8920..8e0f370 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2463,8 +2463,10 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 
 	di->i_dx_root = cpu_to_le64(dr_blkno);
 
+	spin_lock(&OCFS2_I(dir)->ip_lock);
 	OCFS2_I(dir)->ip_dyn_features |= OCFS2_INDEXED_DIR_FL;
 	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+	spin_unlock(&OCFS2_I(dir)->ip_lock);
 
 	ret = ocfs2_journal_dirty(handle, di_bh);
 	if (ret)
@@ -4477,8 +4479,10 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
 		goto out_commit;
 	}
 
+	spin_lock(&OCFS2_I(dir)->ip_lock);
 	OCFS2_I(dir)->ip_dyn_features &= ~OCFS2_INDEXED_DIR_FL;
 	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
+	spin_unlock(&OCFS2_I(dir)->ip_lock);
 	di->i_dx_root = cpu_to_le64(0ULL);
 
 	ocfs2_journal_dirty(handle, di_bh);
-- 
1.6.1.40.g8ea6a
