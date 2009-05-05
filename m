From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 15:39:16 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <alpine.LRH.2.00.0905060826510.9995@tundra.namei.org>
References: <1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
	<20090505221236.GE7574@shareable.org>
	<20090505222131.GO7835@mail.oracle.com>
	<alpine.LRH.2.00.0905060826510.9995@tundra.namei.org>
Message-ID: <20090505223916.GS7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>
Cc: Theodore Tso <tytso@mit.edu>, Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, jim owens <jowens@hp.com>, "Daniel P. Berrange" <berrange@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Wed, May 06, 2009 at 08:32:07AM +1000, James Morris wrote:
> On Tue, 5 May 2009, Joel Becker wrote:
> 
> > 	And if your file is actually a disk image, you get snapping of
> > disks for free :-)
> 
> Indeed... I think a great use-case scenario for this will be snapshotting 
> VM images, as well as fast and space-efficient instantiation of VMs.

	I did the initial design work (ocfs2's refcount tree structure)
to support snapping VM images.  I came up with the reflink() interface
when I realized the structure would back space-efficient instantiation,
or "shallow clones".  Since then, we've been coming up with more and
more fun tricks that the generic reflink() interface allows us to do.

Joel

-- 

"For every complex problem there exists a solution that is brief,
     concise, and totally wrong."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
