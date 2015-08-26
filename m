From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 26 Aug 2015 15:11:26 -0700
Subject: [Ocfs2-devel] [patch 03/28] ocfs2: flush inode data to disk and
	free inode when i_count becomes zero
Message-ID: <55de398e.qJZDB8tZ/RYyOgvJ%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: flush inode data to disk and free inode when i_count becomes zero

Disk inode deletion may be heavily delayed when one node unlink a file
after the same dentry is freed on another node(say N1) because of memory
shrink but inode is left in memory.  This inode can only be freed while N1
doing the orphan scan work.

However, N1 may skip orphan scan for several times because other nodes may
do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
and it hurts the user experience.  So we think the inode should be freed
after the data flushed to disk when i_count becomes zero to avoid such
circumstances.

Signed-off-by: Joyce.xue <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero
+++ a/fs/ocfs2/inode.c
@@ -1191,17 +1191,19 @@ void ocfs2_evict_inode(struct inode *ino
 int ocfs2_drop_inode(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int res;
 
 	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink, oi->ip_flags);
 
-	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
-		res = 1;
-	else
-		res = generic_drop_inode(inode);
+	assert_spin_locked(&inode->i_lock);
+	inode->i_state |= I_WILL_FREE;
+	spin_unlock(&inode->i_lock);
+	write_inode_now(inode, 1);
+	spin_lock(&inode->i_lock);
+	WARN_ON(inode->i_state & I_NEW);
+	inode->i_state &= ~I_WILL_FREE;
 
-	return res;
+	return 1;
 }
 
 /*
_
