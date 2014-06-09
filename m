From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2014 13:04:07 -0700
Subject: [Ocfs2-devel] [patch 8/8] ocfs2: manually do the iput once
	ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod
Message-ID: <20140609200408.046B25A4A39@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: manually do the iput once ocfs2_add_entry failed in ocfs2_symlink and ocfs2_mknod

When the call to ocfs2_add_entry() failed in ocfs2_symlink() and
ocfs2_mknod(), iput() will not be called during dput(dentry) because no
d_instantiate(), and this will lead to umount hung.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-manually-do-the-iput-once-ocfs2_add_entry-failed-in-ocfs2_symlink-and-ocfs2_mknod
+++ a/fs/ocfs2/namei.c
@@ -231,6 +231,7 @@ static int ocfs2_mknod(struct inode *dir
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct posix_acl *default_acl = NULL, *acl = NULL;
+	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -423,6 +424,8 @@ static int ocfs2_mknod(struct inode *dir
 		goto leave;
 	}
 
+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
 				 &lookup);
@@ -469,6 +472,16 @@ leave:
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
 	if ((status < 0) && inode) {
+		if (dl) {
+			ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+			ocfs2_lock_res_free(&dl->dl_lockres);
+			BUG_ON(dl->dl_count != 1);
+			spin_lock(&dentry_attach_lock);
+			dentry->d_fsdata = NULL;
+			spin_unlock(&dentry_attach_lock);
+			kfree(dl);
+			iput(inode);
+		}
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
@@ -1735,6 +1748,7 @@ static int ocfs2_symlink(struct inode *d
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 	int did_block_signals = 0;
+	struct ocfs2_dentry_lock *dl = NULL;
 
 	trace_ocfs2_symlink_begin(dir, dentry, symname,
 				  dentry->d_name.len, dentry->d_name.name);
@@ -1923,6 +1937,8 @@ static int ocfs2_symlink(struct inode *d
 		goto bail;
 	}
 
+	dl = dentry->d_fsdata;
+
 	status = ocfs2_add_entry(handle, dentry, inode,
 				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
 				 &lookup);
@@ -1957,6 +1973,16 @@ bail:
 	if (xattr_ac)
 		ocfs2_free_alloc_context(xattr_ac);
 	if ((status < 0) && inode) {
+		if (dl) {
+			ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+			ocfs2_lock_res_free(&dl->dl_lockres);
+			BUG_ON(dl->dl_count != 1);
+			spin_lock(&dentry_attach_lock);
+			dentry->d_fsdata = NULL;
+			spin_unlock(&dentry_attach_lock);
+			kfree(dl);
+			iput(inode);
+		}
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
 		clear_nlink(inode);
 		iput(inode);
_
