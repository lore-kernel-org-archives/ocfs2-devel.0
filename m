From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 14 Sep 2009 17:54:17 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
Message-ID: <20090915005417.GD4507@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Sep 14, 2009 at 05:31:27PM -0700, Linus Torvalds wrote:
> On Mon, 14 Sep 2009, Joel Becker wrote:
> > 	reflink doesn't merely guarantee atomicity, it guarantees the
> > shared data extents.
> 
> Why?
> 
> That just limits its usefulness. What's the reason for that sophistry, 
> except to try to argue for a name that makes no sense?

	This originally came from the idea of creating file snapshots.
That was our original goal, but the more generic reflink call allows
more than snapshots to be built.  You can use it to implement copyfile
or clone or a variety of things.  But the snapshot capability is what
really motivates, and removing the shared data requirement means
removing that capability.  Like any API we have, if it can degrade, you
have to assume it degraded.  A reflink/copyfile that can just copy means
you have assume it copied and didn't conserve space.  This makes it
useless for snapshotting or cloning.
	In the reflink discussion before, I proposed that a separate
copyfile() syscall could be written that uses the same ->reflink() inode
operation but allows degradation in the storage handling.  This would be
a little more capable than a glibc copyfile() written around reflink
because it would get the atomicity right.  The separate copyfile/reflink
calls would handle the different requirements of storage handling.  I
just concentrated on reflink and didn't worry about that alternate
copyfile at the time being.
	I'm open to another proposal on how to do it.  As a user, I need
a way to ask for a reflink/copyfile that fails if it can't share the
data.  Things like snapshots and cloning gold VM images can't be
doubling the storage.  They become pointless.
	 About the name, the reflink name came out of "you call it like
link(2)" and "the storage is reference counted CoW".  It really works
well as "ln -r".  Folks at the filesystem summit liked it, so I didn't
change it.  It's not so much that it has to be "reflink", but I've
avoided "copyfile" because copyfile intuitively sounds like you
describe, including the plain-copy fallback.  Want me to call the
requires-shared-data-because-its-a-snap version snapfileat(2)?
Something better?

> > 	Well, obviously I started from the fact that we don't have
> > flink().  But it doesn't really fit anyway.  reflink is a namespace
> > operation - give me a new item in the namespace that shares the data
> > extents of the old item.
> 
> That's not a namespace op, EXCEPT FOR THE NEW NAME.
> 
> The data you share from has no namespace component to it, except as a 
> lookup. But a 'fd' is equally descriptive of the shared data.

	Ok, I gather that you find freflink (and by extension, flink)
compelling.  I can certainly implement it.

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
