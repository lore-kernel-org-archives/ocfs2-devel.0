From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 16 Jun 2008 13:30:11 +0200
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080613223441.GE20576@mail.oracle.com>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
	<20080612191348.GE5377@mail.oracle.com>
	<20080612222558.GA4012@localdomain>
	<20080613024130.GD20581@mail.oracle.com>
	<20080613104513.GI30804@localhost>
	<20080613201746.GB20576@mail.oracle.com>
	<20080613215401.GA4153@localdomain>
	<20080613223441.GE20576@mail.oracle.com>
Message-ID: <20080616113011.GQ30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2008 at 03:34:41PM -0700, Joel Becker wrote:
> > To me it's an issue only if we want to provide some atomic view to
> > userspace: either userspace sees a group with all of its default groups,
> > or it sees none. So the question is: does userspace need such atomicity?
> > Currently configfs provides it, so this would be a userspace visible
> > change if we break it.
> 
> 	People *won't* see that.  default groups are populated and
> cleaned under i_mutex.  The race of mkdir vs rmdir isn't about seeing
> partial default groups, it's about the ENOMEM racing the ENOTEMPTY.  It
> doesn't impact lookup or other operations.  We can fix it.  I'm just not
> sure it's worth the complexity (and this is an open question).

It's not that difficult to implement, you may just find it a bit ugly... I hope
to send you a corrected "rename fix" today.

> 
> > Sure, my only concern is the atomic view of userspace: can userspace
> > tolerate that (pwd=A/B, with B a default group of A, B having default groups C
> > and D, and A being removed) 'ls C' returns error because default group C is
> > already removed and 'ls D' is ok because default group D is not removed yet?
> 
> 	They can't see that.  We take i_mutex in detach_group.  This
> locks out lookup and readdir.  When we're done with detach_group, all
> default groups are gone.

If I understand correctly, lookup() is not called each time userspace does ls,
and in configfs case, it is never called for existing items since the d_cache is
populated as soon as the user creates items. So lookup() does not block 'ls'
during rmdir() (unless it is a lookup for a never accessed attribute). I think
that this is the point that invalidates all my theory about atomicity :)

> 
> > > > 2/ the existence of default group trees that are tagged as USET_DROPPING and
> > > >    should be treated as not existing anymore.
> > > 
> > > 	This is not an issue.  USET_DROPPING does *not* mean it went
> > > away.  It means we're safe to make it go away.  We protect the actual
> > > going-away with i_mutex.  And that's normal VFS behavior.
> > 
> > Again this is the concern of atomicity from userspace point of view: to
> > provide such atomic view, mkdir(), lookup(), readdir(), and probably
> > attributes open() should just fail when done in a default group flagged with
> > USET_DROPPING.
> 
> 	It's not atomic, though, and never has been.  I'm not quite sure
> what you are unsure of here.  Let me try to clarify a little.
> 	Are you worried about two separate runs of the ls(1) command?
> 
>   # ls A/B/C
>   # ls A/B/D
> 
> These can't be atomic, because someone else could rmdir(1) in the
> middle:
> 
>   # ls A/B/C
>   # rmdir A/B
>   # ls A/B/D
>   ls: No such file or directory
> 
> This is perfectly normal, and there is no way to prevent it - it is
> separate entrances to the system call.
> 	Do you mean inside one call?  That is "ls A/B" would print "C"
> but not "D"?  That cannot happen, because we hold B's i_mutex during
> detach_group.  So, if readdir beat us to i_mutex, it lists "C D".  If we
> win, we remove both before releasing B's i_Mutex, and readdir errors
> with ENOENT - we removed B.
> 	I'm not quite sure what inconsistency you are asking about here.

The scenario that made me worry was more:
process 1:
/* PWD=A/B */
# ls C
ls: No such file or directory
/* some sync between process 1 and 2 */
process 2:
/* PWD=A/D */
# ls E
/* ok */
# ls E
ls: No such file or directory

From a user's point of view, this looks as if somebody did 'rmdir A; mkdir A;
rmdir A', while there actually were only 'rmdir A'.

If there were no d_cache, this would be impossible with the current
implementation of detach_prep() locking all default groups. But with the d_cache
this has always been possible.

Anyway, I give up with this (wrong) atomicity concern.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/b3829e80/attachment.bin 
