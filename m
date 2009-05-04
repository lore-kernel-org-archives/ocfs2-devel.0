From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 3 May 2009 19:51:44 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] fs: Add vfs_reflink() and the
	->reflink() inode	operation.
In-Reply-To: <20090503080324.GB27287@infradead.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-3-git-send-email-joel.becker@oracle.com>
	<20090503080324.GB27287@infradead.org>
Message-ID: <20090504025144.GD24653@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sun, May 03, 2009 at 04:03:25AM -0400, Christoph Hellwig wrote:
> > +int vfs_reflink(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
> >
> >+{
> 
> Would be nice to have a little kerneldoc comment for it.  Also please
> avoid the > 80 har lines

	Both good points.

> > +EXPORT_SYMBOL(vfs_reflink);
> 
> No really good reason to export this.  Most vfs_ helpers are exported
> for nfsd, and I can't really see nfsd use this anytime soon.

	While we're going forward with the system call, ocfs2's going to
support the ioctl for older kernels.  I was planning to have mainline
just reroute the ioctl to vfs_reflink(), rather than have the ioctl
just break.
 
Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
