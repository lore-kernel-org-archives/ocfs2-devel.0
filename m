From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 11 Sep 2009 13:04:58 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090911200458.GA15416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here are the ocfs2 feature changes for 2.6.32.  The big ticket
item is the reflinkat(2) system call and ocfs2's support for it.  The
ocfs2 support accounts for all but a handful of the changes.  The
remaining few patches are fixes.
	Please pull.

Joel

The following changes since commit 8379e7c46cc48f51197dd663fc6676f47f2a1e71:
  Sunil Mushran (1):
        ocfs2: ocfs2_write_begin_nolock() should handle len=0

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Coly Li (1):
      dlmglue.c: add missed mlog lines

Joel Becker (41):
      ocfs2: Make the ocfs2_caching_info structure self-contained.
      ocfs2: Change metadata caching locks to an operations structure.
      ocfs2: Take the inode out of the metadata read/write paths.
      ocfs2: move ip_last_trans to struct ocfs2_caching_info
      ocfs2: move ip_created_trans to struct ocfs2_caching_info
      ocfs2: Pass struct ocfs2_caching_info to the journal functions.
      ocfs2: Store the ocfs2_caching_info on ocfs2_extent_tree.
      ocfs2: Pass ocfs2_caching_info to ocfs2_read_extent_block().
      ocfs2: ocfs2_find_path() only needs the caching info
      ocfs2: ocfs2_create_new_meta_bhs() doesn't need struct inode.
      ocfs2: Pass ocfs2_extent_tree to ocfs2_unlink_path()
      ocfs2: ocfs2_complete_edge_insert() doesn't need struct inode at all.
      ocfs2: Get inode out of ocfs2_rotate_subtree_root_right().
      ocfs2: Pass ocfs2_extent_tree to ocfs2_get_subtree_root()
      ocfs2: Drop struct inode from ocfs2_extent_tree_operations.
      ocfs2: ocfs2_rotate_tree_right() doesn't need struct inode.
      ocfs2: ocfs2_update_edge_lengths() doesn't need struct inode.
      ocfs2: ocfs2_rotate_subtree_left() doesn't need struct inode.
      ocfs2: __ocfs2_rotate_tree_left() doesn't need struct inode.
      ocfs2: ocfs2_rotate_tree_left() no longer needs struct inode.
      ocfs2: ocfs2_merge_rec_left/right() no longer need struct inode.
      ocfs2: ocfs2_try_to_merge_extent() doesn't need struct inode.
      ocfs2: ocfs2_grow_branch() and ocfs2_append_rec_to_path() lose struct inode.
      ocfs2: ocfs2_truncate_rec() doesn't need struct inode.
      ocfs2: Make truncating the extent map an extent_tree_operation.
      ocfs2: ocfs2_insert_at_leaf() doesn't need struct inode.
      ocfs2: Give ocfs2_split_record() an extent_tree instead of an inode.
      ocfs2: ocfs2_do_insert_extent() and ocfs2_insert_path() no longer need an inode.
      ocfs2: ocfs2_extent_contig() only requires the superblock.
      ocfs2: Swap inode for extent_tree in ocfs2_figure_merge_contig_type().
      ocfs2: Remove inode from ocfs2_figure_extent_contig().
      ocfs2: ocfs2_figure_insert_type() no longer needs struct inode.
      ocfs2: Make extent map insertion an extent_tree_operation.
      ocfs2: ocfs2_insert_extent() no longer needs struct inode.
      ocfs2: ocfs2_add_clusters_in_btree() no longer needs struct inode.
      ocfs2: ocfs2_remove_extent() no longer needs struct inode.
      ocfs2: ocfs2_split_and_insert() no longer needs struct inode.
      ocfs2: Teach ocfs2_replace_extent_rec() to use an extent_tree.
      ocfs2: __ocfs2_mark_extent_written() doesn't need struct inode.
      ocfs2: Pass ocfs2_caching_info into ocfs_init_*_extent_tree().
      fs: Add the reflink() operation and reflinkat(2) system call.

Sunil Mushran (1):
      ocfs2: __ocfs2_abort() should not enable panic for local mounts

