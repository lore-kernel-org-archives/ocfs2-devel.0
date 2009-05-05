From: Jamie Lokier <jamie@shareable.org>
Date: Wed, 6 May 2009 00:14:50 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505222418.GP7835@mail.oracle.com>
References: <20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
	<20090505221101.GD7574@shareable.org>
	<20090505222418.GP7835@mail.oracle.com>
Message-ID: <20090505231450.GL7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv

Joel Becker wrote:
> Both btrfs and ocfs2 will only copy the hunk modified, leaving the
> rest of the file shared; you won't have long wait times for the CoW
> of large files just because you modified one byte.

Which is brilliant and perfect, and should be near the top of any
marketing materials for reflink :-)

-- Jamie
