From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 21 May 2008 15:09:43 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 0/3] configfs: Make nested default
	groups	lockdep-friendly
In-Reply-To: <1211367577.6463.91.camel@lappy.programming.kicks-ass.net>
References: <20080520163320.025971210@kerlabs.com>
	<20080520095810.1d50d247@infradead.org>
	<20080520215639.GG26609@mail.oracle.com>
	<20080520151341.058f2df4@infradead.org>
	<1211361784.6463.68.camel@lappy.programming.kicks-ass.net>
	<4833F89F.7080707@kerlabs.com>
	<1211367577.6463.91.camel@lappy.programming.kicks-ass.net>
Message-ID: <20080521220943.GB25117@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>, Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, May 21, 2008 at 12:59:37PM +0200, Peter Zijlstra wrote:
> On Wed, 2008-05-21 at 12:25 +0200, Louis Rilling wrote:
> > Yes this could solve part of the issue, at the price of duplicating the
> > inode mutex class. However, this still does not solve the issue when
> > deleting config_groups, since in that case all nodes of the tree are
> > locked. Thinking about adding lockdep support for concurrent locking of
> > the direct children of a node in a tree...
> 
> Why doesn't sysfs have this problem? - the code says configfs was
> derived from sysfs.

	sysfs objects are created from kernel code.  Things register
kobjects one at a time, so it has the usual parent->child dentry
relationships.  This
is handled by I_MUTEX_PARENT/CHILD just fine.
	configfs item creation is triggered from userspace.  mkdir(2)
creates an item in a group.  If that item is a group itself, it can have
child groups that automatically exist ("default_groups").  All of the
default_groups must appear before the userspace-invoked mkdir(2)
returns.  Worse, rmdir(2) must happen atomically as well for these
default_groups (user-created children fail rmdir(2) with ENOTEMPTY as
expected).  For safety, the entire tree under the group being removed
must be locked out.  Hence the recursive locking of the default_group
subdirs. 

> Also, do you really need to hold all locks when removing something?
> sound like a bit overdone. Also realise there is a maximum number of
> held locks - various people have already requested it to be increased or
> made dynamic. We're reluctant in doing so because we feel lock chains
> should not be of unlimited length. The deeper the chains the bigger the
> PI overhead etc..

	Because we need to make sure that all default_group children
(and their default_group children, etc) are locked and safe to remove
from the dcache, we need to hold all of these locks.  I haven't come up
with a safe way to do it atomically while rolling the locks up and down
the tree.

> As to modifying lockdep - it currently doesn't know about trees and
> teaching it about them isn't easy.

	Yeah, it might not be practical.  Hence Louis' most recent patch
to disable lockdep when we start walking one of these trees.  But Arjan
is right that we shouldn't reject it out of hand - lockdep would be nice
here if we can find a way to make it work.

Joel

-- 

	f/8 and be there.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
