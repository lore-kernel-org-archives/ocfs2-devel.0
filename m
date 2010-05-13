From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:43:21 +0200
Subject: [Ocfs2-devel] Deadlock in DLM code still there
Message-ID: <20100513194320.GA28367@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  in http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03188.html
(more than an year ago) I've reported a lock inversion between dlm->ast_lock
and res->spinlock. The deadlock seems to be still there in 2.6.34-rc7:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.34-rc7-xen #4
-------------------------------------------------------
dlm_thread/2001 is trying to acquire lock:
 (&(&dlm->ast_lock)->rlock){+.+...}, at: [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]

but task is already holding lock:
 (&(&res->spinlock)->rlock){+.+...}, at: [<ffffffffa010452d>] dlm_thread+0x7cd/0x17f0 [ocfs2_dlm]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&res->spinlock)->rlock){+.+...}:
       [<ffffffff810746bf>] __lock_acquire+0x109f/0x1720
       [<ffffffff81074da9>] lock_acquire+0x69/0x90
       [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
       [<ffffffff8117e158>] _atomic_dec_and_lock+0x78/0xa0
       [<ffffffffa010ebb9>] dlm_lockres_release_ast+0x29/0xb0 [ocfs2_dlm]
       [<ffffffffa0104e41>] dlm_thread+0x10e1/0x17f0 [ocfs2_dlm]
       [<ffffffff81060e1e>] kthread+0x8e/0xa0
       [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10

-> #0 (&(&dlm->ast_lock)->rlock){+.+...}:
       [<ffffffff81074b18>] __lock_acquire+0x14f8/0x1720
       [<ffffffff81074da9>] lock_acquire+0x69/0x90
       [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
       [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
       [<ffffffffa010494f>] dlm_thread+0xbef/0x17f0 [ocfs2_dlm]
       [<ffffffff81060e1e>] kthread+0x8e/0xa0
       [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

1 lock held by dlm_thread/2001:
 #0:  (&(&res->spinlock)->rlock){+.+...}, at: [<ffffffffa010452d>] dlm_thread+0x7cd/0x17f0 [ocfs2_dlm]

stack backtrace:
Pid: 2001, comm: dlm_thread Not tainted 2.6.34-rc7-xen #4
Call Trace:
 [<ffffffff810723d0>] print_circular_bug+0xf0/0x100
 [<ffffffff81074b18>] __lock_acquire+0x14f8/0x1720
 [<ffffffff8100701d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffff81074da9>] lock_acquire+0x69/0x90
 [<ffffffffa0119785>] ? dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
 [<ffffffff81328c6c>] _raw_spin_lock+0x2c/0x40
 [<ffffffffa0119785>] ? dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
 [<ffffffffa0119785>] dlm_queue_bast+0x55/0x1e0 [ocfs2_dlm]
 [<ffffffffa010494f>] dlm_thread+0xbef/0x17f0 [ocfs2_dlm]
 [<ffffffff81070cdd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8107335d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff813293b2>] ? _raw_spin_unlock_irq+0x32/0x40
 [<ffffffff81061330>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa0103d60>] ? dlm_thread+0x0/0x17f0 [ocfs2_dlm]
 [<ffffffff81060e1e>] kthread+0x8e/0xa0
 [<ffffffff8100bda4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81329790>] ? restore_args+0x0/0x30
 [<ffffffff8100bda0>] ? kernel_thread_helper+0x0/0x10

  I'm now regularly hitting this problem so it stops me from verifying
whether there are other possible deadlocks in ocfs2 quota code...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
