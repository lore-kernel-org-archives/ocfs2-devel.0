From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 31 Jan 2009 01:14:47 -0000
Subject: [Ocfs2-devel] [PATCH] fs: Add new pre-allocation ioctls to vfs
 for compatibility with legacy xfs ioctls
In-Reply-To: <200901310138.34164.arnd@arndb.de>
References: <4980C71F.1010804@ankitjain.org>
	<20090130162252.7bf9c1f4.akpm@linux-foundation.org>
	<200901310138.34164.arnd@arndb.de>
Message-ID: <20090130171423.f99c88d0.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ankit Jain <me@ankitjain.org>, viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Sat, 31 Jan 2009 01:38:32 +0100 Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 31 January 2009, Andrew Morton wrote:
> > On Thu, 29 Jan 2009 02:29:11 +0530 Ankit Jain <me@ankitjain.org> wrote:
> > > +struct space_resv {
> > > +	__s16		l_type;
> > > +	__s16		l_whence;
> > > +	__s64		l_start;
> > > +	__s64		l_len;		/* len == 0 means until end of file */
> > > +	__s32		l_sysid;
> > > +	__u32		l_pid;
> > > +	__s32		l_pad[4];	/* reserve area			    */
> > > +};
> > > +
> > > +#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> > > +#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
> > 
> > Are we sure that the aligment of l_start will be reliably the same
> > across all compilers and versions thereof for all time?
> 
> On x86, the alignment differs between 32 and 64 bit, otherwise it's ok.

Is this written in a standard somewhere?  Is it guaranteed?

If some (perhaps non-gcc) compiler were to lay this out differently
(perhaps with suitable command-line options) then that's liveable
with - as long as the kernel never changes the layout.  Of course
it would be better to avoid this if poss.

The other potential issue with a structure like this is that there's a
risk that it will lead us to copy four bytes of uninitialised kernel
memory out to userspace.

IOW, it seems a generally bad idea to rely upon compiler-added padding
for this sort of thing.

> XFS handles the conversion for compat_ioctl in
> fs/xfs/linux-2.6/xfs_ioctl32.c. If this becomes a generic file ioctl,
> the conversion code should be moved to fs/compat_ioctl.c.
