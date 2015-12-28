From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 28 Dec 2015 10:13:20 +0800
Subject: [Ocfs2-devel] Ocfs2 test done for kernel-4.4.0_rc5_next_20151217
Message-ID: <56809AC0.9020204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Two regression bugs are found.

1. kernel panic when do ocfs2 flock_unit test
https://oss.oracle.com/bugzilla/show_bug.cgi?id=1360

  Fixed by ocfs2-fix-flock-panic-issue.patch, merged into -mm tree.

2. netfilter panic issue

  Fixed by
  e97ac12859dbf4d3ee0eddb9798867541d1d1e1e
 ("netfilter: ipv6: nf_defrag: fix NULL deref panic"),

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/net/ipv6/netfilter/nf_conntrack_reasm.c?id=e97ac12859dbf4d3ee0eddb9798867541d1d1e1e


This means the following ocfs2 patches are tested.

59f77e0014d8 ocfs2: dlm: fix recursive locking deadlock  >>>>  this
patch added here to avoid a deadlock issue which is still under reviewing.
81c40d995490 Merge branch 'akpm-current/current'
bb10a1793dee Merge remote-tracking branch 'target-updates/for-next'
d8cb87e1a2df Merge remote-tracking branch 'vfs/for-next'
70561de575c3 Merge branches 'work.misc', 'work.iov_iter',
'work.copy_file_range', 'work.xattr' and 'work.symlinks' into for-next
1046cb119521 ocfs2: Replace list xattr handler operations
854ee2e944b4 ocfs2: fix SGID not inherited issue
037ea4d75b87 kmemcg: account certain kmem allocations to memcg
405da7b5b349 ocfs2: solve a problem of crossing the boundary in updating
backups
daf4b22b57ce ocfs2: fix occurring deadlock by changing ocfs2_wq from
global to local
d08a91f2f76a ocfs2: extend enough credits for freeing one truncate
record while replaying truncate records
78e6c4f318b4 ocfs2: extend transaction for ocfs2_remove_rightmost_path()
and ocfs2_update_edge_lengths() before to avoid inconsistency between
inode and et
02e5afa77919 ocfs2/dlm: fix BUG in dlm_move_lockres_to_recovery_list
4e27a9ded747 ocfs2-dlm-fix-race-between-convert-and-recovery-v3
1a9e2f425487 ocfs2-dlm-fix-race-between-convert-and-recovery-v2
ce21bb185862 ocfs2/dlm: fix race between convert and recovery
9e982f3cfb0e ocfs2: fix a deadlock issue in ocfs2_dio_end_io_write()
1275c5fd46e2 ocfs2: fix disk file size and memory file size mismatch
a1f0bf7e5f10 ocfs2: take ip_alloc_sem in ocfs2_dio_get_block &
ocfs2_dio_end_io_write
8f673e7559ef ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix
b3432f92ca24 ocfs2: fix ip_unaligned_aio deadlock with dio work queue
ccb4536fe829 ocfs2: code clean up for direct io
0f466c64b751 ocfs2: fix sparse file & data ordering issue in direct io
be62cb228da1 ocfs2: record UNWRITTEN extents when populate write desc
af5dcab55f9a ocfs2: return the physical address in ocfs2_write_cluster
5a0085d9861d ocfs2: do not change i_size in write_end for direct io
728b5c442e50 ocfs2: test target page before change it
275c93677fda ocfs2: use c_new to indicate newly allocated extents
51ff66b418f1 ocfs2: add ocfs2_write_type_t type to identify the caller
of write
9241deb7baa1 ocfs2/dlm: wait until DLM_LOCK_RES_SETREF_INPROG is cleared
in dlm_deref_lockres_worker
78de07d96451 ocfs2: constify ocfs2_extent_tree_operations structures
bf6559a4a870 ocfs2/dlm: fix a race between purge and migration
9f845f5fefb0 ocfs2: o2hb: increase unsteady iterations
b64c44414546 ocfs2: return non-zero st_blocks for inline data
4fc129ed435c ocfs2: optimize bad declarations and redundant assignment

Thanks,
Junxiao.
