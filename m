From: jiangyiwen <jiangyiwen@huawei.com>
Date: Mon, 31 Aug 2015 15:36:15 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix a tiny case that inode can not
	removed.
Message-ID: <55E403EF.3060702@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When running dirop_fileop_racer we found a case that inode
can not removed.

2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
two dirs /race/1/ and /race/2/ in the filesystem.

Node A                            Node B
rm -r /race/2/
                                  mv /race/1/ /race/2/
call ocfs2_unlink(), get
the EX mode of /race/2/
                                  wait for B unlock /race/2/
decrease i_nlink of /race/2/ to 0,
and add inode of /race/2/ into
orphan dir, unlock /race/2/
                                  got EX mode of /race/2/. because
                                  /race/1/ is dir, so inc i_nlink
                                  of /race/2/ and update into disk,
                                  unlock /race/2/
because i_nlink of /race/2/
is not zero, this inode will
always remain in orphan dir

This patch fixes this case by test whether i_nlink of new dir is zero.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6e6abb9..2092c88 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1284,6 +1284,11 @@ static int ocfs2_rename(struct inode *old_dir,
 	}
 	parents_locked = 1;

+	if (!new_dir->i_nlink) {
+		status = -EACCES;
+		goto bail;
+	}
+
 	/* make sure both dirs have bhs
 	 * get an extra ref on old_dir_bh if old==new */
 	if (!new_dir_bh) {
-- 
1.8.3.4
