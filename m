From: Andreas Dilger <adilger@dilger.ca>
Date: Tue, 22 Oct 2019 16:13:53 -0600
Subject: [Ocfs2-devel] [PATCH v14 1/5] Add flags option to get xattr
 method paired to __vfs_getxattr
In-Reply-To: <20191022204453.97058-2-salyzyn@android.com>
References: <20191022204453.97058-1-salyzyn@android.com>
	<20191022204453.97058-2-salyzyn@android.com>
Message-ID: <8CE5B6E8-DCB7-4F0B-91C1-48030947F585@dilger.ca>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Hugh Dickins <hughd@google.com>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Mike Marshall <hubcap@omnibond.com>, James Morris <jmorris@namei.org>, devel@lists.orangefs.org, Eric Van Hensbergen <ericvh@gmail.com>, Joel Becker <jlbec@evilplan.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@hammerspace.com>, Mathieu Malaterre <malat@debian.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, Casey Schaufler <casey@schaufler-ca.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Kleikamp <shaggy@kernel.org>, linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, CIFS <linux-cifs@vger.kernel.org>, Paul Moore <paul@paul-moore.com>, "Darrick J . Wong" <darrick.wong@oracle.>


On Oct 22, 2019, at 2:44 PM, Mark Salyzyn <salyzyn@android.com> wrote:
> 
> Replace arguments for get and set xattr methods, and __vfs_getxattr
> and __vfs_setaxtr functions with a reference to the following now
> common argument structure:
> 
> struct xattr_gs_args {
> 	struct dentry *dentry;
> 	struct inode *inode;
> 	const char *name;
> 	union {
> 		void *buffer;
> 		const void *value;
> 	};
> 	size_t size;
> 	int flags;
> };

As part of this change (which is touching all of the uses of these
fields anyway) it would be useful to give these structure fields a
prefix like "xga_" so that they can be easily found with tags.
Otherwise, there are so many different "dentry" and "inode" fields
in various structures that it is hard to find the right one.

> #define __USE_KERNEL_XATTR_DEFS
> 
> -#define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
> -#define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
> +#define XATTR_CREATE	 0x1	/* set value, fail if attr already exists */
> +#define XATTR_REPLACE	 0x2	/* set value, fail if attr does not exist */
> +#ifdef __KERNEL__ /* following is kernel internal, colocated for maintenance */
> +#define XATTR_NOSECURITY 0x4	/* get value, do not involve security check */
> +#endif

Now that these arguments are separated out into their own structure,
rather than using "int flags" (there are a million different flags in
the kernel and easily confused) it would be immediately clear *which*
flags are used here with a named enum, like:

enum xattr_flags {
	XATTR_CREATE	= 0x1,	/* set value, fail if attr already exists */
	XATTR_REPLACE	= 0x2,	/* set value, fail if attr does not exist */
#ifdef __KERNEL__ /* following is kernel internal, colocated for maintenance */
	XATTR_NOSECURITY= 0x4,  /* get value, do not involve security check */
#endif
};

and use this in the struct like:

struct xattr_gs_args {
	struct dentry	*xga_dentry;
	struct inode	*xga_inode;
	const char	*xga_name;
	union {
		void		*xga_buffer;
		const void	*xga_value;
	};
	size_t		 xga_size;
	enum xattr_flags xga_flags;
};

Beyond the benefit for the reader to understand the code better, this
can also allow the compiler to warn if incorrect values are being
assigned to this field.

Cheers, Andreas





-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 873 bytes
Desc: Message signed with OpenPGP
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20191022/0bca25a2/attachment.bin 
