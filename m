From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Jun 2008 15:34:41 -0700
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080613215401.GA4153@localdomain>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
	<20080612191348.GE5377@mail.oracle.com>
	<20080612222558.GA4012@localdomain>
	<20080613024130.GD20581@mail.oracle.com>
	<20080613104513.GI30804@localhost>
	<20080613201746.GB20576@mail.oracle.com>
	<20080613215401.GA4153@localdomain>
Message-ID: <20080613223441.GE20576@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2008 at 11:54:01PM +0200, Louis Rilling wrote:
> On Fri, Jun 13, 2008 at 01:17:46PM -0700, Joel Becker wrote:
> > Louis,
> > 	Can I just say, you're the first person to do serious review
> > other than myself, and I really appreciate it :-)
> 
> It's just that I use configfs in my own work, and I'm playing hard with
> it, especially with modules. So I need to understand exactly what it
> does, and what is possible with it.

	I'm all for it.  And see my other email responding to Luis about
the current concerns with configfs.

> > 	I see what you are saying here.  I'm not sure if that is worth
> > the complexity - we can say "it was kind of there".  No one will ever
> > hit it :-)  But let me think about it more.
> 
> To me it's an issue only if we want to provide some atomic view to
> userspace: either userspace sees a group with all of its default groups,
> or it sees none. So the question is: does userspace need such atomicity?
> Currently configfs provides it, so this would be a userspace visible
> change if we break it.

	People *won't* see that.  default groups are populated and
cleaned under i_mutex.  The race of mkdir vs rmdir isn't about seeing
partial default groups, it's about the ENOMEM racing the ENOTEMPTY.  It
doesn't impact lookup or other operations.  We can fix it.  I'm just not
sure it's worth the complexity (and this is an open question).

> > 	There's another reason this can't be a problem.  If we get into
> > detach_groups(), we take i_mutex, locking out readdir().  Then we delete
> > the directory, setting S_DEAD.  In vfs_readdir(), they check
> > IS_DEADDIR() after getting i_mutex.  So they will see S_DEAD and not
> > call our ->readdir().  S_DEAD is important.  Someone could actually have
> > our default_group as their cwd.  S_DEAD prevents them from doing
> > anything :-)
> 
> As I told you in a previous email, I'm missing some VFS skills, so
> thanks again for the explanation.

	Oh, don't worry about that.  There's nothing wrong with not
knowing - that's why you asked me.  Now you do :-)

> Sure, my only concern is the atomic view of userspace: can userspace
> tolerate that (pwd=A/B, with B a default group of A, B having default groups C
> and D, and A being removed) 'ls C' returns error because default group C is
> already removed and 'ls D' is ok because default group D is not removed yet?

	They can't see that.  We take i_mutex in detach_group.  This
locks out lookup and readdir.  When we're done with detach_group, all
default groups are gone.

> > > 2/ the existence of default group trees that are tagged as USET_DROPPING and
> > >    should be treated as not existing anymore.
> > 
> > 	This is not an issue.  USET_DROPPING does *not* mean it went
> > away.  It means we're safe to make it go away.  We protect the actual
> > going-away with i_mutex.  And that's normal VFS behavior.
> 
> Again this is the concern of atomicity from userspace point of view: to
> provide such atomic view, mkdir(), lookup(), readdir(), and probably
> attributes open() should just fail when done in a default group flagged with
> USET_DROPPING.

	It's not atomic, though, and never has been.  I'm not quite sure
what you are unsure of here.  Let me try to clarify a little.
	Are you worried about two separate runs of the ls(1) command?

  # ls A/B/C
  # ls A/B/D

These can't be atomic, because someone else could rmdir(1) in the
middle:

  # ls A/B/C
  # rmdir A/B
  # ls A/B/D
  ls: No such file or directory

This is perfectly normal, and there is no way to prevent it - it is
separate entrances to the system call.
	Do you mean inside one call?  That is "ls A/B" would print "C"
but not "D"?  That cannot happen, because we hold B's i_mutex during
detach_group.  So, if readdir beat us to i_mutex, it lists "C D".  If we
win, we remove both before releasing B's i_Mutex, and readdir errors
with ENOENT - we removed B.
	I'm not quite sure what inconsistency you are asking about here.

Joel

-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
