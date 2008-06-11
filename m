From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 11 Jun 2008 19:30:47 +0200
Subject: [Ocfs2-devel] [BUG] deadlock between configfs_rmdir() and
	sys_rename() (WAS	Re: [RFC][PATCH 4/4] configfs: Make
	multiple default_group)	destructions lockdep friendly
In-Reply-To: <20080611141010.GP18153@localhost>
References: <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
	<20080606230154.GK29740@mail.oracle.com>
	<20080609110353.GK18153@localhost>
	<20080609125443.GL18153@localhost>
	<20080610015800.GD14820@mail.oracle.com>
	<20080610101427.GA4048@localdomain>
	<20080610173654.GA23829@ca-server1.us.oracle.com>
	<20080611141010.GP18153@localhost>
Message-ID: <20080611173047.GR18153@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 04:10:10PM +0200, Louis Rilling wrote:
> On Tue, Jun 10, 2008 at 10:36:54AM -0700, Joel Becker wrote:
> > 	Hey, can we use d_revalidate?  Here's the issue.  rename, when
> > going to lookup the objects it wants to lock, is getting them out of
> > cached_lookup - there dcache locking is all that protects it.  I was
> > first thinking we could take the dentry locks to block this out.  But
> > rather, why not fail d_revalidate and force a locked lookup?  So, when
> > we go to lock one of these groups for detaching, we also set a flag on
> > the configfs_dirent.  We add a configfs_d_revalidate function that
> > returns based on that flag - if set, revalidation is needed.  Thus, when
> > another process comes in to look at the object we've already locked, it
> > blocks waiting to find it.
> > 	See, in do_rename, it does do_path_lookup() before actually
> > calling lock_rename().  It would block there waiting for our speculative
> > removal.  We'd either fail rmdir, and those lookups would succeed, or
> > we'd succeed rmdir, and the lookup fails.
> > 	The only concern is, can the reverse happen?  We get past the
> > lookups in do_rename(), and then another process comes into rmdir() -
> > will they deadlock there?
> 
> No we cannot make d_revalidate() temporarily fail, because it will either make
> do_lookup() fail (return value < 0), or will tell do_revalidate() to call
> d_invalidate() (return value == 0), which will either definitely invalidate the
> dentry stored in item->ci_dentry (unlikely because its use count should be > 1,
> right?), or return success to do_lookup().
> 
> The good news is that we can make d_revalidate() block on whatever we use to
> protect rmdir() against racing operations. I'll try to send a patch levaraging
> the subsystem's mutexes later in the day.

I've spoken too fast. Doing things in d_revalidate() (or even in
configfs_lookup()) is just too early: after they are called and before
lock_rename(), nothing can prevent rmdir() from being called.

I'm afraid that we need a way to get rid of the whole tree locking in
configfs_detach_prep(). Imagine that we protect all calls to configfs_rmdir()
and configfs_mkdir() with a global mutex (say configfs_dir_mutex). Is it still
needed to take default group's i_mutex in configfs_detach_prep() to check for
the validity of the rmdir()?
	After this check, we could set a REMOVING flag in configfs_dirent of all
default groups (could actually be done by configfs_detach_prep(), making
configfs_detach_rollback() resetting the flag), release configfs_dir_mutex, and
then call configfs_detach_group(), with detach_groups() taking default group's
i_mutex right before calling configfs_detach_group() recursively (this would
lead to the same path locking as in populate_groups() or
configfs_depend_prep()).
	On mkdir() side, once configfs_dir_mutex is acquired, we first check the
REMOVING flag, and proceed if it is not set.

Just tell me if you think that it's feasible, and I'll send you a patch if it's
ok.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
