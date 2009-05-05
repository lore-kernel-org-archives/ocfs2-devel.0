From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 23:12:36 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505220459.GN7835@mail.oracle.com>
References: <20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
Message-ID: <20090505221236.GE7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv

Joel Becker wrote:
> On Tue, May 05, 2009 at 10:57:11PM +0100, Jamie Lokier wrote:
> > jim owens wrote:
> > > 3) the granularity of the COW (1-byte write may cause
> > >    1-block up through whole file copy) is fs-dependent.
> > 
> > And yet ENOSYS if the fs cannot implement any COW, and it isn't
> > possible for userspace to duplicate the semantics by explicit copying?
> 
> 	The point-in-time of the snapshot is what's important here.

Don't we have a slight problem that useful point-in-time snapshots
really need to snapshot whole directory trees?  Otherwise you get the
same inter-file inconsistency issues that you get intra-file from old
fashioned copying.

-- Jamie
