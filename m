From: Jan Kara <jack@suse.cz>
Date: Wed, 11 Feb 2009 18:58:34 +0100
Subject: [Ocfs2-devel] Possible lock inversion in directory locking
Message-ID: <20090211175834.GD13817@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  I've been playing lately with lockdep annotations of OCFS2. I seem to
have most of the false positives sorted out and currently I hit the report
below.
  I've analyzed that ocfs2_extend_dir() does first lock local alloc inode
in ocfs2_reserve_clusters() and then acquires ip_alloc_sem from the
directory. The usual ordering e.g. in ocfs2_write_begin() is to first
acquire ip_alloc_sem and then lock local alloc. Now these two paths
obviously cannot deadlock against each other because one works only for
directories and another only for files. But there are some code paths that
are shared among all inodes and I see some potential for deadlock there. So
my question: Is this locking difference between regular files and
directories intentional? If not, would you agree with changing the lock
ordering in ocfs2_extend_dir() (because I think different locking in this
area will bite us sooner or later)?

									Honza
=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc3-default #5
-------------------------------------------------------
cp/3919 is trying to acquire lock:
 (&oi->ip_alloc_sem){----}, at: [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]

but task is already holding lock:
 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){--..}, at: [<ffffffffa03017ff>] ocfs2_reserve_local_alloc_bits+0xf6/0xdec [ocfs2]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){--..}:
       [<ffffffff80249be9>] add_lock_to_list+0x74/0xb3
       [<ffffffff8024ce4d>] __lock_acquire+0x1208/0x156e
       [<ffffffffa03017ff>] ocfs2_reserve_local_alloc_bits+0xf6/0xdec [ocfs2]
       [<ffffffff80297840>] igrab+0x10/0x36
       [<ffffffff8024d205>] lock_acquire+0x52/0x6c
       [<ffffffffa03017ff>] ocfs2_reserve_local_alloc_bits+0xf6/0xdec [ocfs2]
       [<ffffffff80466933>] mutex_lock_nested+0xf6/0x278
       [<ffffffffa03017ff>] ocfs2_reserve_local_alloc_bits+0xf6/0xdec [ocfs2]
       [<ffffffff80468376>] _spin_unlock+0x17/0x20
       [<ffffffffa03017ff>] ocfs2_reserve_local_alloc_bits+0xf6/0xdec [ocfs2]
       [<ffffffff80468376>] _spin_unlock+0x17/0x20
       [<ffffffffa03012e9>] ocfs2_alloc_should_use_local+0x9e/0xa9 [ocfs2]
       [<ffffffffa030f782>] ocfs2_reserve_clusters_with_limit+0xf4/0x242 [ocfs2]
       [<ffffffffa0310954>] ocfs2_lock_allocators+0x15d/0x1e8 [ocfs2]
       [<ffffffffa02e25ce>] ocfs2_write_begin_nolock+0x9f6/0x1a99 [ocfs2]
       [<ffffffff80249424>] find_usage_backwards+0xc7/0xe8
       [<ffffffff8024cf83>] __lock_acquire+0x133e/0x156e
       [<ffffffff80249be9>] add_lock_to_list+0x74/0xb3
       [<ffffffff80467e1f>] __down_write_nested+0x17/0xa3
       [<ffffffff80467e1f>] __down_write_nested+0x17/0xa3
       [<ffffffffa0300719>] ocfs2_journal_access_di+0x0/0xf [ocfs2]
       [<ffffffffa02e377e>] ocfs2_write_begin+0x10d/0x1c0 [ocfs2]
       [<ffffffff802608a9>] generic_file_buffered_write+0x132/0x2ee
       [<ffffffff8029ac8a>] mnt_want_write+0x10/0x80
       [<ffffffff80260f50>] __generic_file_aio_write_nolock+0x34c/0x380
       [<ffffffff8026162b>] generic_file_aio_write_nolock+0x33/0x7f
       [<ffffffffa02f4a43>] ocfs2_file_aio_write+0x438/0x558 [ocfs2]
       [<ffffffff80286e7a>] do_sync_write+0xce/0x113
       [<ffffffff80221336>] do_page_fault+0x442/0x7bc
       [<ffffffff80240db5>] autoremove_wake_function+0x0/0x2e
       [<ffffffff802876c5>] vfs_write+0xad/0x123
       [<ffffffff802877f7>] sys_write+0x45/0x6e
       [<ffffffff8020be5b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&oi->ip_alloc_sem){----}:
       [<ffffffff8024b835>] print_circular_bug_tail+0x87/0xc7
       [<ffffffff8024b68f>] print_circular_bug_header+0xcc/0xd3
       [<ffffffff8024cb25>] __lock_acquire+0xee0/0x156e
       [<ffffffff80468376>] _spin_unlock+0x17/0x20
       [<ffffffff8024d205>] lock_acquire+0x52/0x6c
       [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]
       [<ffffffff804672e7>] down_write+0x3f/0x4a
       [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]
       [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]
       [<ffffffffa02e56d3>] ocfs2_read_dir_block+0x37/0x1ce [ocfs2]
       [<ffffffff80466710>] __mutex_unlock_slowpath+0x100/0x108
       [<ffffffffa02f8e92>] ocfs2_validate_inode_block+0x0/0x197 [ocfs2]
       [<ffffffffa0300719>] ocfs2_journal_access_di+0x0/0xf [ocfs2]
       [<ffffffffa02e92e5>] ocfs2_check_dir_for_entry+0x82/0xe8 [ocfs2]
       [<ffffffffa0307cec>] ocfs2_mknod+0x236/0xc42 [ocfs2]
       [<ffffffffa0308854>] ocfs2_create+0x83/0xd9 [ocfs2]
       [<ffffffff8028f601>] vfs_create+0xd0/0xfe
       [<ffffffff8029179e>] do_filp_open+0x22b/0x806
       [<ffffffff80468376>] _spin_unlock+0x17/0x20
       [<ffffffff80299edf>] alloc_fd+0x106/0x117
       [<ffffffff802857f6>] do_sys_open+0x48/0xcc
       [<ffffffff8020be5b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

3 locks held by cp/3919:
 #0:  (&sb->s_type->i_mutex_key#13){--..}, at: [<ffffffff802916c6>] do_filp_open+0x153/0x806
 #1:  (Meta){----}, at: [<ffffffffa0307bde>] ocfs2_mknod+0x128/0xc42 [ocfs2]
 #2:  (&ocfs2_sysfile_lock_key[args->fi_sysfile_type]#4){--..}, at: [<ffffffffa03017ff>] ocfs2_reserve_local_alloc_bits+0xf6/0xdec [ocfs2]

stack backtrace:
Pid: 3919, comm: cp Not tainted 2.6.29-rc3-default #5
Call Trace:
 [<ffffffff8024b86c>] print_circular_bug_tail+0xbe/0xc7
 [<ffffffff8024b68f>] print_circular_bug_header+0xcc/0xd3
 [<ffffffff8024cb25>] __lock_acquire+0xee0/0x156e
 [<ffffffff80468376>] _spin_unlock+0x17/0x20
 [<ffffffff8024d205>] lock_acquire+0x52/0x6c
 [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]
 [<ffffffff804672e7>] down_write+0x3f/0x4a
 [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]
 [<ffffffffa02e789e>] ocfs2_prepare_dir_for_insert+0x13d3/0x1999 [ocfs2]
 [<ffffffffa02e56d3>] ocfs2_read_dir_block+0x37/0x1ce [ocfs2]
 [<ffffffff80466710>] __mutex_unlock_slowpath+0x100/0x108
 [<ffffffffa02f8e92>] ocfs2_validate_inode_block+0x0/0x197 [ocfs2]
 [<ffffffffa0300719>] ocfs2_journal_access_di+0x0/0xf [ocfs2]
 [<ffffffffa02e92e5>] ocfs2_check_dir_for_entry+0x82/0xe8 [ocfs2]
 [<ffffffffa0307cec>] ocfs2_mknod+0x236/0xc42 [ocfs2]
 [<ffffffffa0308854>] ocfs2_create+0x83/0xd9 [ocfs2]
 [<ffffffff8028f601>] vfs_create+0xd0/0xfe
 [<ffffffff8029179e>] do_filp_open+0x22b/0x806
 [<ffffffff80468376>] _spin_unlock+0x17/0x20
 [<ffffffff80299edf>] alloc_fd+0x106/0x117
 [<ffffffff802857f6>] do_sys_open+0x48/0xcc
 [<ffffffff8020be5b>] system_call_fastpath+0x16/0x1b

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
