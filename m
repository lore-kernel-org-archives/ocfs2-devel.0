From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Wed Jun  9 00:01:30 2004
Subject: [Ocfs2-devel] Profile data of the OCFS2 svn 1022 by running iozone
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65EF1@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	We profiled the OCFS2 (svn 1022) on IA32 and kernel 2.6.6-mm5.
The profile tool is oprofile, which is supported in kernel. The work
load tool is iozone.3.217.

The result shows the critical route, which consumes most of the CPU time
slices when the iozone benchmark runs.
ocfs_get_block() -> ocfs_lookup_file_allocation() ->
ocfs_lookup_extent_map_entry() -> ocfs_extent_map_lookup()

If we want to increase the throughput of file read operation, we'd
better focus on this critical route.


Samples		app name	symbol name
----------------------------------------------------------------
16180		ocfs		ocfs_lookup_extent_map_entry
12840		ocfs		ocfs_get_block
9091		ocfs		ocfs_extent_map_lookup
5089		ocfs		ocfs_lookup_file_allocation
2558		ocfs		ocfs_count_bits
1187		ocfs		ocfs_journal_new_file_search
811		ocfs		ocfs_bh_sem_lookup
717		ocfs		ocfs_extend_file
350		ocfs		ocfs_commit_write
345		ocfs		ocfs_readpage
254		ocfs		ocfs_file_read
138		ocfs		ocfs_file_write
125		ocfs		ocfs_test_allocatable
122		ocfs		ocfs_find_clear_bits
120		ocfs		ocfs_prepare_write
107		ocfs		ocfs_writepage
94		ocfs		ocfs_start_trans
91		ocfs		ocfs_read_bhs
72		ocfs		ocfs_journal_access
51		ocfs		ocfs_acquire_lock
47		ocfs		ocfs_commit_trans
42		ocfs		ocfs_clear_bits
28		ocfs		ocfs_update_publish_map
25		ocfs		ocfs_update_lockres
23		ocfs		ocfs_set_bits
19		ocfs		ocfs_acquire_lockres
19		ocfs		ocfs_bh_sem_put
19		ocfs		ocfs_update_disk_lock
18		ocfs		ocfs_bh_sem_unlock
14		ocfs		ocfs_bh_sem_lock
14		ocfs		ocfs_bh_sem_lock_modify
14		ocfs		ocfs_clear_buffer_modified
14		ocfs		ocfs_journal_add_lock
13		ocfs		ocfs_allocate_extent
13		ocfs		ocfs_journal_dirty
13		ocfs		ocfs_release_lockres
12		ocfs		ocfs_bh_sem_down
11		ocfs		ocfs_volume_thread
10		ocfs		ocfs_put_inode
9		ocfs		ocfs_bh_sem_up
9		ocfs		ocfs_extent_map_add
9		ocfs		ocfs_handle_unlock_inodes
8		ocfs		ocfs_bh_sem_get
8		ocfs		ocfs_write_bhs
7		ocfs		ocfs_find_space
7		ocfs		ocfs_foreach_child
7		ocfs		ocfs_inc_inode_seq
7		ocfs		ocfs_nm_heart_beat
6		ocfs		ocfs_break_cache_lock_zap_buffers
6		ocfs		ocfs_coalesce_extent_map_entry
6		ocfs		ocfs_journal_release_locks
5		ocfs		ocfs_dentry_revalidate
5		ocfs		ocfs_file_open
4		ocfs		ocfs_release_lock
3		ocfs		ocfs_add_to_bitmap_free_head
3		ocfs		ocfs_commit_cache
3		ocfs		ocfs_find_contiguous_space_from_bitmap
3		ocfs		ocfs_get_leaf_extent
3		ocfs		ocfs_update_extent_map
2		ocfs		ocfs_add_extent_map_entry
2		ocfs		ocfs_bmap
2		ocfs		ocfs_extent_map_destroy
2		ocfs		ocfs_handle_add_inode
2		ocfs		ocfs_init_timeout
2		ocfs		ocfs_inode_notify_open
2		ocfs		ocfs_wait_for_readonly_drop
1		ocfs		ocfs_add_entry
1		ocfs		ocfs_alloc_new_window
1		ocfs		ocfs_alloc_node_block
1		ocfs		ocfs_create
1		ocfs		ocfs_disk_release_lock
1		ocfs		ocfs_extent_map_init
1		ocfs		ocfs_file_release
1		ocfs		ocfs_find_extents_of_system_file
1		ocfs		ocfs_flush
1		ocfs		ocfs_free_disk_bitmap
1		ocfs		ocfs_inode_fill_ext_map
1		ocfs		ocfs_local_find_clear_bits
1		ocfs		ocfs_mknod
1		ocfs		ocfs_mknod_locked
1		ocfs		ocfs_set_timeout
1		ocfs		ocfs_update_master_on_open
1		ocfs		ocfs_wait_for_lock_release



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
