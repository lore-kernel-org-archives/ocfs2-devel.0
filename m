From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 23:06:58 +0100
Subject: [Ocfs2-devel] copyfile semantics.
In-Reply-To: <20090505214454.GP3209@webber.adilger.int>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<20090505164619.GA32180@logfs.org>
	<20090505214454.GP3209@webber.adilger.int>
Message-ID: <20090505220658.GC7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Andreas Dilger wrote:
> If it is possible to use splice() to copy between two regular files then
> that is great.  Does anything (e.g. cp) actually use this yet?

It's mentioned earlier in this thread that BTRFS has an ioctl() for
copying parts of files into other files, and will share the data
between both files.

With a bit of plumbing, splice() could probably be persuaded to call
the mechanism which BTRFS provides.

-- Jamie
