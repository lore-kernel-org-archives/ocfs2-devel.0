From: Jamie Lokier <jamie@shareable.org>
Date: Wed, 6 May 2009 00:12:10 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <4A00BDA1.3020809@hp.com>
References: <20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com> <4A00BDA1.3020809@hp.com>
Message-ID: <20090505231210.GK7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

jim owens wrote:
> Jamie,
> 
> Joel Becker wrote:
> >	"Shares the data extents of the source file".
> 
> so with that clarification, do you now agree with this
> 
> > 1) is only for filesystems with COW operation,
> >    if the fs does not support COW it returns ENOSYS.
> 
> being a requirement so the user can trust that calling
> reflink() uses minimal space (inode/extentmap) and only

Yes I do, if

> a change to the file will trigger a data copy.

"file" means the data, not the permissions and timestamps :-)

Otherwise there's still a user trust issue, since many applications
come to mind who would like to chmod/chown/futimes immediately after
making the reflink, and they need to trust that the result uses
minimal space.

I realise now in the OCFS2/BTRFS cases this isn't an issue since
changing the data only unshares a small region of the data anyway.

But that's quite a difficult thing to ask of any filesystem which
implements reflink(), whereas saying "attribute changes do not trigger
COW" (well maybe chown/chgrp do) is reasonable for any filesystems
which can implement reflink().

-- Jamie
