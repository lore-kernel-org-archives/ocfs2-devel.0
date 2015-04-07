From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 07 Apr 2015 14:56:02 -0700
Subject: [Ocfs2-devel] [patch 6/9] ocfs2: fix a tiny case that inode can not
	removed.
Message-ID: <55245272.yTVatCR+9/iCOZF6%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: fix a tiny case that inode can not removed.

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
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed
+++ a/fs/ocfs2/namei.c
@@ -1291,6 +1291,15 @@ static int ocfs2_rename(struct inode *ol
 	}
 	parents_locked = 1;
 
+	if (!new_dir->i_nlink) {
+		mlog(ML_ERROR, "new dir %llu has been removed, inode %llu "
+				"can not be moved into it.",
+				(unsigned long long)new_dir->i_ino,
+				(unsigned long long)old_inode->i_ino);
+		status = -EACCES;
+		goto bail;
+	}
+
 	/* make sure both dirs have bhs
 	 * get an extra ref on old_dir_bh if old==new */
 	if (!new_dir_bh) {
_
