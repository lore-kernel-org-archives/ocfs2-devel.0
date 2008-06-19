From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Jun 2008 15:03:03 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH 3/3] configfs: Fix failing
	symlink() making	rmdir() fail
In-Reply-To: <20080619092842.GK30804@localhost>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
	<1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com>
	<20080617221528.GA29091@mail.oracle.com>
	<20080618114043.GB30804@localhost>
	<20080618201107.GF16780@ca-server1.us.oracle.com>
	<20080619092842.GK30804@localhost>
Message-ID: <20080619220303.GB10888@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Jun 19, 2008 at 11:28:42AM +0200, Louis Rilling wrote:
> On Wed, Jun 18, 2008 at 01:11:07PM -0700, Joel Becker wrote:
> > On Wed, Jun 18, 2008 at 01:40:43PM +0200, Louis Rilling wrote:
> > > The problem is rmdir() of the target item (see below). ATTACHING only protects
> > > us from rmdir() of the parent. This is the exact reason why I attach the link to
> > > the target in last place, where we know that we won't have to rollback.
> > 
> > 	Why wouldn't it protect the target, given that detach_prep()
> > will be called against the target if it's being rmdir'd?
> 
> Because
> 1/ setting and clearing ATTACHING could badly interact with mkdir()/symlink()
> inside the target item (for instance clear the flag before mkdir() has finished
> attaching a new item); to avoid this we could use a different flag, but

	Ok, true, we don't have a lock to protect mkdir.

> 2/ rmdir() of the target cannot lock the inode of the new symlink's parent like
> it does for mkdir(), otherwise we would risk a deadlock with other symlink() and
> sys_rename(). This means that rmdir() should retry aggressively, in a busy
> waiting loop, or replacing mutex_lock()/mutex_unlock() with yield().

	Yup, we'd have to have some other form of retry - note that this
is all spinlock territory.  Thus, it should be fast.  By the time
rmdir() gets back out to the toplevel, symlink/mkdir should be done
creating whatever they needed and waiting on the dirnet_lock.  Then
rmdir waits again on the lock.  It "should" be bang-bang.
	Yes, I know, assumptions all around.

> > 	We *can* do that, but we try to isolate it - hand-building VFS
> > objects is complex and error prone, and I try to isolate that to
> > specific cases.  I'd rather avoid it when not necessary.
> 
> In the case of symlink(), building a new inode is what all filesystems must do.
> The only "bad" side-effect I can figure out of having to rollback is that the
> new entry will be visible for a short time until it is removed.

	It won't be visible, because we hold i_mutex until we're done.

> Anyway, do you think that the "solutions" above are more acceptable?

	The code for create then destroy was quite ugly.  Maybe it
struck me because of that.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
