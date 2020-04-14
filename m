From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Date: Tue, 14 Apr 2020 14:43:00 +0200
Subject: [Ocfs2-devel] [PATCH 6/8] simplefs: add file creation functions
In-Reply-To: <20200414124304.4470-1-eesposit@redhat.com>
References: <20200414124304.4470-1-eesposit@redhat.com>
Message-ID: <20200414124304.4470-7-eesposit@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nfs@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, linux-s390@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Emanuele Giuseppe Esposito <eesposit@redhat.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Uma Krishnan <ukrishn@linux.ibm.com>, linux-fsdevel@vger.kernel.org, "Manoj N. Kumar" <manoj@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>

A bunch of code is duplicated between debugfs and tracefs, unify it to the
simplefs library.

The code is very similar, except that dentry and inode creation are unified
into a single function (unlike start_creating in debugfs and tracefs, which
only takes care of dentries).  This adds an output parameter to the creation
functions, but pushes all error recovery into fs/simplefs.c.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 fs/simplefs.c            | 150 +++++++++++++++++++++++++++++++++++++++
 include/linux/simplefs.h |  19 +++++
 2 files changed, 169 insertions(+)

diff --git a/fs/simplefs.c b/fs/simplefs.c
index c59eb8d996be..3e48a288beb3 100644
--- a/fs/simplefs.c
+++ b/fs/simplefs.c
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/simplefs.h>
 #include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/fsnotify.h>
 
 static DEFINE_SPINLOCK(pin_fs_lock);
 
@@ -42,3 +44,151 @@ struct inode *simple_alloc_anon_inode(struct simple_fs *fs)
 	return alloc_anon_inode(fs->mount->mnt_sb);
 }
 EXPORT_SYMBOL(simple_alloc_anon_inode);
