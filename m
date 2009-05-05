From: James Morris <jmorris@namei.org>
Date: Wed, 6 May 2009 08:32:07 +1000 (EST)
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505222131.GO7835@mail.oracle.com>
References: <20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
	<20090505221236.GE7574@shareable.org>
	<20090505222131.GO7835@mail.oracle.com>
Message-ID: <alpine.LRH.2.00.0905060826510.9995@tundra.namei.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Jamie Lokier <jamie@shareable.org>, jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, "Daniel P. Berrange" <berrange@redhat.com>

On Tue, 5 May 2009, Joel Becker wrote:

> 	And if your file is actually a disk image, you get snapping of
> disks for free :-)

Indeed... I think a great use-case scenario for this will be snapshotting 
VM images, as well as fast and space-efficient instantiation of VMs.


-- 
James Morris
<jmorris@namei.org>
