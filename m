From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 9 Jun 2008 14:54:43 +0200
Subject: [Ocfs2-devel] [BUG] deadlock between configfs_rmdir() and
	sys_rename() (WAS Re:	[RFC][PATCH 4/4] configfs: Make
	multiple default_group)	destructions lockdep friendly
In-Reply-To: <20080609110353.GK18153@localhost>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
	<20080606230154.GK29740@mail.oracle.com>
	<20080609110353.GK18153@localhost>
Message-ID: <20080609125443.GL18153@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi,

Following an intuition, I just found a deadlock resulting from the whole default
groups tree locking in configfs_detach_prep().

I can reproduce the bug with the attached patch (which just enlarges an existing
window in VFS lock_rename()) and the following procedure, assuming that configfs
is mounted under /config, and ocfs2 is loaded with cluster support:

# mkdir /config/cluster/foo
# cd /config/cluster/foo
# ln -s /bin/mv ~/test_deadlock
# ~/test_deadlock heartbeat/dead_threshold node/bar

and in another shell, right after having launched test_deadlock:

# rmdir /config/cluster/foo

First, lockdep warns as usual (see below), and after two minutes (standard task
deadlock parameters), we get the dead lock alerts:

<log>

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc5 #13
---------------------------------------------
rmdir/3997 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff802d2131>] configfs_detach_prep+0x58/0xaa

but task is already holding lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296070>] vfs_rmdir+0x49/0xac

other info that might help us debug this:
2 locks held by rmdir/3997:
 #0:  (&sb->s_type->i_mutex_key#3/1){--..}, at: [<ffffffff80297c77>] do_rmdir+0x82/0x108
 #1:  (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296070>] vfs_rmdir+0x49/0xac

stack backtrace:
Pid: 3997, comm: rmdir Not tainted 2.6.26-rc5 #13

Call Trace:
 [<ffffffff8024aa65>] __lock_acquire+0x8d2/0xc78
 [<ffffffff802495ec>] find_usage_backwards+0x9d/0xbe
 [<ffffffff802d2131>] configfs_detach_prep+0x58/0xaa
 [<ffffffff8024b1de>] lock_acquire+0x51/0x6c
 [<ffffffff802d2131>] configfs_detach_prep+0x58/0xaa
 [<ffffffff80247dad>] debug_mutex_lock_common+0x16/0x23
 [<ffffffff805d63a4>] mutex_lock_nested+0xcd/0x23b
 [<ffffffff802d2131>] configfs_detach_prep+0x58/0xaa
 [<ffffffff802d327b>] configfs_rmdir+0xb8/0x1c3
 [<ffffffff80296092>] vfs_rmdir+0x6b/0xac
 [<ffffffff80297cac>] do_rmdir+0xb7/0x108
 [<ffffffff80249d1e>] trace_hardirqs_on+0xef/0x113
 [<ffffffff805d74c4>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b0cb>] system_call_after_swapgs+0x7b/0x80

INFO: task test_deadlock:3996 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
test_deadlock D 0000000000000001     0  3996   3980
 ffff81007cc93d78 0000000000000046 ffff81007cc93d40 ffffffff808ed280
 ffffffff808ed280 ffff81007cc93d28 ffffffff808ed280 ffffffff808ed280
 ffffffff808ed280 ffffffff808ea120 ffffffff808ed280 ffff81007cdcaa10
Call Trace:
 [<ffffffff802955e3>] lock_rename+0x11e/0x126
 [<ffffffff805d641e>] mutex_lock_nested+0x147/0x23b
 [<ffffffff802955e3>] lock_rename+0x11e/0x126
 [<ffffffff80297838>] sys_renameat+0xd7/0x21c
 [<ffffffff805d74c4>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80249d1e>] trace_hardirqs_on+0xef/0x113
 [<ffffffff805d74c4>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b0cb>] system_call_after_swapgs+0x7b/0x80

INFO: lockdep is turned off.
INFO: task rmdir:3997 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rmdir         D 0000000000000000     0  3997   3986
 ffff81007cdb9dd8 0000000000000046 0000000000000000 ffffffff808ed280
 ffffffff808ed280 ffff81007cdb9d88 ffffffff808ed280 ffffffff808ed280
 ffffffff808ed280 ffffffff808ea120 ffffffff808ed280 ffff81007cde0a50
