From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Jun  9 00:53:26 2004
Subject: [Ocfs2-devel] Profile data of the OCFS2 svn 1022 by running
	iozone
Message-ID: <3ACA40606221794F80A5670F0AF15F8404991146@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The follow is result from running test cases on the ocfs2 revision =
before changing the dir format.
It shows the ocfs_bh_sem_lookup's cost.
 --------
samples  %       app name                symbol name
38650     0.1841  vmlinux                  ocfs_bh_sem_lookup
1081      0.0051  vmlinux                  ocfs_count_bits
369       0.0018  vmlinux                  ocfs_read_bhs
43       2.0e-04  vmlinux                  ocfs_bh_sem_down
41       2.0e-04  vmlinux                  ocfs_end_buffer_io_sync
38       1.8e-04  vmlinux                  ocfs_bh_sem_unlock
22       1.0e-04  vmlinux                  ocfs_bh_sem_put
20       9.5e-05  vmlinux                  ocfs_bh_sem_get
16       7.6e-05  vmlinux                  ocfs_inode_hash_destroy
13       6.2e-05  vmlinux                  ocfs_uninitialize_bitmap
12       5.7e-05  vmlinux                  ocfs_inode_hash_init
12       5.7e-05  vmlinux                  ocfs_write_bhs
10       4.8e-05  vmlinux                  ocfs_update_publish_map
9        4.3e-05  vmlinux                  ocfs_bh_sem_lock
8        3.8e-05  vmlinux                  ocfs_clear_bits
7        3.3e-05  vmlinux                  ocfs_bh_sem_lock_modify
7        3.3e-05  vmlinux                  ocfs_sync_local_to_main
6        2.9e-05  vmlinux                  ocfs_clear_buffer_modified
6        2.9e-05  vmlinux                  ocfs_initialize_osb
6        2.9e-05  vmlinux                  ocfs_lookup_extent_map_entry
5        2.4e-05  vmlinux                  ocfs_acquire_lock
5        2.4e-05  vmlinux                  ocfs_add_extent_map_entry
5        2.4e-05  vmlinux                  ocfs_mount_volume
5        2.4e-05  vmlinux                  ocfs_set_bits
4        1.9e-05  vmlinux                  ocfs_chk_update_config
4        1.9e-05  vmlinux                  ocfs_disk_release_lock
4        1.9e-05  vmlinux                  ocfs_free_vol_block
4        1.9e-05  vmlinux                  ocfs_lookup_file_allocation
4        1.9e-05  vmlinux                  ocfs_volume_thread
3        1.4e-05  vmlinux                  ocfs_add_to_bitmap_free_head
3        1.4e-05  vmlinux                  ocfs_alloc_count_bits
3        1.4e-05  vmlinux                  ocfs_bmap
3        1.4e-05  vmlinux                  ocfs_mknod_locked
3        1.4e-05  vmlinux                  ocfs_read_dirnode
3        1.4e-05  vmlinux                  ocfs_read_super
2        9.5e-06  vmlinux                  ocfs_acquire_lockres
2        9.5e-06  vmlinux                  ocfs_clear_local_alloc
2        9.5e-06  vmlinux                  ocfs_dismount_volume
2        9.5e-06  vmlinux                  ocfs_inode_hash_insert
2        9.5e-06  vmlinux                  ocfs_inode_notify_open
2        9.5e-06  vmlinux                  ocfs_insert_file
2        9.5e-06  vmlinux                  ocfs_populate_inode
2        9.5e-06  vmlinux                  ocfs_process_bitmap_free_head
2        9.5e-06  vmlinux                  ocfs_update_disk_lock
2        9.5e-06  vmlinux                  ocfs_update_lockres
1        4.8e-06  vmlinux                  __ocfs_inode_hash_lookup
1        4.8e-06  vmlinux                  ocfs_alloc_new_window
1        4.8e-06  vmlinux                  ocfs_allocate_extent
1        4.8e-06  vmlinux                  ocfs_clear_inode
1        4.8e-06  vmlinux                  ocfs_commit_cache
1        4.8e-06  vmlinux                  ocfs_commit_trans
1        4.8e-06  vmlinux                  ocfs_file_open
1        4.8e-06  vmlinux                  ocfs_find_clear_bits
1        4.8e-06  vmlinux                  ocfs_find_files_on_disk
1        4.8e-06  vmlinux                  ocfs_find_space_from_local
1        4.8e-06  vmlinux                  ocfs_iget
1        4.8e-06  vmlinux                  ocfs_init_lockres
1        4.8e-06  vmlinux                  ocfs_init_udp_sock
1        4.8e-06  vmlinux                  ocfs_inode_hash_bind
1        4.8e-06  vmlinux                  ocfs_inode_init_private
1        4.8e-06  vmlinux                  ocfs_insert_dir_node
1        4.8e-06  vmlinux                  ocfs_journal_dirty
1        4.8e-06  vmlinux                  ocfs_journal_init
1        4.8e-06  vmlinux                  ocfs_journal_new_file_search
1        4.8e-06  vmlinux                  ocfs_journal_set_mounted
1        4.8e-06  vmlinux                  ocfs_proc_add_volume
1        4.8e-06  vmlinux                  ocfs_recover_oin_locks
1        4.8e-06  vmlinux                  ocfs_recv_udp_msg
1        4.8e-06  vmlinux                  ocfs_release_lock
1        4.8e-06  vmlinux                  ocfs_sync_blockdev
1        4.8e-06  vmlinux                  ocfs_update_extent_map
1        4.8e-06  vmlinux                  ocfs_write_volcfg_header


