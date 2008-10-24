From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 15:40:25 -0700
Subject: [Ocfs2-devel] Bug in OCFS2 umount code
In-Reply-To: <20081024215702.GA10038@duck.suse.cz>
References: <20081024215702.GA10038@duck.suse.cz>
Message-ID: <20081024224025.GF9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 24, 2008 at 11:57:02PM +0200, Jan Kara wrote:
>   while playing with quota support I found two bugs in OCFS2 mount/umount
> code. The first problem is, that if mount fails, we call
> ocfs2_dismount_volume(). That is fine but after fill_super() returns an
> error, VFS calls sync_fs() and ocfs2_put_super() again - not a good idea.
> We usually oops...

	I was trying to figure out why this happens, given that we've
never seen it before and we test failed mounts all the time (no cluster
stack, bad mount argument, bad features...).
	The vfs only calls ->sync_fs() and ->put_super() if sb->s_root
exists.  So we cannot fail a mount after we've set sb->s_root.  If you
check ocfs2_fill_super(), you'll see that after we sb->s_root, we will
continue on to success (we return 'status', but status will be 0).
	After we've set s_root, we must complete our mount tasks in
fill_super().  If you want to fail after that, you need to complete the
mount tasks but return non-zero status.  Then the VFS code will follow
to ->put_super() like you say and ocfs2_dismount_volume() will only be
called once.
	So I don't see a bug in the code as I have it here in my tree.
I'm going to go check your quota patches to see if perhaps you jump to
read_super_error after s_root is set.  If so, we can just reorganize
that.  If not, we'll have to figure out what particular mount failure is
causing your problem, so we can see what's happening.

>   Another problem is oops with the following backtrace:
> #0  spin_bug (lock=0x61e9e530, msg=0x6031aa23 "bad magic")
>     at include/linux/sched.h:1388
> #1  0x00000000601ece1d in _raw_spin_lock (lock=0x61de1520)
>     at lib/spinlock_debug.c:78
> #2  0x0000000060256a91 in _spin_lock (lock=0x61de1520) at
> kernel/spinlock.c:181
> #3  0x0000000060122f92 in jbd2_journal_release_jbd_inode (
>     journal=<value optimized out>, jinode=0x6103c920) at
> fs/jbd2/journal.c:2247
> #4  0x0000000060178399 in ocfs2_clear_inode (inode=0x6103c638)
>     at fs/ocfs2/inode.c:1119
> #5  0x00000000600866c3 in clear_inode (inode=0x6103c638) at fs/inode.c:269
> #6  0x00000000600869ef in generic_drop_inode (inode=0x6103c638)
>     at fs/inode.c:1100
> #7  0x00000000601784c5 in ocfs2_drop_inode (inode=0x6103c638)
>     at fs/ocfs2/inode.c:1141
> #8  0x0000000060085bc1 in iput (inode=0x6103c638) at fs/inode.c:1138
> #9  0x000000006018e5fd in ocfs2_release_system_inodes (osb=0x61f3e600)
>     at fs/ocfs2/super.c:337
> #10 0x000000006019050b in ocfs2_dismount_volume (sb=0x61e9eaf8, mnt_err=0)
>     at fs/ocfs2/super.c:1599
> #11 0x0000000060190a63 in ocfs2_put_super (sb=0x61e9eaf8)
>     at fs/ocfs2/super.c:1334
> 
>   I guess the cause is that ocfs2_clear_inode() gets called after
> the journal is freed. Well, jbd2_journal_release_jbd_inode() handles
> this but only if you pass NULL instead of journal pointer in such case...
> But OCFS2 obviously passes some already invalid pointer.

	This is already known and the fix will be going upstream
shortly.

Joel

-- 

"Win95 file and print sharing are for relatively friendly nets."
	- Paul Leach, Microsoft

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
