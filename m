From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 17:03:13 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <1241538102.7244.72.camel@think.oraclecorp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
Message-ID: <20090505160313.GF31100@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Mason <chris.mason@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Chris Mason wrote:
> > > The main difference between reflink and the btrfs ioctl is that in the
> > > btrfs ioctl the destination file must already exist.  The btrfs code can
> > > also do range replacements in the destination file, but I'd agree with
> > > Joel that we don't want to toss the kitchen sink into something nice and
> > > clean like reflink.
> > 
> > Ah, now that I know about the BTRFS data-cloning ioctl... :-)
> > 
> > I'm wondering why reflink() is needed at all.  Can't it be done in
> > userspace, using the BTRFS ioctl?  The hard part in userspace seems to
> > be copying the file attributes, but "cp -a" and other tools manage.
> > 
> 
> reflink is a subset of what the btrfs ioctl does, and that's a good
> thing.  The way they've added support for this to ocfs2 is really cool,
> and the same ideas could be used in other filesystems.
> 
> So, I'd rather see a system call that everyone can implement, and if
> btrfs hangs on to the ioctl for extra features, even better.

Realistically, very few existing filesystems can implement this system call.

I agree that it's much more likely that a filesystem can implement
reflink() than BTRFS' more flexible data cloning though.

-- Jamie
