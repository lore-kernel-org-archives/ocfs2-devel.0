From: Luis Chamberlain <mcgrof@kernel.org>
Date: Thu, 16 Apr 2020 06:44:05 +0000
Subject: [Ocfs2-devel] [PATCH 1/8] apparmor: just use vfs_kern_mount to
	make .null
In-Reply-To: <20200414124304.4470-2-eesposit@redhat.com>
References: <20200414124304.4470-1-eesposit@redhat.com>
	<20200414124304.4470-2-eesposit@redhat.com>
Message-ID: <20200416064405.GP11244@42.do-not-panic.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>, Goldwyn Rodrigues <goldwynr@gmail.com>
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, linux-s390@vger.kernel.org, ocfs2-devel@oss.oracle.com, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-fsdevel@vger.kernel.org, "Manoj N. Kumar" <manoj@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, linux-nfs@vger.kernel.org, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, linux-security-module@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, Joel Becker <jlbec@evilplan.org>, Alexander Viro <viro@zeniv.linux.org.uk>

On Tue, Apr 14, 2020 at 02:42:55PM +0200, Emanuele Giuseppe Esposito wrote:
> aa_mk_null_file is using simple_pin_fs/simple_release_fs with local
> variables as arguments, for what would amount to a simple
> vfs_kern_mount/mntput pair if everything was inlined.  Just use
> the normal filesystem API since the reference counting is not needed
> here.

*Why* is refcounting not needed here?

   Luis

> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  security/apparmor/apparmorfs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
> index 280741fc0f5f..828bb1eb77ea 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -2525,14 +2525,14 @@ struct path aa_null;
>  
>  static int aa_mk_null_file(struct dentry *parent)
>  {
> -	struct vfsmount *mount = NULL;
> +	struct file_system_type *type = parent->d_sb->s_type;
> +	struct vfsmount *mount;
>  	struct dentry *dentry;
>  	struct inode *inode;
> -	int count = 0;
> -	int error = simple_pin_fs(parent->d_sb->s_type, &mount, &count);
>  
> -	if (error)
> -		return error;
> +	mount = vfs_kern_mount(type, SB_KERNMOUNT, type->name, NULL);
> +	if (IS_ERR(mount))
> +		return PTR_ERR(mount);
>  
>  	inode_lock(d_inode(parent));
>  	dentry = lookup_one_len(NULL_FILE_NAME, parent, strlen(NULL_FILE_NAME));
> @@ -2561,7 +2561,7 @@ static int aa_mk_null_file(struct dentry *parent)
>  	dput(dentry);
>  out:
>  	inode_unlock(d_inode(parent));
> -	simple_release_fs(&mount, &count);
> +	mntput(mount);
>  	return error;
>  }
>  
> -- 
> 2.25.2
> 
