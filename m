From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 15:04:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505215711.GA7574@shareable.org>
References: <20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
Message-ID: <20090505220459.GN7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 10:57:11PM +0100, Jamie Lokier wrote:
> jim owens wrote:
> > 3) the granularity of the COW (1-byte write may cause
> >    1-block up through whole file copy) is fs-dependent.
> 
> And yet ENOSYS if the fs cannot implement any COW, and it isn't
> possible for userspace to duplicate the semantics by explicit copying?

	The point-in-time of the snapshot is what's important here.

> Do we say anything about attribute changes triggering COW or not, or
> leave it fs-dependent?  Given 3) fs-dependent makes sense, but it's
> nice to know in advance if { reflink -R old_tree saved_tree; chmod -R
> a-w saved_tree } will be as expensive as copying or as cheap as linking.

	"Shares the data extents of the source file".  I should hope
that chmod doesn't require copying out all the data.

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
