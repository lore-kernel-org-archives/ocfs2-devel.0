From: Chris Mason <chris.mason@oracle.com>
Date: Mon, 11 May 2009 20:54:37 -0400
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <20090511234624.GC28209@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
	<20090511204924.GC30293@mail.oracle.com> <4A08AB5D.7090706@hp.com>
	<20090511234624.GC28209@mail.oracle.com>
Message-ID: <1242089677.17873.12.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: jmorris@namei.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, jim owens <jowens@hp.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, 2009-05-11 at 16:46 -0700, Joel Becker wrote:
> On Mon, May 11, 2009 at 06:49:01PM -0400, jim owens wrote:
> > Joel Becker wrote:
> >> On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
> >>> - fix the
> >>> +	if (S_ISDIR(inode->i_mode))
> >>> +		return -EPERM;
> >>>
> >>>   to be an ISREG check unless you have an argument for
> >>>   special files and symlinks being COWed.
> >>
> >> 	Jim, if you have a real problem this prevents, I'm all ears.
> >> And if others concur that restricting it to regular files is the right
> >> way to go, I can be convinced.
> >
> > My only problem was my past experience on non-Linux systems
> > where once we said it works for multiple file types, we had
> > to support that forever across all filesystems.  We could add
> > support for more types but not eliminate supported ones.
> 
> 	Someone else pointed out that a naive user might reflink a block
> device file and expect the device contents to be copied-on-write.
> Obviously wrong if you understand filesystems, but let's just prevent
> that misunderstanding.  S_ISREG() it is.

Btrfs won't be doing single directories, and I'd rather keep using a
dedicated ioctl for snapshotting whole subvolumes.

The semantics described here all sound sane, if this looks like the
final-ish rev I'll try to find someone interested in wiring it up to the
btrfs clone ioctl.  It just needs a wrapper to create the new inode and
copy xattrs/acls over.

Thanks for doing all of this Joel.

-chris
