From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Date: Tue, 14 Apr 2020 14:43:02 +0200
Subject: [Ocfs2-devel] [PATCH 8/8] tracefs: switch to simplefs inode
	creation API
In-Reply-To: <20200414124304.4470-1-eesposit@redhat.com>
References: <20200414124304.4470-1-eesposit@redhat.com>
Message-ID: <20200414124304.4470-9-eesposit@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nfs@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, linux-s390@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Emanuele Giuseppe Esposito <eesposit@redhat.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Uma Krishnan <ukrishn@linux.ibm.com>, linux-fsdevel@vger.kernel.org, "Manoj N. Kumar" <manoj@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>

There is no semantic change intended; the code in the simplefs.c functions in
fact was derived from debugfs and tracefs code.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 fs/tracefs/inode.c | 86 ++++------------------------------------------
 1 file changed, 7 insertions(+), 79 deletions(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index a30837a8e1d4..69e2215c797b 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -298,57 +298,6 @@ static struct file_system_type trace_fs_type = {
 };
 MODULE_ALIAS_FS("tracefs");
 
-static struct dentry *start_creating(const char *name, struct dentry *parent)
-{
-	struct dentry *dentry;
-	int error;
-
-	pr_debug("tracefs: creating file '%s'\n",name);
-
-	error = simple_pin_fs(&tracefs, &trace_fs_type);
-	if (error)
-		return ERR_PTR(error);
-
-	/* If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent)
-		parent = tracefs.mount->mnt_root;
-
-	inode_lock(parent->d_inode);
-	if (unlikely(IS_DEADDIR(parent->d_inode)))
-		dentry = ERR_PTR(-ENOENT);
-	else
-		dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry) && dentry->d_inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-EEXIST);
-	}
-
-	if (IS_ERR(dentry)) {
-		inode_unlock(parent->d_inode);
-		simple_release_fs(&tracefs);
-	}
-
-	return dentry;
-}
-
-static struct dentry *failed_creating(struct dentry *dentry)
-{
-	inode_unlock(dentry->d_parent->d_inode);
-	dput(dentry);
-	simple_release_fs(&tracefs);
-	return NULL;
-}
-
-static struct dentry *end_creating(struct dentry *dentry)
-{
-	inode_unlock(dentry->d_parent->d_inode);
-	return dentry;
-}
-
 /**
  * tracefs_create_file - create a file in the tracefs filesystem
  * @name: a pointer to a string containing the name of the file to create.
@@ -385,49 +334,28 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	if (security_locked_down(LOCKDOWN_TRACEFS))
 		return NULL;
 
-	if (!(mode & S_IFMT))
-		mode |= S_IFREG;
-	BUG_ON(!S_ISREG(mode));
-	dentry = start_creating(name, parent);
-
+	dentry = simplefs_create_file(&tracefs, &trace_fs_type,
+				      name, mode, parent, data, &inode);
 	if (IS_ERR(dentry))
 		return NULL;
 
-	inode = simple_new_inode(dentry->d_sb);
-	if (unlikely(!inode))
-		return failed_creating(dentry);
-
-	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
-	inode->i_private = data;
-	d_instantiate(dentry, inode);
-	fsnotify_create(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 
 static struct dentry *__create_dir(const char *name, struct dentry *parent,
 				   const struct inode_operations *ops)
 {
-	struct dentry *dentry = start_creating(name, parent);
+	struct dentry *dentry;
 	struct inode *inode;
 
+	dentry = simplefs_create_dir(&tracefs, &trace_fs_type,
+				     name, 0755, parent, &inode);
 	if (IS_ERR(dentry))
 		return NULL;
 
-	inode = simple_new_inode(dentry->d_sb);
-	if (unlikely(!inode))
-		return failed_creating(dentry);
-
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	inode->i_op = ops;
-	inode->i_fop = &simple_dir_operations;
-
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
-	d_instantiate(dentry, inode);
-	inc_nlink(dentry->d_parent->d_inode);
-	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry);
+	return simplefs_finish_dentry(dentry, inode);
 }
 
 /**
-- 
2.25.2
