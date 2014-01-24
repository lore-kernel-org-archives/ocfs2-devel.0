From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:47:06 -0800
Subject: [Ocfs2-devel] [patch 07/11] ocfs2: check existence of old dentry in
	ocfs2_link()
Message-ID: <20140124204707.2470E5A4203@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: check existence of old dentry in ocfs2_link()

System call linkat first calls user_path_at(), check the existence of old
dentry, and then calls vfs_link()->ocfs2_link() to do the actual work. 
There may exist a race when Node A create a hard link for file while node
B rm it.

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

When orphan_scan work start, it calls ocfs2_queue_orphans() to do the main
work.  It first tranverses entrys in orphan_dir, linking all inodes in
this orphan_dir to a list look like this:

	inodeA->inodeB->...->inodeA

When tranvering this list, it will fall into loop, calling iput() again
and again.  And finally trigger BUG_ON(inode->i_state & I_CLEAR).

Signed-off-by: joyce <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-check-existence-of-old-dentry-in-ocfs2_link fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-check-existence-of-old-dentry-in-ocfs2_link
+++ a/fs/ocfs2/namei.c
@@ -644,6 +644,7 @@ static int ocfs2_link(struct dentry *old
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
+	u64 old_de_ino;
 
 	trace_ocfs2_link((unsigned long long)OCFS2_I(inode)->ip_blkno,
 			 old_dentry->d_name.len, old_dentry->d_name.name,
@@ -665,6 +666,18 @@ static int ocfs2_link(struct dentry *old
 		err = -ENOENT;
 		goto out;
 	}
+
+	err = ocfs2_lookup_ino_from_name(dir, old_dentry->d_name.name,
+			old_dentry->d_name.len, &old_de_ino);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (old_de_ino != OCFS2_I(inode)->ip_blkno) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	err = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
 					dentry->d_name.len);
_
