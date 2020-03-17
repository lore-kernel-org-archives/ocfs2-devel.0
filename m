From: wangjian <wangjian161@huawei.com>
Date: Tue, 17 Mar 2020 20:28:54 +0800
Subject: [Ocfs2-devel] [PATCH v5] ocfs2: roll back the reference count
 modification of the parent directory if an error occurs
Message-ID: <a44f6666-bbc4-405e-0e6c-0f4e922eeef6@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Under some conditions, the directory cannot be deleted.
The specific scenarios are as follows: (for example,
/mnt/ocfs2 is the mount point)

1. Create the /mnt/ocfs2/p_dir directory. At this time,
the i_nlink corresponding to the inode of
the /mnt/ocfs2/p_dir directory is equal to 2.

2. During the process of creating the
/mnt/ocfs2/p_dir/s_dir directory, if the call to the inc_nlink
function in ocfs2_mknod succeeds, the functions such as
ocfs2_init_acl, ocfs2_init_security_set, and ocfs2_dentry_attach_lock fail.
At this time, the i_nlink corresponding to the inode of the
/mnt/ocfs2/p_dir directory is equal to 3, but /mnt/ocfs2/p_dir/s_dir
is not added to the /mnt/ocfs2/p_dir directory entry.

3. Delete the /mnt/ocfs2/p_dir directory (rm -rf /mnt/ocfs2/p_dir).
At this time, it is found that the i_nlink corresponding to
the inode corresponding to the /mnt/ocfs2/p_dir directory is equal to 3.
Therefore, the /mnt/ocfs2/p_dir directory cannot be deleted.

Signed-off-by: Jian wang <wangjian161@huawei.com>
---
  ocfs2/namei.c | 15 +++++++++++----
  1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/ocfs2/namei.c b/ocfs2/namei.c
index 8ea51cf..eaecab1 100644
--- a/ocfs2/namei.c
+++ b/ocfs2/namei.c
@@ -406,7 +406,7 @@ static int ocfs2_mknod(struct inode *dir,
  
  	if (status < 0) {
  		mlog_errno(status);
-		goto leave;
+		goto roll_back;
  	}
  
  	if (si.enable) {
@@ -414,7 +414,7 @@ static int ocfs2_mknod(struct inode *dir,
  						 meta_ac, data_ac);
  		if (status < 0) {
  			mlog_errno(status);
-			goto leave;
+			goto roll_back;
  		}
  	}
  
@@ -427,7 +427,7 @@ static int ocfs2_mknod(struct inode *dir,
  					  OCFS2_I(dir)->ip_blkno);
  	if (status) {
  		mlog_errno(status);
-		goto leave;
+		goto roll_back;
  	}
  
  	dl = dentry->d_fsdata;
@@ -437,12 +437,19 @@ static int ocfs2_mknod(struct inode *dir,
  				 &lookup);
  	if (status < 0) {
  		mlog_errno(status);
-		goto leave;
+		goto roll_back;
  	}
  
  	insert_inode_hash(inode);
  	d_instantiate(dentry, inode);
  	status = 0;
+
+roll_back:
+	if (status < 0 && S_ISDIR(mode)) {
+		ocfs2_add_links_count(dirfe, -1);
+		drop_nlink(dir);
+	}
+
  leave:
  	if (status < 0 && did_quota_inode)
  		dquot_free_inode(inode);
-- 
1.8.3.1

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200317/9eb6ac0e/attachment-0001.html 
