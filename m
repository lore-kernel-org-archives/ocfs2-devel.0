From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 19 May 2009 12:32:44 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090519132057.419b9de0@bike.lwn.net>
References: <20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
	<20090519132057.419b9de0@bike.lwn.net>
Message-ID: <20090519193244.GB25521@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 19, 2009 at 01:20:57PM -0600, Jonathan Corbet wrote:
> One tiny little thing that crossed my mind as I was looking at this...
> 
> > - REFLINK_ATTR_NONE is 0 and REFLINK_ATTR_ALL is ~0.
> 
> That, I think, could lead to unexpected results if different flags
> (perhaps controlling different aspects of behavior altogether) are
> added in the future.  Might it make more sense for REFLINK_ATTR_ALL to
> be something like 0xffff, with the current implementation insisting
> that all other bits are zero?  That would leave room for expansion of
> the set of things covered by the "preserve all" semantics while,
> simultaneously, allowing the addition of different types of flags
> entirely.

	I considered that, but really a process specifying
REFLINK_ATTR_ALL wants a complete snapshot.  So if we add things to our
inodes later, and then you have an old program asking for "a complete
snapshot", it won't get it.  It'll get a partial snapshot, missing the
things we added later.
	Conversely, a newer program that knows about the new things will
get an error on an older kernel when it asks for the complete snapshot.
	You'll note I called this 'preserve', not 'flags'.  It's not a
set of behavioral flags, it's a mask of attributes to preserve.

Joel
-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
