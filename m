From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 8 Feb 2014 10:16:28 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Check existence of old dentry in
	ocfs2_link()
Message-ID: <52F5937C.5050507@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  System call linkat first calls user_path_at(), check the existence
of old dentry, and then calls vfs_link()->ocfs2_link() to do the actual
work. There may exist a race when Node A create a hard link for file
while node B rm it.

         Node A                          Node B
user_path_at()
  ->ocfs2_lookup(),
find old dentry exist
                                rm file, add inode say inodeA
                                to orphan_dir

call ocfs2_link(),create a
hard link for inodeA.

                                rm the link, add inodeA to orphan_dir
                                again

When orphan_scan work start, it calls ocfs2_queue_orphans() to do
the main work. It first tranverses entrys in orphan_dir, linking
all inodes in this orphan_dir to a list look like this:
inodeA->inodeB->...->inodeA
When tranvering this list, it will fall into loop, calling iput() again and again.
And finally trigger BUG_ON(inode->i_state & I_CLEAR).

Signed-off-by: joyce <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/ocfs2/namei.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f4d609b..3683643 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -664,6 +664,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
+	u64 old_de_ino;
 
 	trace_ocfs2_link((unsigned long long)OCFS2_I(inode)->ip_blkno,
 			 old_dentry->d_name.len, old_dentry->d_name.name,
@@ -686,6 +687,22 @@ static int ocfs2_link(struct dentry *old_dentry,
 		goto out;
 	}
 
+	err = ocfs2_lookup_ino_from_name(dir, old_dentry->d_name.name,
+			old_dentry->d_name.len, &old_de_ino);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	/*
+	 * Check whether another node removed the source inode while we
+	 * were in the vfs.
+	 */
+	if (old_de_ino != OCFS2_I(inode)->ip_blkno) {
+		err = -ENOENT;
+		goto out;
+	}
+
 	err = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
 					dentry->d_name.len);
 	if (err)
-- 
1.8.4.3