+
+static struct dentry *failed_creating(struct simple_fs *fs, struct dentry *dentry)
+{
+	inode_unlock(d_inode(dentry->d_parent));
+	dput(dentry);
+	simple_release_fs(fs);
+	return ERR_PTR(-ENOMEM);
+}
+
+struct dentry *simplefs_create_dentry(struct simple_fs *fs, struct file_system_type *type,
+				      const char *name, struct dentry *parent,
+				      struct inode **inode)
+{
+	struct dentry *dentry;
+	int error;
+
+	pr_debug("creating file '%s'\n", name);
+
+	if (IS_ERR(parent))
+		return parent;
+
+	error = simple_pin_fs(fs, type);
+	if (error) {
+		pr_err("Unable to pin filesystem for file '%s'\n", name);
+		return ERR_PTR(error);
+	}
+
+	/* If the parent is not specified, we create it in the root.
+	 * We need the root dentry to do this, which is in the super
+	 * block. A pointer to that is in the struct vfsmount that we
+	 * have around.
+	 */
+	if (!parent)
+		parent = fs->mount->mnt_root;
+
+	inode_lock(d_inode(parent));
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (!IS_ERR(dentry) && d_really_is_positive(dentry)) {
+		if (d_is_dir(dentry))
+			pr_err("Directory '%s' with parent '%s' already present!\n",
+			       name, parent->d_name.name);
+		else
+			pr_err("File '%s' in directory '%s' already present!\n",
+			       name, parent->d_name.name);
+		dput(dentry);
+		dentry = ERR_PTR(-EEXIST);
+	}
+
+	if (IS_ERR(dentry)) {
+		inode_unlock(d_inode(parent));
+		simple_release_fs(fs);
+	}
+
+
+	if (IS_ERR(dentry))
+		return dentry;
+
+	*inode = simple_new_inode(fs->mount->mnt_sb);
+	if (unlikely(!(*inode))) {
+		pr_err("out of free inodes, can not create file '%s'\n",
+		       name);
+		return failed_creating(fs, dentry);
+	}
+
+	return dentry;
+}
+EXPORT_SYMBOL(simplefs_create_dentry);
+
+struct dentry *simplefs_create_file(struct simple_fs *fs, struct file_system_type *type,
+				    const char *name, umode_t mode,
+				    struct dentry *parent, void *data,
+				    struct inode **inode)
+{
+	struct dentry *dentry;
+
+	WARN_ON((mode & S_IFMT) && !S_ISREG(mode));
+	mode |= S_IFREG;
+
+	dentry = simplefs_create_dentry(fs, type, name, parent, inode);
+
+	if (IS_ERR(dentry))
+		return dentry;
+
+	(*inode)->i_mode = mode;
+	(*inode)->i_private = data;
+
+	return dentry;
+}
+EXPORT_SYMBOL(simplefs_create_file);
+
+struct dentry *simplefs_finish_dentry(struct dentry *dentry, struct inode *inode)
+{
+	d_instantiate(dentry, inode);
+	if (S_ISDIR(inode->i_mode)) {
+		inc_nlink(d_inode(dentry->d_parent));
+		fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
+	} else {
+		fsnotify_create(d_inode(dentry->d_parent), dentry);
+	}
+	inode_unlock(d_inode(dentry->d_parent));
+	return dentry;
+}
+EXPORT_SYMBOL(simplefs_finish_dentry);
+
+struct dentry *simplefs_create_dir(struct simple_fs *fs, struct file_system_type *type,
+				   const char *name, umode_t mode, struct dentry *parent,
+				   struct inode **inode)
+{
+	struct dentry *dentry;
+
+	WARN_ON((mode & S_IFMT) && !S_ISDIR(mode));
+	mode |= S_IFDIR;
+
+	dentry = simplefs_create_dentry(fs, type, name, parent, inode);
+	if (IS_ERR(dentry))
+		return dentry;
+
+	(*inode)->i_mode = mode;
+	(*inode)->i_op = &simple_dir_inode_operations;
+	(*inode)->i_fop = &simple_dir_operations;
+
+	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	inc_nlink(*inode);
+	return dentry;
+}
+EXPORT_SYMBOL(simplefs_create_dir);
+
+struct dentry *simplefs_create_symlink(struct simple_fs *fs, struct file_system_type *type,
+				       const char *name, struct dentry *parent,
+				       const char *target, struct inode **inode)
+{
+	struct dentry *dentry;
+	char *link = kstrdup(target, GFP_KERNEL);
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+
+	dentry = simplefs_create_dentry(fs, type, name, parent, inode);
+	if (IS_ERR(dentry)) {
+		kfree_link(link);
+		return dentry;
+	}
+
+	(*inode)->i_mode = S_IFLNK | S_IRWXUGO;
+	(*inode)->i_link = link;
+	(*inode)->i_op = &simple_symlink_inode_operations;
+	return dentry;
+}
+EXPORT_SYMBOL(simplefs_create_symlink);
diff --git a/include/linux/simplefs.h b/include/linux/simplefs.h
index c62ab526414e..cc53eed0bc3d 100644
--- a/include/linux/simplefs.h
+++ b/include/linux/simplefs.h
@@ -14,4 +14,23 @@ extern void simple_release_fs(struct simple_fs *);
 
 extern struct inode *simple_alloc_anon_inode(struct simple_fs *fs);
 
+extern struct dentry *simplefs_create_dentry(struct simple_fs *fs,
+					     struct file_system_type *type,
+					     const char *name, struct dentry *parent,
+					     struct inode **inode);
+struct dentry *simplefs_finish_dentry(struct dentry *dentry, struct inode *inode);
+
+extern struct dentry *simplefs_create_file(struct simple_fs *fs,
+					   struct file_system_type *type,
+					   const char *name, umode_t mode,
+					   struct dentry *parent, void *data,
+					   struct inode **inode);
+extern struct dentry *simplefs_create_dir(struct simple_fs *fs, struct file_system_type *type,
+					  const char *name, umode_t mode, struct dentry *parent,
+					  struct inode **inode);
+extern struct dentry *simplefs_create_symlink(struct simple_fs *fs, struct file_system_type *type,
+					      const char *name, struct dentry *parent,
+					      const char *target, struct inode **inode);
+
+
 #endif
-- 
2.25.2
