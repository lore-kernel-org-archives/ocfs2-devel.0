From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Jul  2 01:11:28 2004
Subject: [Ocfs2-devel] 
	Profile data of OCFS2 svn 1226 on the one-node IPF cluster
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E049567FE@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	We get the profile data via tool "oprofile-0.8". The workload is
iozone. We run it on top of kernel 2.6.6 and an IPF server with 2 CPUs.
The version of the OCFS2 driver loaded is 1226.

	The result is great different from that of version 1022. I guess
that is because the changes in the metadata structure.



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************  
-------------- next part --------------
1252      0.0713  ocfs2                    ocfs_readdir
657       0.0374  ocfs2                    ocfs_verify_update_inode
608       0.0346  ocfs2                    ocfs_file_open
391       0.0223  ocfs2                    ocfs_find_contiguous_space_from_bitmap
338       0.0193  ocfs2                    ocfs_file_release
242       0.0138  ocfs2                    ocfs_alloc_node_block
116       0.0066  ocfs2                    ocfs_disk_request_vote
91        0.0052  ocfs2                    ocfs_delete_inode
72        0.0041  ocfs2                    ocfs_process_vote
35        0.0020  ocfs2                    empty_dir
20        0.0011  ocfs2                    ocfs_update_publish_map
17       9.7e-04  ocfs2                    ocfs_commit_cache
17       9.7e-04  ocfs2                    ocfs_extend_file
15       8.5e-04  ocfs2                    ocfs_extent_contig
11       6.3e-04  ocfs2                    ocfs_foreach_child
10       5.7e-04  ocfs2                    ocfs_dentry_revalidate24
10       5.7e-04  ocfs2                    ocfs_find_files_on_disk
9        5.1e-04  ocfs2                    ocfs_driver_entry
8        4.6e-04  ocfs2                    ocfs_recover_vol
7        4.0e-04  ocfs2                    ocfs_inode_revalidate
6        3.4e-04  ocfs2                    ocfs_journal_dirty
5        2.8e-04  ocfs2                    new_lock_function
5        2.8e-04  ocfs2                    ocfs_journal_init
5        2.8e-04  ocfs2                    ocfs_process_bitmap_free_head
4        2.3e-04  ocfs2                    ocfs_abort_trans
3        1.7e-04  ocfs2                    ocfs_link
3        1.7e-04  ocfs2                    ocfs_populate_inode
3        1.7e-04  ocfs2                    ocfs_setattr
2        1.1e-04  ocfs2                    ocfs_add_to_bitmap_free_head
2        1.1e-04  ocfs2                    ocfs_get_publish_vote_map
2        1.1e-04  ocfs2                    ocfs_iget
2        1.1e-04  ocfs2                    ocfs_journal_access
2        1.1e-04  ocfs2                    ocfs_set_publish_vote_map
1        5.7e-05  ocfs2                    ocfs_extent_map_add
1        5.7e-05  ocfs2                    ocfs_extent_map_next_entry
1        5.7e-05  ocfs2                    ocfs_extent_map_remove
1        5.7e-05  ocfs2                    ocfs_force_read_journal
1        5.7e-05  ocfs2                    ocfs_free_disk_bitmap
1        5.7e-05  ocfs2                    ocfs_grow_extent_tree
1        5.7e-05  ocfs2                    ocfs_initialize_bitmap
1        5.7e-05  ocfs2                    ocfs_lookup_extent_map_entry
1        5.7e-05  ocfs2                    ocfs_mknod_locked
1        5.7e-05  ocfs2                    ocfs_set_disk_lock_open_map
1        5.7e-05  ocfs2                    ocfs_unlink
1        5.7e-05  ocfs2                    ocfs_volume_thread
-------------- next part --------------
CPU: CPU with timer interrupt, speed 0 MHz (estimated)
Profiling through timer interrupt
samples  %        app name                 symbol name
1740314  99.1638  vmlinux1                 (no symbols)
4332      0.2468  scsi_mod                 print_inquiry
1252      0.0713  ocfs2                    ocfs_readdir
1080      0.0615  scsi_mod                 scsi_request_fn
858       0.0489  mptbase                  mpt_base_reply
657       0.0374  ocfs2                    ocfs_verify_update_inode
608       0.0346  ocfs2                    ocfs_file_open
420       0.0239  iozone                   __udivdi3
393       0.0224  scsi_mod                 __scsi_device_lookup
391       0.0223  ocfs2                    ocfs_find_contiguous_space_from_bitmap
338       0.0193  ocfs2                    ocfs_file_release
271       0.0154  libc-2.3.3.so            _IO_str_overflow_internal
242       0.0138  ocfs2                    ocfs_alloc_node_block
216       0.0123  iozone                   read_perf_test
204       0.0116  scsi_mod                 scsi_io_completion
198       0.0113  mptscsih                 flush_doneQ
177       0.0101  scsi_mod                 scsi_init_cmd_from_req
163       0.0093  libc-2.3.3.so            _IO_vfprintf_internal
142       0.0081  libc-2.3.3.so            _IO_default_xsputn_internal
120       0.0068  iozone                   random_perf_test
119       0.0068  iozone                   reverse_perf_test
116       0.0066  ocfs2                    ocfs_disk_request_vote
112       0.0064  syslogd                  (no symbols)
104       0.0059  iozone                   write_perf_test
99        0.0056  libc-2.3.3.so            __GI_strchr
94        0.0054  klogd                    (no symbols)
91        0.0052  ocfs2                    ocfs_delete_inode
72        0.0041  ocfs2                    ocfs_process_vote
64        0.0036  iozone                   rewriterec_perf_test
58        0.0033  iozone                   read_stride_perf_test
58        0.0033  oprofiled                opd_put_sample
50        0.0028  scsi_mod                 scsi_prep_fn
48        0.0027  scsi_mod                 scsi_host_cancel
45        0.0026  scsi_mod                 scsi_eh_get_sense
44        0.0025  libc-2.3.3.so            __tzfile_compute
42        0.0024  bash                     (no symbols)
42        0.0024  oprofiled                odb_insert
42        0.0024  oprofiled                sfile_hash
42        0.0024  sd_mod                   sd_rw_intr
37        0.0021  scsi_mod                 scsi_track_queue_full
36        0.0021  mptbase                  mpt_register
36        0.0021  oprofiled                sfile_log_sample
35        0.0020  ocfs2                    empty_dir
35        0.0020  scsi_mod                 scsi_host_dev_release
34        0.0019  oprofiled                sfile_match
34        0.0019  scsi_mod                 scsi_add_host
30        0.0017  oprofiled                pop_buffer_value
29        0.0017  iozone                   verify_buffer
29        0.0017  oprofiled                sfile_find
28        0.0016  libc-2.3.3.so            __GI_memset
27        0.0015  scsi_mod                 scsi_try_to_abort_cmd
25        0.0014  scsi_mod                 scsi_report_device_reset
24        0.0014  libc-2.3.3.so            l2
23        0.0013  libc-2.3.3.so            __GI_strcmp
20        0.0011  ocfs2                    ocfs_update_publish_map
19        0.0011  libcrypto.so.0.9.7a      (no symbols)
18        0.0010  libc-2.3.3.so            __GI_getenv
18        0.0010  libc-2.3.3.so            __offtime
17       9.7e-04  ocfs2                    ocfs_commit_cache
17       9.7e-04  ocfs2                    ocfs_extend_file
17       9.7e-04  oprofiled                get_file
16       9.1e-04  scsi_mod                 scsi_host_alloc
16       9.1e-04  scsi_mod                 scsi_reset_provider
15       8.5e-04  mptscsih                 mptscsih_TMHandler
15       8.5e-04  ocfs2                    ocfs_extent_contig
15       8.5e-04  oprofiled                find_kernel_image
15       8.5e-04  scsi_mod                 scsi_init_io
14       8.0e-04  libc-2.3.3.so            __find_specmb
13       7.4e-04  scsi_mod                 scsi_device_get
12       6.8e-04  oprofiled                opd_process_samples
11       6.3e-04  libc-2.3.3.so            __GI_time
11       6.3e-04  libc-2.3.3.so            __gconv_transform_utf8_internal
11       6.3e-04  libc-2.3.3.so            __strnlen
11       6.3e-04  mptscsih                 mptscsih_io_done
11       6.3e-04  ocfs2                    ocfs_foreach_child
11       6.3e-04  scsi_mod                 scsi_get_command
10       5.7e-04  ld-2.3.3.so              _dl_relocate_object
10       5.7e-04  libc-2.3.3.so            __GI___rawmemchr
10       5.7e-04  libc-2.3.3.so            __GI_strlen
10       5.7e-04  ocfs2                    ocfs_dentry_revalidate24
10       5.7e-04  ocfs2                    ocfs_find_files_on_disk
10       5.7e-04  oprofiled                enough_remaining
10       5.7e-04  oprofiled                sfile_put
9        5.1e-04  ocfs2                    ocfs_driver_entry
9        5.1e-04  scsi_mod                 __scsi_iterate_devices
9        5.1e-04  scsi_mod                 __scsi_mode_sense
9        5.1e-04  scsi_mod                 scsi_device_put
9        5.1e-04  scsi_mod                 scsi_finish_command
8        4.6e-04  libc-2.3.3.so            _IO_str_init_static_internal
8        4.6e-04  libc-2.3.3.so            __tz_convert
8        4.6e-04  ocfs2                    ocfs_recover_vol
8        4.6e-04  scsi_mod                 scsi_device_cancel_cb
8        4.6e-04  scsi_mod                 scsi_put_command
8        4.6e-04  scsi_mod                 scsi_remove_host
7        4.0e-04  libc-2.3.3.so            __GI___mbrtowc
7        4.0e-04  libc-2.3.3.so            __GI_strcpy
7        4.0e-04  ocfs2                    ocfs_inode_revalidate
7        4.0e-04  oprofiled                sfile_get
7        4.0e-04  scsi_mod                 scsi_done
6        3.4e-04  iozone                   anonymous symbol from section .plt
6        3.4e-04  ld-2.3.3.so              __umoddi3
6        3.4e-04  ld-2.3.3.so              do_lookup_x
6        3.4e-04  libc-2.3.3.so            _IO_setb_internal
6        3.4e-04  libc-2.3.3.so            __asctime_r
6        3.4e-04  ocfs2                    ocfs_journal_dirty
6        3.4e-04  sd_mod                   scsi_disk_get
6        3.4e-04  sshd                     (no symbols)
5        2.8e-04  jbd                      journal_put_journal_head
5        2.8e-04  jbd                      journal_stop
5        2.8e-04  libc-2.3.3.so            _IO_old_init
5        2.8e-04  libc-2.3.3.so            _IO_padn_internal
5        2.8e-04  libc-2.3.3.so            __GI_sprintf
5        2.8e-04  libc-2.3.3.so            __ctype_b_loc
5        2.8e-04  libc-2.3.3.so            __libc_select
5        2.8e-04  libc-2.3.3.so            _int_malloc
5        2.8e-04  ocfs2                    new_lock_function
5        2.8e-04  ocfs2                    ocfs_journal_init
5        2.8e-04  ocfs2                    ocfs_process_bitmap_free_head
4        2.3e-04  jbd                      journal_extend
4        2.3e-04  jbd                      write_jbd_debug
4        2.3e-04  ld-2.3.3.so              _dl_make_fptr
4        2.3e-04  libc-2.3.3.so            _IO_vsprintf_internal
4        2.3e-04  libc-2.3.3.so            __GI___libc_malloc
4        2.3e-04  libc-2.3.3.so            __GI_strncpy
4        2.3e-04  libc-2.3.3.so            __cfree
4        2.3e-04  libc-2.3.3.so            __snprintf
4        2.3e-04  libc-2.3.3.so            __tzstring
4        2.3e-04  libc-2.3.3.so            tzset_internal
4        2.3e-04  libpthread-0.61.so       __libc_write
4        2.3e-04  ocfs2                    ocfs_abort_trans
3        1.7e-04  iozone                   __divdi3
3        1.7e-04  jbd                      journal_commit_transaction
3        1.7e-04  jbd                      journal_exit
3        1.7e-04  libc-2.3.3.so            _IO_no_init
3        1.7e-04  libc-2.3.3.so            __GI___errno_location
3        1.7e-04  libc-2.3.3.so            __GI__dl_mcount_wrapper_check
3        1.7e-04  libc-2.3.3.so            __GI_write
3        1.7e-04  libc-2.3.3.so            __ctype_get_mb_cur_max
3        1.7e-04  libc-2.3.3.so            wcwidth
3        1.7e-04  libpthread-0.61.so       __libc_read
3        1.7e-04  libpthread-0.61.so       __llseek
3        1.7e-04  ocfs2                    ocfs_link
3        1.7e-04  ocfs2                    ocfs_populate_inode
3        1.7e-04  ocfs2                    ocfs_setattr
2        1.1e-04  iozone                   __moddi3
2        1.1e-04  jbd                      __journal_try_to_free_buffer
2        1.1e-04  jbd                      journal_unmap_buffer
2        1.1e-04  ld-2.3.3.so              _dl_lookup_symbol_x
2        1.1e-04  ld-2.3.3.so              _dl_start
2        1.1e-04  ld-2.3.3.so              strcmp
2        1.1e-04  libc-2.3.3.so            __GI_asctime
2        1.1e-04  libc-2.3.3.so            __GI_localtime
2        1.1e-04  libc-2.3.3.so            __GI_memcpy
2        1.1e-04  libc-2.3.3.so            store_words
2        1.1e-04  mptscsih                 mptscsih_IssueTaskMgmt
2        1.1e-04  mptscsih                 search_doneQ_for_cmd
2        1.1e-04  ocfs2                    ocfs_add_to_bitmap_free_head
2        1.1e-04  ocfs2                    ocfs_get_publish_vote_map
2        1.1e-04  ocfs2                    ocfs_iget
2        1.1e-04  ocfs2                    ocfs_journal_access
2        1.1e-04  ocfs2                    ocfs_set_publish_vote_map
2        1.1e-04  scsi_mod                 __scsi_release_request
2        1.1e-04  scsi_mod                 scsi_reset_provider_done_command
1        5.7e-05  ext3                     ext3_getblk
1        5.7e-05  ext3                     ext3_htree_fill_tree
1        5.7e-05  ext3                     ext3_htree_store_dirent
1        5.7e-05  ext3                     ext3_ordered_writepage
1        5.7e-05  ext3                     ext3_xattr_get
1        5.7e-05  ext3                     find_group_orlov
1        5.7e-05  grep                     (no symbols)
1        5.7e-05  insmod                   (no symbols)
1        5.7e-05  iozone                   fill_buffer
1        5.7e-05  jbd                      __dispose_buffer
1        5.7e-05  jbd                      __log_start_commit
1        5.7e-05  jbd                      do_get_write_access
1        5.7e-05  jbd                      inverted_lock
1        5.7e-05  jbd                      journal_get_create_access
1        5.7e-05  jbd                      journal_get_write_access
1        5.7e-05  jbd                      journal_lock_updates
1        5.7e-05  jbd                      journal_revoke
1        5.7e-05  jbd                      journal_try_to_free_buffers
1        5.7e-05  jbd                      journal_unlock_updates
1        5.7e-05  jbd                      kjournald
1        5.7e-05  jbd                      start_this_handle
1        5.7e-05  ld-2.3.3.so              __libc_memalign
1        5.7e-05  ld-2.3.3.so              __sigsetjmp
1        5.7e-05  ld-2.3.3.so              fixup
1        5.7e-05  ld-2.3.3.so              make_fdesc
1        5.7e-05  libc-2.3.3.so            _IO_file_overflow_internal
1        5.7e-05  libc-2.3.3.so            _IO_putc_internal
1        5.7e-05  libc-2.3.3.so            __GI___libc_recv
1        5.7e-05  libc-2.3.3.so            __GI_memchr
1        5.7e-05  libc-2.3.3.so            __GI_read
1        5.7e-05  libc-2.3.3.so            __gconv_transform_ascii_internal
1        5.7e-05  libc-2.3.3.so            __isatty
1        5.7e-05  libc-2.3.3.so            __textdomain
1        5.7e-05  libc-2.3.3.so            _int_free
1        5.7e-05  libc-2.3.3.so            _nl_intern_locale_data
1        5.7e-05  libc-2.3.3.so            ctime
1        5.7e-05  libc-2.3.3.so            lrand48
1        5.7e-05  libc-2.3.3.so            round_and_return
1        5.7e-05  mptbase                  mpt_reset_register
1        5.7e-05  ocfs2                    ocfs_extent_map_add
1        5.7e-05  ocfs2                    ocfs_extent_map_next_entry
1        5.7e-05  ocfs2                    ocfs_extent_map_remove
1        5.7e-05  ocfs2                    ocfs_force_read_journal
1        5.7e-05  ocfs2                    ocfs_free_disk_bitmap
1        5.7e-05  ocfs2                    ocfs_grow_extent_tree
1        5.7e-05  ocfs2                    ocfs_initialize_bitmap
1        5.7e-05  ocfs2                    ocfs_lookup_extent_map_entry
1        5.7e-05  ocfs2                    ocfs_mknod_locked
1        5.7e-05  ocfs2                    ocfs_set_disk_lock_open_map
1        5.7e-05  ocfs2                    ocfs_unlink
1        5.7e-05  ocfs2                    ocfs_volume_thread
1        5.7e-05  oprofile                 alloc_event_buffer
1        5.7e-05  oprofile                 event_buffer_open
1        5.7e-05  oprofile                 event_buffer_read
1        5.7e-05  oprofile                 take_tasks_mm
1        5.7e-05  oprofiled                code_kernel_exit
1        5.7e-05  scsi_mod                 scsi_adjust_queue_depth
