From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 13 Jun 2008 12:45:13 +0200
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080613024130.GD20581@mail.oracle.com>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
	<20080612191348.GE5377@mail.oracle.com>
	<20080612222558.GA4012@localdomain>
	<20080613024130.GD20581@mail.oracle.com>
Message-ID: <20080613104513.GI30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Jun 12, 2008 at 07:41:31PM -0700, Joel Becker wrote:
> On Fri, Jun 13, 2008 at 12:25:58AM +0200, Louis Rilling wrote:
> > On Thu, Jun 12, 2008 at 12:13:48PM -0700, Joel Becker wrote:
> > > On Thu, Jun 12, 2008 at 03:31:27PM +0200, Louis Rilling wrote:
> > > > Locking rules for configfs_dirent linkage mutations are the same plus the
> > > > requirement of taking configfs_dirent_lock. For configfs_dirent walking, one can
> > > > either take appropriate i_mutex as before, or take configfs_dirent_lock.
> > > 
> > > 	Nope, you *must* take configfs_dirent_lock now.  You've removed
> > > i_mutex protection in the last patch.
> > 
> > Oh well. Do you mean because of CONFIGFS_USET_DROPPING being set without
> > i_mutex locked? This is the only mutation (except in the s_links patch) done
> > without i_mutex locked. I thought that actually either other
> > configfs_dirent traversals like readdir() and dir_lseek() would prevent
> > detach_prep() from succeeding because they add dirents before, or are done in
> > places where detach_prep() cannot do harm because new_dirent() fails whenever it
> > sees CONFIGFS_USET_DROPPING: detach_attrs() and detach_groups()
> > must ignore CONFIGFS_USET_DROPPING, depend_prep() is protected since the
> > whole path is locked from configfs root, lookup() can succeed since at worst its
> > result will be invalidated when actually detaching the default groups. The only
> > function for which I can not figure out is configfs_hash_and_remove(), but it is
> > not used.
> 
> 	I don't mean that your code is wrong, I mean that the comment is
> unclear.  The locking rules aren't "you can use i_mutex or dirent_lock,
> take your pick".  I think you are right that configfs_detach_prep() is
> safe to set dropping as it does without i_mutex.
> 	This is related to the discussion below about VFS visible
> changes (i_mutex protection) vs subsystem internal changes (dirent_lock
> protection).  The protections have different scope, but your comment
> made them sound interchangable. 

Agreed.

> 
> > 	I admit that the case of symlink() needs an extra check to ensure
> > that the target is not about to be removed. The bug was already there
> > though, right?
> > 	Anyway, if it looks conceptually simpler to use
> > configfs_dirent_lock (probably better a mutex in that case) wherever
> > i_mutex are supposed to protect configfs_dirent traversals, I'm ok with it.
> 
> 	Leave it as a spinlock.
> 	Going over the changes, I was pretty convinced your detach_prep
> was safe vis-a-vis mkdir.  You're under i_mutex for the immediate
> directory, and both attach_* and detach_* are under the immediate
> i_mutex when they make the change.  Also, you have your readdir and
> lookup walking s_children without a lock.  I *think* that's safe, because
> it's also against the immediate directory, and thus the vfs is holding
> i_mutex for you.

Unfortunately, thinking a bit more about it I found some issues with
i_mutex lock free detach_prep(), but nothing that can't be fixed ;)
	Between detach_prep() in A and mkdir() in a default group A/B:
detach_prep() can be called in the middle of attach_group(), for instance after
having attached A/B/C, but attach_group() may then fail (because of memory
pressure for instance) while attaching C's default group A/B/C/D. This would
lead to both mkdir(A/B/C) and rmdir(A) failing, the reason for rmdir failure
being at best obscure: the user would have expected to either see mkdir succeed
and rmdir fail because of the new A/B/C group, or see mkdir fail and rmdir
succeed because no user-created group lived under A. Solution: tag A/B with
USET_IN_MKDIR on mkdir entrance, remove that tag on mkdir exit, and retry
detach_prep() as long as USET_IN_MKDIR is found under A/*.
	Between rmdir() and readdir(): dir_open() might add a configfs_dirent
to a default group A/B that detach_prep() already marked with USET_DROPPING.
This could result in detach_groups() dropping the dirent and make readdir() in
A/B crash afterwards. Solution: check USET_DROPPING in dir_open() and fail if
it is set.
	Between rmdir() and lookup(): several lookup() called under A/* while
rmdir(A) in the middle of detach_groups() could return inconsistent results (for
instance some default groups being there and some other ones not). Solution:
lock dirent_lock for the whole lookup() duration, check USET_DROPPING of current
dir, and fail with ENOENT if it is set.

I'll send a corrected patch later.

>  
> > And we should not take other i_mutex in populate_groups() and
> > populate_attrs(), otherwise deadlocks could happen.
> 
> 	Huh, we certainly should.  perhaps you are speaking as if we
> were turning dirent_lock into a mutex.  We're not turning dirent_lock
> into a mutex yet.

I was speaking as if we replaced i_mutex protection with dirent_lock
protection for a whole mkdir(), that is taking the lock before attach_* and
releasing it after.

> 
> > > 	Now, the only thing that sees this intermediate condition is
> > > configfs itself.  Everyone else is protected by i_mutex.  I guess it's
> > > OK - but can you comment that fact?  i_mutex does *not* protect
> > > traversal of the configfs_dirent tree, but it does prevent the outside
> > > world from seeing the intermediate states.
> > 
> > The only intermediate conditions that may hurt one's mind is that an
> > mkdir() (resp. symlink()) racing with an rmdir() can successfuly call
> > make_item()/make_group() (resp. allow_link()) and immediately fail when
> > finalizing with attach_item()/attach_group() (resp. create_link()). So, from
> > userspace and the VFS this seems like "mkdir foo/bar/baz" simply failed because
> > of "rmdir foo", while at the same time from the subsystem point of view this
> > seems like userspace did "mkdir foo/bar/baz; rmdir foo/bar/baz; rmdir foo".
> > As I pointed out in the rename fix, this however can already happen when
> > attach_item()/attach_group() (resp. create_link()) fails because of
> > memory pressure for instance.
> 
> 	I'm not even sure what you said here :-)

I was just saying that with i_mutex lock free detach_prep(), we have kind of
optimistic mkdir(), with conflicts resolved as error cases of attach_*.

The intermediate conditions that really matter are:
1/ the existence of partial default groups trees (I mean configfs_dirent trees)
   in the middle of attach_group() and detach_group(),
2/ the existence of default group trees that are tagged as USET_DROPPING and
   should be treated as not existing anymore.
	These intermediate conditions lead to the issues pointed out above, and
will be correctly handled (I hope) in the coming corrected patch.

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080613/7fb62cf0/attachment.bin 