>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
>Sent: 2004=C4=EA6=D4=C29=C8=D5 13:01
>To: Ocfs2-Devel
>Subject: [Ocfs2-devel] Profile data of the OCFS2 svn 1022 by=20
>running iozone
>
>Hi,
>
>	We profiled the OCFS2 (svn 1022) on IA32 and kernel 2.6.6-mm5.
>The profile tool is oprofile, which is supported in kernel. The work
>load tool is iozone.3.217.
>
>The result shows the critical route, which consumes most of=20
>the CPU time
>slices when the iozone benchmark runs.
>ocfs_get_block() -> ocfs_lookup_file_allocation() ->
>ocfs_lookup_extent_map_entry() -> ocfs_extent_map_lookup()
>
>If we want to increase the throughput of file read operation, we'd
>better focus on this critical route.
>
>
>Samples		app name	symbol name
>----------------------------------------------------------------
>16180		ocfs		ocfs_lookup_extent_map_entry
>12840		ocfs		ocfs_get_block
>9091		ocfs		ocfs_extent_map_lookup
>5089		ocfs		ocfs_lookup_file_allocation
>2558		ocfs		ocfs_count_bits
>1187		ocfs		ocfs_journal_new_file_search
>811		ocfs		ocfs_bh_sem_lookup
>717		ocfs		ocfs_extend_file
>350		ocfs		ocfs_commit_write
>345		ocfs		ocfs_readpage
>254		ocfs		ocfs_file_read
>138		ocfs		ocfs_file_write
>125		ocfs		ocfs_test_allocatable
>122		ocfs		ocfs_find_clear_bits
>120		ocfs		ocfs_prepare_write
>107		ocfs		ocfs_writepage
>94		ocfs		ocfs_start_trans
>91		ocfs		ocfs_read_bhs
>72		ocfs		ocfs_journal_access
>51		ocfs		ocfs_acquire_lock
>47		ocfs		ocfs_commit_trans
>42		ocfs		ocfs_clear_bits
>28		ocfs		ocfs_update_publish_map
>25		ocfs		ocfs_update_lockres
>23		ocfs		ocfs_set_bits
>19		ocfs		ocfs_acquire_lockres
>19		ocfs		ocfs_bh_sem_put
>19		ocfs		ocfs_update_disk_lock
>18		ocfs		ocfs_bh_sem_unlock
>14		ocfs		ocfs_bh_sem_lock
>14		ocfs		ocfs_bh_sem_lock_modify
>14		ocfs		ocfs_clear_buffer_modified
>14		ocfs		ocfs_journal_add_lock
>13		ocfs		ocfs_allocate_extent
>13		ocfs		ocfs_journal_dirty
>13		ocfs		ocfs_release_lockres
>12		ocfs		ocfs_bh_sem_down
>11		ocfs		ocfs_volume_thread
>10		ocfs		ocfs_put_inode
>9		ocfs		ocfs_bh_sem_up
>9		ocfs		ocfs_extent_map_add
>9		ocfs		ocfs_handle_unlock_inodes
>8		ocfs		ocfs_bh_sem_get
>8		ocfs		ocfs_write_bhs
>7		ocfs		ocfs_find_space
>7		ocfs		ocfs_foreach_child
>7		ocfs		ocfs_inc_inode_seq
>7		ocfs		ocfs_nm_heart_beat
>6		ocfs		ocfs_break_cache_lock_zap_buffers
>6		ocfs		ocfs_coalesce_extent_map_entry
>6		ocfs		ocfs_journal_release_locks
>5		ocfs		ocfs_dentry_revalidate
>5		ocfs		ocfs_file_open
>4		ocfs		ocfs_release_lock
>3		ocfs		ocfs_add_to_bitmap_free_head
>3		ocfs		ocfs_commit_cache
>3		ocfs		ocfs_find_contiguous_space_from_bitmap
>3		ocfs		ocfs_get_leaf_extent
>3		ocfs		ocfs_update_extent_map
>2		ocfs		ocfs_add_extent_map_entry
>2		ocfs		ocfs_bmap
>2		ocfs		ocfs_extent_map_destroy
>2		ocfs		ocfs_handle_add_inode
>2		ocfs		ocfs_init_timeout
>2		ocfs		ocfs_inode_notify_open
>2		ocfs		ocfs_wait_for_readonly_drop
>1		ocfs		ocfs_add_entry
>1		ocfs		ocfs_alloc_new_window
>1		ocfs		ocfs_alloc_node_block
>1		ocfs		ocfs_create
>1		ocfs		ocfs_disk_release_lock
>1		ocfs		ocfs_extent_map_init
>1		ocfs		ocfs_file_release
>1		ocfs		ocfs_find_extents_of_system_file
>1		ocfs		ocfs_flush
>1		ocfs		ocfs_free_disk_bitmap
>1		ocfs		ocfs_inode_fill_ext_map
>1		ocfs		ocfs_local_find_clear_bits
>1		ocfs		ocfs_mknod
>1		ocfs		ocfs_mknod_locked
>1		ocfs		ocfs_set_timeout
>1		ocfs		ocfs_update_master_on_open
>1		ocfs		ocfs_wait_for_lock_release
>
>
>
>*********************************************
>Sonic Zhang
>Software Engineer
>Intel China Software Lab
>Tel: (086)021-52574545-1667
>iNet: 752-1667
>*********************************************=20
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
