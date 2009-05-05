From: Trond Myklebust <trond.myklebust@fys.uio.no>
Date: Tue, 05 May 2009 18:25:41 -0400
Subject: [Ocfs2-devel] copyfile semantics.
In-Reply-To: <20090505214858.GD8112@parisc-linux.org>
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
	<20090505214858.GD8112@parisc-linux.org>
Message-ID: <1241562341.5174.109.camel@heimdal.trondhjem.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Dilger <adilger@sun.com>, J?rn Engel <joern@logfs.org>, Jamie Lokier <jamie@shareable.org>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, 2009-05-05 at 15:48 -0600, Matthew Wilcox wrote:
> On Tue, May 05, 2009 at 03:44:54PM -0600, Andreas Dilger wrote:
> > > When implemented in the filesystem itself, copyfile() can be quite nice.
> > > The filesystem can create a temporary inode without visibly exposing it
> > > to userspace.  It can delete temporary inodes in journal replay after a
> > > crash.  And depending on the fs design, the read/write loop can be
> > > replaced with finer-grained reference counting.
> > 
> > I would think that copyfile() is of primary interest when it involves
> > a network filesystem, so there is no need to ship data to the client
> > doing the copy at all.  This is possible for NFS and CIFS protocol today,
> > AFAIK.  The problem with splice is that the filesystem only knows about
> > ->splice_read() and ->splice_write(), it doesn't have any opportunity
> > to optimize this further (e.g. by sending a "copyfile" RPC, or implementing
> > a reflink or whatever).
> 
> Do you mean NFSv4?  I don't know of a way to do it with traditional NFS.

It is expected to be a feature of NFSv4.2. There is a proposal currently
winding it's way through the IETF that can handle both copyfile() and
reflink() semantics.

I can help to relay the input from this discussion to the people that
are drafting the IETF proposal to ensure that the Linux community
concerns get heard.

Cheers
  Trond
