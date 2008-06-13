From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Jun 2008 13:17:46 -0700
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080613104513.GI30804@localhost>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
	<20080612191348.GE5377@mail.oracle.com>
	<20080612222558.GA4012@localdomain>
	<20080613024130.GD20581@mail.oracle.com>
	<20080613104513.GI30804@localhost>
Message-ID: <20080613201746.GB20576@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Louis,
	Can I just say, you're the first person to do serious review
other than myself, and I really appreciate it :-)

On Fri, Jun 13, 2008 at 12:45:13PM +0200, Louis Rilling wrote:
> On Thu, Jun 12, 2008 at 07:41:31PM -0700, Joel Becker wrote:
> Unfortunately, thinking a bit more about it I found some issues with
> i_mutex lock free detach_prep(), but nothing that can't be fixed ;)
> 	Between detach_prep() in A and mkdir() in a default group A/B:
> detach_prep() can be called in the middle of attach_group(), for instance after
> having attached A/B/C, but attach_group() may then fail (because of memory
> pressure for instance) while attaching C's default group A/B/C/D. This would
> lead to both mkdir(A/B/C) and rmdir(A) failing, the reason for rmdir failure
> being at best obscure: the user would have expected to either see mkdir succeed
> and rmdir fail because of the new A/B/C group, or see mkdir fail and rmdir
> succeed because no user-created group lived under A. Solution: tag A/B with
> USET_IN_MKDIR on mkdir entrance, remove that tag on mkdir exit, and retry
> detach_prep() as long as USET_IN_MKDIR is found under A/*.

	I see what you are saying here.  I'm not sure if that is worth
the complexity - we can say "it was kind of there".  No one will ever
hit it :-)  But let me think about it more.

> 	Between rmdir() and readdir(): dir_open() might add a configfs_dirent
> to a default group A/B that detach_prep() already marked with USET_DROPPING.
> This could result in detach_groups() dropping the dirent and make readdir() in
> A/B crash afterwards. Solution: check USET_DROPPING in dir_open() and fail if
> it is set.

	I was trying to see why this could happen, given that we can
come to this from other places - the dir could have been open before we
set USET_DROPPING.  Oh!  We actually fail rmdir with ENOTEMPTY when the
dir is open?  That's wrong.  Ignore it though - we'll fix it later.
	But back to your concern.  configfs_readdir() can't crash for
two reasons.  First, detach_groups() won't remove this dirent.  A
readdir placeholder has s_element==NULL.  Note the check in
detach_groups():

	if (!sd->s_element ||
	    !(sd->s_type & CONFIGFS_USET_DEFAULT))
		continue;

It skips our readdir placeholder, allowing us to free it in dir_close().
	There's another reason this can't be a problem.  If we get into
detach_groups(), we take i_mutex, locking out readdir().  Then we delete
the directory, setting S_DEAD.  In vfs_readdir(), they check
IS_DEADDIR() after getting i_mutex.  So they will see S_DEAD and not
call our ->readdir().  S_DEAD is important.  Someone could actually have
our default_group as their cwd.  S_DEAD prevents them from doing
anything :-)

> 	Between rmdir() and lookup(): several lookup() called under A/* while
> rmdir(A) in the middle of detach_groups() could return inconsistent results (for
> instance some default groups being there and some other ones not). Solution:
> lock dirent_lock for the whole lookup() duration, check USET_DROPPING of current
> dir, and fail with ENOENT if it is set.

	Nah, we don't care about the spurious lookups.  This is a normal
race of i_mutex.  USET_DROPPING is not a way to prevent VFS views from
changing - it's only a way to prevent new children.
	Remember, ->lookup() comes with i_mutex locking.  We hold
i_mutex during the entire delete, so they can't call ->lookup() until
we're done with a directory.  Conversely, if they win i_mutex and ->lookup()
a default group, then try to use it after we've removed it, they'll just
ENOENT.  This is evident back in do_rename().  They call lookup, which
takes and drops locks, then call lock_rename() to get the locks back.
And they can handle ENOENT at that point.

> I was speaking as if we replaced i_mutex protection with dirent_lock
> protection for a whole mkdir(), that is taking the lock before attach_* and
> releasing it after.

	Ok.  I think that's not the way to go, what you currently have
is better.

> > 	I'm not even sure what you said here :-)
> 
> I was just saying that with i_mutex lock free detach_prep(), we have kind of
> optimistic mkdir(), with conflicts resolved as error cases of attach_*.

	Basically, the concerns you had above.

> The intermediate conditions that really matter are:
> 1/ the existence of partial default groups trees (I mean configfs_dirent trees)
>    in the middle of attach_group() and detach_group(),

	This is your first case, the mkdir ENOMEM vs rmdir ENOTEMPTY.

> 2/ the existence of default group trees that are tagged as USET_DROPPING and
>    should be treated as not existing anymore.

	This is not an issue.  USET_DROPPING does *not* mean it went
away.  It means we're safe to make it go away.  We protect the actual
going-away with i_mutex.  And that's normal VFS behavior.

Joel

-- 

"I don't know anything about music. In my line you don't have
 to."
        - Elvis Presley

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
