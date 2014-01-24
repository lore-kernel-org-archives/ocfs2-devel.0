From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:47:03 -0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix a tiny race when running
	dirop_fileop_racer
Message-ID: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Yiwen Jiang <jiangyiwen@huawei.com>
Subject: ocfs2: fix a tiny race when running dirop_fileop_racer

When running dirop_fileop_racer we found a dead lock case.

2 nodes, say Node A and Node B, mount the same ocfs2 volume.  Create
/race/16/1 in the filesystem, and let the inode number of dir 16 is less
than the inode number of dir race.

Node A                            Node B
mv /race/16/1 /race/
                                  right after Node A has got the
                                  EX mode of /race/16/, and tries to
                                  get EX mode of /race
                                  ls /race/16/

In this case, Node A has got the EX mode of /race/16/, and wants to get EX
mode of /race/.  Node B has got the PR mode of /race/, and wants to get
the PR mode of /race/16/.  Since EX and PR are mutually exclusive, dead
lock happens.

This patch fixes this case by locking in ancestor order before trying
inode number order.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   97 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer
+++ a/fs/ocfs2/namei.c
@@ -954,6 +954,65 @@ leave:
 	return status;
 }
 
+static int ocfs2_check_if_ancestor(struct ocfs2_super *osb,
+		u64 src_inode_no, u64 dest_inode_no)
+{
+	int ret = 0, i = 0;
+	u64 parent_inode_no = 0;
+	u64 child_inode_no = src_inode_no;
+	struct inode *child_inode;
+
+#define MAX_LOOKUP_TIMES 32
+	while (1) {
+		child_inode = ocfs2_iget(osb, child_inode_no, 0, 0);
+		if (IS_ERR(child_inode)) {
+			ret = PTR_ERR(child_inode);
+			break;
+		}
+
+		ret = ocfs2_inode_lock(child_inode, NULL, 0);
+		if (ret < 0) {
+			iput(child_inode);
+			if (ret != -ENOENT)
+				mlog_errno(ret);
+			break;
+		}
+
+		ret = ocfs2_lookup_ino_from_name(child_inode, "..", 2,
+				&parent_inode_no);
+		ocfs2_inode_unlock(child_inode, 0);
+		iput(child_inode);
+		if (ret < 0) {
+			ret = -ENOENT;
+			break;
+		}
+
+		if (parent_inode_no == dest_inode_no) {
+			ret = 1;
+			break;
+		}
+
+		if (parent_inode_no == osb->root_inode->i_ino) {
+			ret = 0;
+			break;
+		}
+
+		child_inode_no = parent_inode_no;
+
+		if (++i >= MAX_LOOKUP_TIMES) {
+			mlog(ML_NOTICE, "max lookup times reached, filesystem "
+					"may have nested directories, "
+					"src inode: %llu, dest inode: %llu.\n",
+					(unsigned long long)src_inode_no,
+					(unsigned long long)dest_inode_no);
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 /*
  * The only place this should be used is rename!
  * if they have the same id, then the 1st one is the only one locked.
@@ -965,6 +1024,7 @@ static int ocfs2_double_lock(struct ocfs
 			     struct inode *inode2)
 {
 	int status;
+	int inode1_is_ancestor, inode2_is_ancestor;
 	struct ocfs2_inode_info *oi1 = OCFS2_I(inode1);
 	struct ocfs2_inode_info *oi2 = OCFS2_I(inode2);
 	struct buffer_head **tmpbh;
@@ -978,9 +1038,26 @@ static int ocfs2_double_lock(struct ocfs
 	if (*bh2)
 		*bh2 = NULL;
 
-	/* we always want to lock the one with the lower lockid first. */
+	/* we always want to lock the one with the lower lockid first.
+	 * and if they are nested, we lock ancestor first */
 	if (oi1->ip_blkno != oi2->ip_blkno) {
-		if (oi1->ip_blkno < oi2->ip_blkno) {
+		inode1_is_ancestor = ocfs2_check_if_ancestor(osb, oi2->ip_blkno,
+				oi1->ip_blkno);
+		if (inode1_is_ancestor < 0) {
+			status = inode1_is_ancestor;
+			goto bail;
+		}
+
+		inode2_is_ancestor = ocfs2_check_if_ancestor(osb, oi1->ip_blkno,
+				oi2->ip_blkno);
+		if (inode2_is_ancestor < 0) {
+			status = inode2_is_ancestor;
+			goto bail;
+		}
+
+		if ((inode1_is_ancestor == 1) ||
+				(oi1->ip_blkno < oi2->ip_blkno &&
+				inode2_is_ancestor == 0)) {
 			/* switch id1 and id2 around */
 			tmpbh = bh2;
 			bh2 = bh1;
@@ -1097,6 +1174,22 @@ static int ocfs2_rename(struct inode *ol
 			goto bail;
 		}
 		rename_lock = 1;
+
+		/* here we cannot guarantee the inodes haven't just been
+		 * changed, so check if they are nested again */
+		status = ocfs2_check_if_ancestor(osb, new_dir->i_ino,
+				old_inode->i_ino);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		} else if (status == 1) {
+			status = -EPERM;
+			mlog(ML_ERROR, "src inode %llu should not be ancestor "
+				"of new dir inode %llu\n",
+				(unsigned long long)old_inode->i_ino,
+				(unsigned long long)new_dir->i_ino);
+			goto bail;
+		}
 	}
 
 	/* if old and new are the same, this'll just do one lock. */
_
