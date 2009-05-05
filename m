From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 15:24:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505221101.GD7574@shareable.org>
References: <20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
	<20090505221101.GD7574@shareable.org>
Message-ID: <20090505222418.GP7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 11:11:01PM +0100, Jamie Lokier wrote:
> Joel Becker wrote:
> > 	"Shares the data extents of the source file".  I should hope
> > that chmod doesn't require copying out all the data.
> 
> Oh... I was under the impression that it would, because the
> man-page-of-sorts says attributes must be the same and the following
> question:
> 
> > Jamie Lokier wrote:
> > > reflink() sounds useful already, but is there a compelling reason why
> > > both files must have the same attributes, and changing attributes will
>                                                   ------------------------
> > > break the COW?
>     --------------
> >
> > Yeah, because without it you can't use it for snapshotting.
>   ----
> 
> If that's not true, then I change my tune substantially and like
> reflink() semantics a lot more. :-)

	I was yeah'ing the first part.  The explicit requirement of
reflink is sharing the data extents (including xattr extents).  So, for
example, both the btrfs and ocfs2 implementations can
chmod/chown/utimes/etc all they want after the reflink is done, and no
data sharing is broken.  The data sharing is broken only via data
modification.  Both btrfs and ocfs2 will only copy the hunk modified,
leaving the rest of the file shared; you won't have long wait times for
the CoW of large files just because you modified one byte.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
