From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:19:52 +0100
Subject: [Ocfs2-devel] Possible locking problem in DLM code
Message-ID: <20090226201952.GA4002@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  with lockdep enabled, I get the warning below. I've verified it and it
seems to be really correct - we acquire dlm->ast_lock and lockres->spinlock
in different orders in dlm_queue_bast() and dlm_lockres_release_asm().
I'm not sure whether this can really lead to a deadlock and / or how to
fix this...

								Honza

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc3-default #7
-------------------------------------------------------
dlm_thread/3876 is trying to acquire lock:
 (&dlm->ast_lock){--..}, at: [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]

but task is already holding lock:
 (&res->spinlock){--..}, at: [<ffffffffa028bb63>] dlm_thread+0x506/0x11fb [ocfs2_dlm]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&res->spinlock){--..}:
       [<ffffffff80249be9>] add_lock_to_list+0x74/0xb3
       [<ffffffff8024ce4d>] __lock_acquire+0x1208/0x156e
       [<ffffffff80321d44>] _atomic_dec_and_lock+0x14/0x34
       [<ffffffff8024d205>] lock_acquire+0x52/0x6c
       [<ffffffff80321d44>] _atomic_dec_and_lock+0x14/0x34
       [<ffffffff80467cfd>] _spin_lock+0x29/0x36
       [<ffffffff80321d44>] _atomic_dec_and_lock+0x14/0x34
       [<ffffffff80321d44>] _atomic_dec_and_lock+0x14/0x34
       [<ffffffffa0293e8d>] dlm_lockres_release_ast+0x20/0x9a [ocfs2_dlm]
       [<ffffffffa028c488>] dlm_thread+0xe2b/0x11fb [ocfs2_dlm]
       [<ffffffff80240db5>] autoremove_wake_function+0x0/0x2e
       [<ffffffff8024b388>] trace_hardirqs_on_caller+0x115/0x138
       [<ffffffffa028b65d>] dlm_thread+0x0/0x11fb [ocfs2_dlm]
       [<ffffffff80240acd>] kthread+0x47/0x73
       [<ffffffff8046782f>] trace_hardirqs_on_thunk+0x3a/0x3f
       [<ffffffff8020cd3a>] child_rip+0xa/0x20
       [<ffffffff8020c8bc>] restore_args+0x0/0x30
       [<ffffffff80240a61>] kthreadd+0x177/0x19c
       [<ffffffff80240a86>] kthread+0x0/0x73
       [<ffffffff8020cd30>] child_rip+0x0/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&dlm->ast_lock){--..}:
       [<ffffffff8024b835>] print_circular_bug_tail+0x87/0xc7
       [<ffffffff8024b68f>] print_circular_bug_header+0xcc/0xd3
       [<ffffffff8024cb25>] __lock_acquire+0xee0/0x156e
       [<ffffffff8024d205>] lock_acquire+0x52/0x6c
       [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]
       [<ffffffff80467cfd>] _spin_lock+0x29/0x36
       [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]
       [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]
       [<ffffffffa028c07b>] dlm_thread+0xa1e/0x11fb [ocfs2_dlm]
       [<ffffffff80240db5>] autoremove_wake_function+0x0/0x2e
       [<ffffffff8024b388>] trace_hardirqs_on_caller+0x115/0x138
       [<ffffffffa028b65d>] dlm_thread+0x0/0x11fb [ocfs2_dlm]
       [<ffffffff80240acd>] kthread+0x47/0x73
       [<ffffffff8046782f>] trace_hardirqs_on_thunk+0x3a/0x3f
       [<ffffffff8020cd3a>] child_rip+0xa/0x20
       [<ffffffff8020c8bc>] restore_args+0x0/0x30
       [<ffffffff80240a61>] kthreadd+0x177/0x19c
       [<ffffffff80240a86>] kthread+0x0/0x73
       [<ffffffff8020cd30>] child_rip+0x0/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by dlm_thread/3876:
 #0:  (&res->spinlock){--..}, at: [<ffffffffa028bb63>] dlm_thread+0x506/0x11fb [ocfs2_dlm]

stack backtrace:
Pid: 3876, comm: dlm_thread Not tainted 2.6.29-rc3-default #7
Call Trace:
 [<ffffffff8024b86c>] print_circular_bug_tail+0xbe/0xc7
 [<ffffffff8024b68f>] print_circular_bug_header+0xcc/0xd3
 [<ffffffff8024cb25>] __lock_acquire+0xee0/0x156e
 [<ffffffff8024d205>] lock_acquire+0x52/0x6c
 [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]
 [<ffffffff80467cfd>] _spin_lock+0x29/0x36
 [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]
 [<ffffffffa029c98d>] dlm_queue_bast+0x75/0x16c [ocfs2_dlm]
 [<ffffffffa028c07b>] dlm_thread+0xa1e/0x11fb [ocfs2_dlm]
 [<ffffffff80240db5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8024b388>] trace_hardirqs_on_caller+0x115/0x138
 [<ffffffffa028b65d>] dlm_thread+0x0/0x11fb [ocfs2_dlm]
 [<ffffffff80240acd>] kthread+0x47/0x73
 [<ffffffff8046782f>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020cd3a>] child_rip+0xa/0x20
 [<ffffffff8020c8bc>] restore_args+0x0/0x30
 [<ffffffff80240a61>] kthreadd+0x177/0x19c
 [<ffffffff80240a86>] kthread+0x0/0x73
 [<ffffffff8020cd30>] child_rip+0x0/0x20

								Honza
