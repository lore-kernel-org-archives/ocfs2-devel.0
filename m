From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 11 Jun 2008 16:10:10 +0200
Subject: [Ocfs2-devel] [BUG] deadlock between configfs_rmdir() and
	sys_rename() (WAS	Re: [RFC][PATCH 4/4] configfs: Make
	multiple default_group)	destructions lockdep friendly
In-Reply-To: <20080610173654.GA23829@ca-server1.us.oracle.com>
References: <20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
	<20080606230154.GK29740@mail.oracle.com>
	<20080609110353.GK18153@localhost>
	<20080609125443.GL18153@localhost>
	<20080610015800.GD14820@mail.oracle.com>
	<20080610101427.GA4048@localdomain>
	<20080610173654.GA23829@ca-server1.us.oracle.com>
Message-ID: <20080611141010.GP18153@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 10:36:54AM -0700, Joel Becker wrote:
> On Tue, Jun 10, 2008 at 12:14:27PM +0200, Louis Rilling wrote:
> > On Mon, Jun 09, 2008 at 06:58:00PM -0700, Joel Becker wrote:
> > > 	I'm not against the latter AT ALL.  I just haven't come up with
> > > it yet - we can't remove parts of the tree, it must be all or none.
> > > Hence, we lock them all speculatively.
> > 
> > I'm slowly thinking about a solution, but I don't know the VFS enough
> > yet, especially regarding dentry invalidation and locking. Would it be possible
> > to start an rmdir() by moving the group to some unreachable place? We could
> > probably use the mutex of the configfs subsystem and enlarge its scope to
> > protect against concurrent mkdir(), check for user-created items under the
> > group (and descendent default groups) to remove, invalidate all dentries and
> > actually remove the group. Do you think that something is feasible in this way?
> 
> 	Nope, because you may have live objects below you - the rmdir
> should fail, and nothing should change.  Sure, you could put it back,
> but in the middle there is a period where another process tries to look
> at the tree and gets ENOENT.  That's not right.

Sure. I was more thinking about moving the to-be-removed group only once we ware
sure that nobody would use it anymore (thanks to the subsys mutex enlarging its
scope for instance). Anyway, see below.

> 	But blocking lookup another way might work.  If we keep that
> rename process out of looking up its targets (blocked on a lock we hold)
> it might work.
> 	Note, btw, that the create side (populate_groups) is safe,
> because we hold the creating parent's i_mutex throughout the entire
> process.

Yes, mkdir() is completely ok. In fact, I am able to formally prove its locking
correctness (from lockdep's point of view) provided that I_MUTEX_PARENT ->
I_MUTEX_CHILD is correct. I'll come back to lockdep annotations once the
rmdir() bug is fixed.

> 	Hey, can we use d_revalidate?  Here's the issue.  rename, when
> going to lookup the objects it wants to lock, is getting them out of
> cached_lookup - there dcache locking is all that protects it.  I was
> first thinking we could take the dentry locks to block this out.  But
> rather, why not fail d_revalidate and force a locked lookup?  So, when
> we go to lock one of these groups for detaching, we also set a flag on
> the configfs_dirent.  We add a configfs_d_revalidate function that
> returns based on that flag - if set, revalidation is needed.  Thus, when
> another process comes in to look at the object we've already locked, it
> blocks waiting to find it.
> 	See, in do_rename, it does do_path_lookup() before actually
> calling lock_rename().  It would block there waiting for our speculative
> removal.  We'd either fail rmdir, and those lookups would succeed, or
> we'd succeed rmdir, and the lookup fails.
> 	The only concern is, can the reverse happen?  We get past the
> lookups in do_rename(), and then another process comes into rmdir() -
> will they deadlock there?

No we cannot make d_revalidate() temporarily fail, because it will either make
do_lookup() fail (return value < 0), or will tell do_revalidate() to call
d_invalidate() (return value == 0), which will either definitely invalidate the
dentry stored in item->ci_dentry (unlikely because its use count should be > 1,
right?), or return success to do_lookup().

The good news is that we can make d_revalidate() block on whatever we use to
protect rmdir() against racing operations. I'll try to send a patch levaraging
the subsystem's mutexes later in the day.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
