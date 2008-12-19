From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:53:19 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 patches for merge window,
	batch 1/3
Message-ID: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

Hi,

As of right now, the upstream-linus branch in ocfs2.git has 136 patches for
the next merge window. Luckily, a large chunk of those are either small or
easily read. Also, many of them are generic quota changes (which already
have appropriate review and signoffs) which I carried in ocfs2.git because
Ocfs2 quotas depended on them.

Regardless, I plan to post the ocfs2 merge window patches in 3 batches to
make review easier. The first set of patches follows this mail. The final
two will be sent early next week and will include the generic quota patches.

Aside from some xattr cleanups and fixes, these patches include supoprt for
POSIX ACLs and security attributes. These are implemented as special
extended attributes in a similar manner to other file systems.

2.6.28 added Ocfs2 support for JBD2, and made it the default. A patch is in
here which drops support for JBD completely from Ocfs2. This should make
coding up new features easier as we only have one journaling layer to
target. Users will see no difference as JBD2 is already backwards
compatible with JBD formatted journals.

The other set of cleanups in this series is to our meta data I/O paths. Joel
did a lot of work to seperate those paths into block specific calls (with an
appropriate generic helper). This not only reduced arguments at each call
site, but it allowed us to do more efficient checking for corrupted meta
data. In the 3rd round, these internal hooks will be used to enable meta
data checksums on Ocfs2.
	--Mark

Please pull from 'upstream-round1' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-round1

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |    3 +-
 fs/Kconfig                          |   11 +-
 fs/ocfs2/Makefile                   |    4 +
 fs/ocfs2/acl.c                      |  479 ++++++++
 fs/ocfs2/acl.h                      |   58 +
 fs/ocfs2/alloc.c                    |  381 +++++--
 fs/ocfs2/alloc.h                    |   21 +
 fs/ocfs2/aops.c                     |   35 +-
 fs/ocfs2/buffer_head_io.c           |   33 +-
 fs/ocfs2/buffer_head_io.h           |   27 +-
 fs/ocfs2/dir.c                      |  123 +-
 fs/ocfs2/dlmglue.c                  |   12 +-
 fs/ocfs2/extent_map.c               |   96 ++-
 fs/ocfs2/extent_map.h               |   24 +
 fs/ocfs2/file.c                     |  115 +--
 fs/ocfs2/inode.c                    |  128 ++-
 fs/ocfs2/inode.h                    |   16 +-
 fs/ocfs2/journal.c                  |   34 +-
 fs/ocfs2/journal.h                  |   11 +-
 fs/ocfs2/localalloc.c               |    8 +-
 fs/ocfs2/namei.c                    |  238 +++--
 fs/ocfs2/ocfs2.h                    |   24 +-
 fs/ocfs2/ocfs2_jbd_compat.h         |   82 --
 fs/ocfs2/resize.c                   |   60 +-
 fs/ocfs2/slot_map.c                 |    4 +-
 fs/ocfs2/suballoc.c                 |  278 +++--
 fs/ocfs2/suballoc.h                 |   18 +-
 fs/ocfs2/super.c                    |   33 +
 fs/ocfs2/symlink.c                  |    2 +-
 fs/ocfs2/xattr.c                    | 2257 +++++++++++++++++++++--------------
 fs/ocfs2/xattr.h                    |   31 +
 31 files changed, 3006 insertions(+), 1640 deletions(-)
 create mode 100644 fs/ocfs2/acl.c
 create mode 100644 fs/ocfs2/acl.h
 delete mode 100644 fs/ocfs2/ocfs2_jbd_compat.h

Joel Becker (24):
      ocfs2: Field prefixes for the xattr_bucket structure
      ocfs2: Convenient access to an xattr bucket's block number.
      ocfs2: Convenient access to xattr bucket data blocks.
      ocfs2: Convenient access to an xattr bucket's header.
      ocfs2: Provide a wrapper to brelse() xattr bucket buffers.
      ocfs2: Improve ocfs2_read_xattr_bucket().
      ocfs2: Wrap journal_access/journal_dirty for xattr buckets.
      ocfs2: Copy xattr buckets with a dedicated function.
      ocfs2: Take ocfs2_xattr_bucket structures off of the stack.
      ocfs2: Use buckets in ocfs2_xattr_bucket_find().
      ocfs2: Use buckets in ocfs2_xattr_create_index_block().
      ocfs2: Use buckets in ocfs2_defrag_xattr_bucket().
      ocfs2: Use buckets in ocfs2_xattr_set_entry_in_bucket().
      ocfs2: Wrap inode block reads in a dedicated function.
      ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.
      ocfs2: Consolidate validation of group descriptors.
      ocfs2: Wrap group descriptor reads in a dedicated function.
      ocfs2: Morph the haphazard OCFS2_IS_VALID_GROUP_DESC() checks.
      ocfs2: Wrap extent block reads in a dedicated function.
      ocfs2: Wrap dirblock reads in a dedicated function.
      ocfs2: Wrap xattr block reads in a dedicated function
      ocfs2: Validate metadata only when it's read from disk.
      ocfs2: Wrap virtual block reads in ocfs2_read_virt_blocks()
      ocfs2: Convert ocfs2_read_dir_block() to ocfs2_read_virt_blocks()

Mark Fasheh (2):
      ocfs2: turn __ocfs2_remove_inode_range() into ocfs2_remove_btree_range()
      ocfs2: Remove JBD compatibility layer

Tao Ma (9):
      ocfs2/xattr: Remove additional bucket allocation in bucket defragment.
      ocfs2/xattr: Only set buffer update if it doesn't exist in cache.
      ocfs2/xattr: Only extend xattr bucket in need.
      ocfs2: Add clusters free in dealloc_ctxt.
      ocfs2/xattr: Move clusters free into dealloc.
      ocfs2/xattr: Reserve meta/data at the beginning of ocfs2_xattr_set.
      ocfs2/xattr: Merge xattr set transaction.
      ocfs2/xattr: Fix a bug in xattr allocation estimation
      ocfs2/xattr: Restore not_found in xis

Tiger Yang (10):
      ocfs2: move new inode allocation out of the transaction
      ocfs2: add ocfs2_xattr_set_handle
      ocfs2: add security xattr API
      ocfs2: add ocfs2_init_security in during file create
      ocfs2: add ocfs2_xattr_get_nolock
      ocfs2: add POSIX ACL API
      ocfs2: add ocfs2_check_acl
      ocfs2: add ocfs2_acl_chmod
      ocfs2: add ocfs2_init_acl in mknod
      ocfs2: add mount option and Kconfig option for acl
