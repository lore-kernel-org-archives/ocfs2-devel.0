From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 20:40:39 +0100
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
Message-ID: <20090512194039.GD10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, "Daniel P. Berrange" <berrange@redhat.com>

James Morris wrote:
> Indeed... I think a great use-case scenario for this will be snapshotting 
> VM images, as well as fast and space-efficient instantiation of VMs.

I agree, except beware of the illusion that atomic file snapshots mean
safe VM snapshots...

To snapshot a live VM safely, you need to atomically snapshot both
the running state (memory and CPU) _and_ all its disk images
simultaneously.

Otherwise you're asking for guest filesystem corruption.

reflink() won't do that by itself, but the VM implementation could use
reflink() to make fast snapshots without significantly pausing a
running VM.

-- Jamie