Call Trace:
 [<ffffffff802d2131>] configfs_detach_prep+0x58/0xaa
 [<ffffffff805d641e>] mutex_lock_nested+0x147/0x23b
 [<ffffffff802d2131>] configfs_detach_prep+0x58/0xaa
 [<ffffffff802d327b>] configfs_rmdir+0xb8/0x1c3
 [<ffffffff80296092>] vfs_rmdir+0x6b/0xac
 [<ffffffff80297cac>] do_rmdir+0xb7/0x108
 [<ffffffff80249d1e>] trace_hardirqs_on+0xef/0x113
 [<ffffffff805d74c4>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b0cb>] system_call_after_swapgs+0x7b/0x80

INFO: lockdep is turned off.

</log>

The issue here is that the VFS locks the i_mutex of the source and target
directories of the rename in source -> target order (because none is ascendent
of the other one), while configfs_detach_prep() takes them in default group
order (or reverse order, I'm not sure), following the order specified by the
groups' creator.

The VFS protects itself against deadlocks of two concurrent renames with
interverted source and target directories with i_sb->s_vfs_rename_mutex. Perhaps
configfs should use the same lock before calling configfs_detach_prep()?
Or maybe configfs would better find an alternative to locking the whole
default groups tree? I strongly advocate for the latter, since this could also
solve our issues with lockdep ;)

Louis

On Mon, Jun 09, 2008 at 01:03:53PM +0200, Louis Rilling wrote:
> On Fri, Jun 06, 2008 at 04:01:54PM -0700, Joel Becker wrote:
> > On Tue, Jun 03, 2008 at 06:00:34PM +0200, Louis Rilling wrote:
> > > On Mon, Jun 02, 2008 at 04:07:21PM -0700, Joel Becker wrote:
> > > > 	A couple comments.
> > > > 	First, put a BUG_ON() where you have BAD BAD BAD - we shouldn't
> > > > be creating a depth we can't delete.
> > > 
> > > I think that the best way to avoid this is to use the same numbering scheme
> > > while attaching default groups.
> > 
> > 	If I'm reading this right, when we come back up from one child
> > chain, we update the parent to be the same as the child - this is, i
> > assume, to allow all the locks to be held at once.  IOW, you are trying
> > to have all locks in the default groups have unique lock levels,
> > regardless of their depth.
> 
> Exactly, otherwise lockdep will issue a warning as soon as one tries to remove
> a config group having default groups at the same depth, because it will see two
> mutexes locked with same sub-class.
> 
> > 	This is obviously limiting on the number of default groups for
> > one item - it's a total cap, not a depth cap.  But I have another
> > concern.  We lock a particular default_group with level N, then its
> > child default_group with level N+1.  But how does that integrate with
> > VFS locking of the same mutexes?
> > 	Say we have an group G.  It has one default group D1.  D1 has a
> > default group itself, D2.  So, when we populate the groups, we lock G at
> > MUTEX_CHILD, D1 at MUTEX_CHILD+1, and D2 at MUTEX_CHILD+2.  However,
> > when the VFS navigates the tree (eg, lookup() or someone attempting an
> > rmdir() of D2's non-default child), it will lock with _PARENT and
> > _CHILD, not with our subclasses.
> > 	Am I right about this?  We won't be using the same classes as
> > the VFS, and thus won't be able to see about interactions between the
> > VFS locking and our locking?  I'd love to be wrong :-)
> 
> You are perfectly right, unfortunately. This is the reason why I proposed
> another way that temporarily disables lockdep, and let us prove the correctness
> manually (actually, this manual solution still lets lockdep verify that the
> assumption about I_MUTEX_PARENT -> I_MUTEX_CHILD nesting is correct).
> 
> A real solution without disabling lockdep and that would integrate with the VFS
> should make lockdep aware of lock trees (like i_mutex locks inside a same
> filesystem), or more generally lock graphs, and let lockdep verify that locks of
> a tree are always taken while respecting a same order. IOW, if we are able to
> consistently tag the nodes of a tree with unique numbers (consistently means
> that the resulting order on the nodes is never changed when adding or removing
> nodes), lockdep should check that locks of the tree are always taken in
> ascending tag order.
> 	This seems unfortunately hard (impossible?) to achieve with reasonable
> constraints: lockdep should not need to add links between the locks (this would
> make addition and removal of nodes error prone), and lockdep should not need to
> renumber all the nodes of a tree when adding a new node.
> 
> As a conclusion, I still suggest to temporarily disable lockdep, which will have
> the advantage of letting people use lockdep (for other areas) while using
> configfs, because lockdep simply cannot help us with configfs hierarchical
> locking right now.
> 
> Louis
> 
> -- 
> Dr Louis Rilling			Kerlabs
> Skype: louis.rilling			Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/			35700 Rennes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: show-configfs-deadlock-with-rename.patch
Type: text/x-diff
Size: 784 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080609/c16caf4e/attachment.bin 
