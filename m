From: Andreas Dilger <adilger@sun.com>
Date: Tue, 05 May 2009 15:44:54 -0600
Subject: [Ocfs2-devel] copyfile semantics.
In-Reply-To: <20090505164619.GA32180@logfs.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<20090505164619.GA32180@logfs.org>
Message-ID: <20090505214454.GP3209@webber.adilger.int>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Theodore Tso <tytso@mit.edu>, Jamie Lokier <jamie@shareable.org>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk

On May 05, 2009  18:46 +0200, J?rn Engel wrote:
> On Tue, 5 May 2009 16:36:29 +0100, Jamie Lokier wrote:
> > What is the advantage of adding the system call for the special case
> > of reflink(), when we choose not to have, say, a copyfile() system
> > call which does what "cp -a" does because doing it in user space is
> > good enough?
> 
> Given an ignorant filesystem, copyfile() will simply do the read/write
> loop in kernelspace.  So either copyfile() is just a fancy name for
> splice()

Sure, except splice() (AFAIK) doesn't allow a splice between two regular
files, only between a pipe and a file.  Maybe it has changed since the
last time I looked.  On high performance filesystems the copy_to_user()
and copy_from_user() can be a major limiting factor on IO performance,
and it is getting more significant because the single-core performance
is not improving at all.  At 1GB/s just a single copy_{to,from}_user
(read or write) will consume 40% of a single core.

If it is possible to use splice() to copy between two regular files then
that is great.  Does anything (e.g. cp) actually use this yet?

> or copyfile() will also have to create a tempfile, rename the
> tempfile when the copy is done and deal with all possible errors.  And
> if the system crashes, who will remove the tempfile on reboot?  Will the
> tempfile have a well-known name, allowing for easy DoS?  Or will it be
> random, causing much fun locating it after reboot.

Maybe I'm missing something, but why do we need a tempfile at all?
I can't imagine that people expect atomic semantics for copyfile(),
any more than they expect atomic sematics for "cp" in the face of a
crash.

> When implemented in the filesystem itself, copyfile() can be quite nice.
> The filesystem can create a temporary inode without visibly exposing it
> to userspace.  It can delete temporary inodes in journal replay after a
> crash.  And depending on the fs design, the read/write loop can be
> replaced with finer-grained reference counting.

I would think that copyfile() is of primary interest when it involves
a network filesystem, so there is no need to ship data to the client
doing the copy at all.  This is possible for NFS and CIFS protocol today,
AFAIK.  The problem with splice is that the filesystem only knows about
->splice_read() and ->splice_write(), it doesn't have any opportunity
to optimize this further (e.g. by sending a "copyfile" RPC, or implementing
a reflink or whatever).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