Tao Ma (42):
      ocfs2: Define refcount tree structure.
      ocfs2: Add metaecc for ocfs2_refcount_block.
      ocfs2: Add ocfs2_read_refcount_block.
      ocfs2: Abstract caching info checkpoint.
      ocfs2: Add new refcount tree lock resource in dlmglue.
      ocfs2: Add caching info for refcount tree.
      ocfs2: Add refcount tree lock mechanism.
      ocfs2: Basic tree root operation.
      ocfs2: Wrap ocfs2_extent_contig in ocfs2_extent_tree.
      ocfs2: Abstract extent split process.
      ocfs2: Add refcount b-tree as a new extent tree.
      ocfs2: move tree path functions to alloc.h.
      ocfs2: Add support for incrementing refcount in the tree.
      ocfs2: Add support of decrementing refcount for delete.
      ocfs2: Add functions for extents refcounted.
      ocfs2: Decrement refcount when truncating refcounted extents.
      ocfs2: Add CoW support.
      ocfs2: CoW refcount tree improvement.
      ocfs2: Integrate CoW in file write.
      ocfs2: CoW a reflinked cluster when it is truncated.
      ocfs2: Add normal functions for reflink a normal file's extents.
      ocfs2: handle file attributes issue for reflink.
      ocfs2: Return extent flags for xattr value tree.
      ocfs2: Abstract duplicate clusters process in CoW.
      ocfs2: Add CoW support for xattr.
      ocfs2: Remove inode from ocfs2_xattr_bucket_get_name_value.
      ocfs2: Abstract the creation of xattr block.
      ocfs2: Abstract ocfs2 xattr tree extend rec iteration process.
      ocfs2: Attach xattr clusters to refcount tree.
      ocfs2: Call refcount tree remove process properly.
      ocfs2: Create an xattr indexed block if needed.
      ocfs2: Add reflink support for xattr.
      ocfs2: Modify removing xattr process for refcount.
      ocfs2: Don't merge in 1st refcount ops of reflink.
      ocfs2: Make transaction extend more efficient.
      ocfs2: Use proper parameter for some inode operation.
      ocfs2: Create reflinked file in orphan dir.
      ocfs2: Add preserve to reflink.
      ocfs2: Implement ocfs2_reflink.
      ocfs2: Enable refcount tree support.
      ocfs2: Add ioctl for reflink.
      ocfs2: Use buffer IO if we are appending a file.

Wengang Wang (1):
      ocfs2: add spinlock protection when dealing with lockres->purge.

 Documentation/filesystems/reflink.txt |  174 ++
 Documentation/filesystems/vfs.txt     |    4 +
 arch/x86/ia32/ia32entry.S             |    1 +
 arch/x86/include/asm/unistd_32.h      |    1 +
 arch/x86/include/asm/unistd_64.h      |    2 +
 arch/x86/kernel/syscall_table_32.S    |    1 +
 fs/namei.c                            |  137 ++
 fs/ocfs2/Makefile                     |    1 +
 fs/ocfs2/alloc.c                      | 1342 ++++++-----
 fs/ocfs2/alloc.h                      |  101 +-
 fs/ocfs2/aops.c                       |   37 +-
 fs/ocfs2/aops.h                       |    2 +
 fs/ocfs2/buffer_head_io.c             |   47 +-
 fs/ocfs2/buffer_head_io.h             |    8 +-
 fs/ocfs2/cluster/masklog.c            |    1 +
 fs/ocfs2/cluster/masklog.h            |    1 +
 fs/ocfs2/dir.c                        |  107 +-
 fs/ocfs2/dlm/dlmthread.c              |    6 +-
 fs/ocfs2/dlmglue.c                    |  105 +-
 fs/ocfs2/dlmglue.h                    |    6 +
 fs/ocfs2/extent_map.c                 |   33 +-
 fs/ocfs2/extent_map.h                 |    8 +-
 fs/ocfs2/file.c                       |  151 ++-
 fs/ocfs2/file.h                       |    2 +
 fs/ocfs2/inode.c                      |   86 +-
 fs/ocfs2/inode.h                      |   20 +-
 fs/ocfs2/ioctl.c                      |   14 +
 fs/ocfs2/journal.c                    |   82 +-
 fs/ocfs2/journal.h                    |   94 +-
 fs/ocfs2/localalloc.c                 |   12 +-
 fs/ocfs2/namei.c                      |  343 +++-
 fs/ocfs2/namei.h                      |    6 +
 fs/ocfs2/ocfs2.h                      |   52 +-
 fs/ocfs2/ocfs2_fs.h                   |  107 +-
 fs/ocfs2/ocfs2_lockid.h               |    5 +
 fs/ocfs2/quota_global.c               |    5 +-
 fs/ocfs2/quota_local.c                |   26 +-
 fs/ocfs2/refcounttree.c               | 4249 +++++++++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.h               |  108 +
 fs/ocfs2/resize.c                     |   16 +-
 fs/ocfs2/slot_map.c                   |   10 +-
 fs/ocfs2/suballoc.c                   |   35 +-
 fs/ocfs2/super.c                      |   13 +-
 fs/ocfs2/uptodate.c                   |  265 ++-
 fs/ocfs2/uptodate.h                   |   51 +-
 fs/ocfs2/xattr.c                      | 2056 +++++++++++++++--
 fs/ocfs2/xattr.h                      |   15 +-
 include/linux/fcntl.h                 |    8 +
 include/linux/fs.h                    |    2 +
 include/linux/security.h              |   23 +
 include/linux/syscalls.h              |    3 +
 security/capability.c                 |    7 +
 security/security.c                   |    8 +
 53 files changed, 8823 insertions(+), 1176 deletions(-)
 create mode 100644 Documentation/filesystems/reflink.txt
 create mode 100644 fs/ocfs2/refcounttree.c
 create mode 100644 fs/ocfs2/refcounttree.h
-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
