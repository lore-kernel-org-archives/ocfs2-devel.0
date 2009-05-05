From: jim owens <jowens@hp.com>
Date: Tue, 05 May 2009 18:28:49 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505220459.GN7835@mail.oracle.com>
References: <20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
Message-ID: <4A00BDA1.3020809@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>, jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, oc

Jamie,

Joel Becker wrote:
> 	"Shares the data extents of the source file".

so with that clarification, do you now agree with this

 > 1) is only for filesystems with COW operation,
 >    if the fs does not support COW it returns ENOSYS.

being a requirement so the user can trust that calling
reflink() uses minimal space (inode/extentmap) and only
a change to the file will trigger a data copy.

jim
