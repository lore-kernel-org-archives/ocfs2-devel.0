From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 5 Jan 2009 09:15:44 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 patches for merge window
Message-ID: <20090105171544.GN17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>

Hi Linus,

	Here are the Ocfs2 patches for this merge window. Everything (minus
the topmost, trivial fix) has been sent to LKML for review, including all
outside-of-ocfs2 patches. Since there's a lot of patches, I did it in stages:

http://lkml.org/lkml/2008/12/19/280
http://lkml.org/lkml/2008/12/22/213
http://lkml.org/lkml/2008/12/25/123

I'll include the contents of my original descriptions after the diffstat, so
you can get all the gory details. I'll give some highlights here:

- New features: ACL, security attributes, user/group quotas, metadata
  checksums.
- The majority of patches outside of Ocfs2 are due to Jan's work on quota
  code, which Ocfs2 wanted so that we could add quota support. Jan has been Cc'd
  on this mail.
- The other non-fs/ocfs2 patch is to JBD2 - it adds some support we needed
  to enable the metadata checksumming. The patch has made rounds on
  ext4-devel and LKML a few times now. Ted has been Cc'd on this mail.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |    3 +-
 fs/Kconfig                          |   18 +-
 fs/Makefile                         |    1 +
 fs/dquot.c                          |  436 ++++--
 fs/ext3/super.c                     |   16 +-
 fs/ext4/super.c                     |   15 +-
 fs/jbd2/commit.c                    |    9 +
 fs/jbd2/journal.c                   |   19 +
 fs/jbd2/transaction.c               |   47 +
 fs/ocfs2/Makefile                   |    7 +
 fs/ocfs2/acl.c                      |  479 ++++++
 fs/ocfs2/acl.h                      |   58 +
 fs/ocfs2/alloc.c                    |  710 ++++++---
 fs/ocfs2/alloc.h                    |   30 +-
 fs/ocfs2/aops.c                     |   59 +-
 fs/ocfs2/blockcheck.c               |  477 ++++++
 fs/ocfs2/blockcheck.h               |   82 +
 fs/ocfs2/buffer_head_io.c           |   32 +-
 fs/ocfs2/buffer_head_io.h           |   27 +-
 fs/ocfs2/cluster/masklog.c          |    1 +
 fs/ocfs2/cluster/masklog.h          |    1 +
 fs/ocfs2/dir.c                      |  399 ++++-
 fs/ocfs2/dir.h                      |    2 +
 fs/ocfs2/dlm/dlmast.c               |   52 +-
 fs/ocfs2/dlm/dlmcommon.h            |    3 +
 fs/ocfs2/dlm/dlmdebug.c             |   53 +-
 fs/ocfs2/dlm/dlmdomain.c            |    1 +
 fs/ocfs2/dlm/dlmmaster.c            |   42 +-
 fs/ocfs2/dlm/dlmthread.c            |    3 +-
 fs/ocfs2/dlmglue.c                  |  168 ++-
 fs/ocfs2/dlmglue.h                  |   19 +
 fs/ocfs2/extent_map.c               |   96 +-
 fs/ocfs2/extent_map.h               |   24 +
 fs/ocfs2/file.c                     |  209 ++--
 fs/ocfs2/file.h                     |    3 +
 fs/ocfs2/inode.c                    |  175 ++-
 fs/ocfs2/inode.h                    |   18 +-
 fs/ocfs2/journal.c                  |  364 ++++-
 fs/ocfs2/journal.h                  |  128 ++-
 fs/ocfs2/localalloc.c               |   26 +-
 fs/ocfs2/namei.c                    |  318 +++--
 fs/ocfs2/ocfs2.h                    |   46 +-
 fs/ocfs2/ocfs2_fs.h                 |  213 +++-
 fs/ocfs2/ocfs2_jbd_compat.h         |   82 -
 fs/ocfs2/ocfs2_lockid.h             |    5 +
 fs/ocfs2/quota.h                    |  119 ++
 fs/ocfs2/quota_global.c             | 1025 ++++++++++++
 fs/ocfs2/quota_local.c              | 1253 +++++++++++++++
 fs/ocfs2/resize.c                   |   76 +-
 fs/ocfs2/slot_map.c                 |    4 +-
 fs/ocfs2/suballoc.c                 |  363 +++--
 fs/ocfs2/suballoc.h                 |   18 +-
 fs/ocfs2/super.c                    |  328 ++++-
 fs/ocfs2/symlink.c                  |    2 +-
 fs/ocfs2/xattr.c                    | 2984 +++++++++++++++++++++--------------
 fs/ocfs2/xattr.h                    |   45 +
 fs/quota.c                          |   11 +-
 fs/quota_tree.c                     |  645 ++++++++
 fs/quota_tree.h                     |   25 +
 fs/quota_v1.c                       |   28 +-
 fs/quota_v2.c                       |  631 +-------
 {include/linux => fs}/quotaio_v1.h  |    0 
 {include/linux => fs}/quotaio_v2.h  |   33 +-
 fs/reiserfs/super.c                 |   10 +-
 include/linux/Kbuild                |    4 -
 include/linux/dqblk_qtree.h         |   56 +
 include/linux/dqblk_v1.h            |    7 -
 include/linux/dqblk_v2.h            |   22 +-
 include/linux/jbd2.h                |   32 +
 include/linux/journal-head.h        |    8 +
 include/linux/quota.h               |  108 +-
 include/linux/quotaops.h            |   96 +-
 72 files changed, 9756 insertions(+), 3153 deletions(-)
 create mode 100644 fs/ocfs2/acl.c
 create mode 100644 fs/ocfs2/acl.h
 create mode 100644 fs/ocfs2/blockcheck.c
 create mode 100644 fs/ocfs2/blockcheck.h
 delete mode 100644 fs/ocfs2/ocfs2_jbd_compat.h
 create mode 100644 fs/ocfs2/quota.h
 create mode 100644 fs/ocfs2/quota_global.c
 create mode 100644 fs/ocfs2/quota_local.c
 create mode 100644 fs/quota_tree.c
 create mode 100644 fs/quota_tree.h
 rename {include/linux => fs}/quotaio_v1.h (100%)
 rename {include/linux => fs}/quotaio_v2.h (68%)
 create mode 100644 include/linux/dqblk_qtree.h

Jan Kara (34):
      quota: Add callbacks for allocating and destroying dquot structures
      quota: Increase size of variables for limits and inode usage
      quota: Remove bogus 'optimization' in check_idq() and check_bdq()
      quota: Make _SUSPENDED just a flag
      quota: Allow to separately enable quota accounting and enforcing limits
      ext3: Use sb_any_quota_loaded() instead of sb_any_quota_enabled()
      ext4: Use sb_any_quota_loaded() instead of sb_any_quota_enabled()
      reiserfs: Use sb_any_quota_loaded() instead of sb_any_quota_enabled().
      quota: Remove compatibility function sb_any_quota_enabled()
      quota: Introduce DQUOT_QUOTA_SYS_FILE flag
      quota: Move quotaio_v[12].h from include/linux/ to fs/
      quota: Split off quota tree handling into a separate file
      quota: Convert union in mem_dqinfo to a pointer
      quota: Allow negative usage of space and inodes
      quota: Keep which entries were set by SETQUOTA quotactl
      quota: Update version number
      quota: Add helpers to allow ocfs2 specific quota initialization, freeing and recovery
      quota: Implement function for scanning active dquots
      ocfs2: Support nested transactions
      ocfs2: Assign feature bits and system inodes to quota feature and quota files
      ocfs2: Mark system files as not subject to quota accounting
      ocfs2: Implementation of local and global quota file handling
      ocfs2: Add quota calls for allocation and freeing of inodes and space
      ocfs2: Implement quota recovery
      ocfs2: Enable quota accounting on mount, disable on umount
      ocfs2: Add missing initialization
      ocfs2: Fix oops when extending quota files
      ocfs2: Make ocfs2_get_quota_block() consistent with ocfs2_read_quota_block()
      ocfs2: Fix build warnings (64-bit types vs long long)
      quota: Unexport dqblk_v1.h and dqblk_v2.h
      quota: Export dquot_alloc() and dquot_destroy() functions
      reiserfs: Add default allocation routines for quota structures
      ext3: Add default allocation routines for quota structures
      ext4: Add default allocation routines for quota structures

Joel Becker (61):
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
      ocfs2: Fix ocfs2_read_quota_block() error handling.
      ocfs2: Dirty the entire bucket in ocfs2_bucket_value_truncate()
      ocfs2: Dirty the entire first bucket in ocfs2_extend_xattr_bucket()
      ocfs2: Dirty the entire first bucket in ocfs2_cp_xattr_cluster().
      ocfs2: Explain t_is_new in ocfs2_cp_xattr_cluster().
      ocfs2: Use ocfs2_cp_xattr_bucket() in ocfs2_mv_xattr_bucket_cross_cluster().
      ocfs2: Rename ocfs2_cp_xattr_cluster() to ocfs2_mv_xattr_buckets().
      ocfs2: ocfs2_mv_xattr_buckets() can handle a partial cluster now.
      ocfs2: Use ocfs2_mv_xattr_buckets() in ocfs2_mv_xattr_bucket_cross_cluster().
      ocfs2: Start using buckets in ocfs2_adjust_xattr_cross_cluster().
      ocfs2: Pass buckets into ocfs2_mv_xattr_bucket_cross_cluster().
      ocfs2: Move buckets up into ocfs2_add_new_xattr_cluster().
      ocfs2: Move buckets up into ocfs2_add_new_xattr_bucket().
      ocfs2: Pass xs->bucket into ocfs2_add_new_xattr_bucket().
      jbd2: Add buffer triggers
      ocfs2: Add the on-disk structures for metadata checksums.
      ocfs2: Add the underlying blockcheck code.
      ocfs2: Add a validation hook for quota block reads.
      ocfs2: block read meta ecc.
      ocfs2: Add journal_access functions with jbd2 triggers.
      ocfs2: Wrap up the common use cases of ocfs2_new_path().
      ocfs2: Use metadata-specific ocfs2_journal_access_*() functions.
      ocfs2: Add ecc and checksums to ocfs2 xattr buckets.
      ocfs2: Create ocfs2_xattr_value_buf.
      ocfs2: Pull ocfs2_xattr_value_buf up from __ocfs2_remove_xattr_range().
      ocfs2: Pull ocfs2_xattr_value_buf up into ocfs2_xattr_value_truncate().
      ocfs2: Pass ocfs2_xattr_value_buf into ocfs2_xattr_value_truncate().
      ocfs2: Pass value buf to ocfs2_xattr_update_entry().
      ocfs2: Use ocfs2_xattr_value_buf in ocfs2_xattr_set_entry().
      ocfs2: Pass value buf to ocfs2_remove_value_outside().
      ocfs2: Use proper journal_access function in xattr.c
      ocfs2: Checksum and ECC for directory blocks.
      ocfs2: Validate superblock with checksum and ecc.
      ocfs2: Enable metadata checksums.
      ocfs2: Don't hand-code xor in ocfs2_hamming_encode().
      ocfs2: Another hamming code optimization.
      ocfs2: One more hamming code optimization.

Mark Fasheh (8):
      ocfs2: turn __ocfs2_remove_inode_range() into ocfs2_remove_btree_range()
      ocfs2: Remove JBD compatibility layer
      ocfs2: Periodic quota syncing
      jbd2: Add BH_JBDPrivateStart
      ocfs2: Use BH_JBDPrivateStart instead of BH_Unshadow
      ocfs2: Add directory block trailers.
      ocfs2: remove unneeded lvb casts
      ocfs2: use min_t in ocfs2_quota_read()

Sunil Mushran (5):
      ocfs2/dlm: Fix a race between migrate request and exit domain
      ocfs2/dlm: Clean up errors in dlm_proxy_ast_handler()
      ocfs2/dlm: Hold off sending lockres drop ref message while lockres is migrating
      ocfs2/dlm: Fix race in adding/removing lockres' to/from the tracking list
      ocfs2/dlm: Fix race during lockres mastery

Tao Ma (17):
      ocfs2/xattr: Remove additional bucket allocation in bucket defragment.
      ocfs2/xattr: Only set buffer update if it doesn't exist in cache.
      ocfs2/xattr: Only extend xattr bucket in need.
      ocfs2: Add clusters free in dealloc_ctxt.
      ocfs2/xattr: Move clusters free into dealloc.
      ocfs2/xattr: Reserve meta/data at the beginning of ocfs2_xattr_set.
      ocfs2/xattr: Merge xattr set transaction.
      ocfs2/xattr: Fix a bug in xattr allocation estimation
      ocfs2/xattr: Restore not_found in xis
      ocfs2: fix indendation in ocfs2_dquot_drop_slow
      ocfs2/quota: sparse fixes for quota
      ocfs2: Narrow the transaction for deleting xattrs from a bucket.
      ocfs2/quota: Add QUOTA in mlog_attribute.
      ocfs2/xattr: Remove extend_trans call and add its credits from the beginning
      ocfs2/xattr: Always updating ctime during xattr set.
      ocfs2/xattr: fix credits calculation during index create
      ocfs2: Access the right buffer_head in ocfs2_merge_rec_left.

Tiger Yang (13):
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
      ocfs2: calculate and reserve credits for xattr value in mknod
      ocfs2: alloc xattr bucket in ocfs2_xattr_set_handle
      ocfs2: Add xattr support checking in init_security


To: linux-kernel at vger.kernel.org, ocfs2-devel at oss.oracle.com
Cc: Joel Becker <joel.becker@oracle.com>
Subject: [git patches] Ocfs2 patches for merge window, batch 1/3

Hi,

As of right now, the upstream-linus branch in ocfs2.git has 136 patches for
the next merge window. Luckily, a large chunk of those are either small or
easily read. Also, many of them are generic quota changes (which already
have appropriate review and signoffs) which I carried in ocfs2.git because
Ocfs2 quotas depended on them.

Regardless, I plan to post the ocfs2 merge window patches in 3 batches to
make review easier. The first set of patches follows this mail. The final
two will be sent early next week.

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


To: linux-kernel at vger.kernel.org, ocfs2-devel at oss.oracle.com
Cc: Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>
Subject: [git patches] Ocfs2 patches for merge window, batch 2/3

Hi,

This is the second batch of Ocfs2 patches intended for the merge window. The
1st batch were sent out previously:

http://lkml.org/lkml/2008/12/19/280

The bulk of this set is comprised of Jan Kara's patches to add quota support
to Ocfs2. Many of the quota patches are to generic code, which I carried to
make merging of the Ocfs2 support easier. All of the non-ocfs2 patches
should have appropriate signoffs. Quota is handled a bit differently in
Ocfs2 than other file systems. We keep a set of node local quota files (user
and group), which periodically sync with a global file. This allows for a
higher level of concurrency on multi-node clusters. Additionally, a small
portion of each quota block is reserved for later use as a checksum field.

The other non-trivial part of this series is comprised of some more meta
data I/O cleanups by Joel. This time the focus is on writing of leaves in
indexed xattr trees and managing those changes in a fashion which makes the
meta data checksum patches in round 3 more straight forward.
	--Mark


To: linux-kernel at vger.kernel.org, ocfs2-devel at oss.oracle.com
Cc: Joel Becker <joel.becker@oracle.com>
Subject: [git patches] Ocfs2 patches for merge window, batch 3/3

Hi,

This is the 3rd and final batch of Ocfs2 patches intended for the merge
window. The 2nd batch were sent out previously:

http://lkml.org/lkml/2008/12/22/213

This batch includes some more xattr fixes, some dlm fixes from Sunil and
meta data checksumming support from Joel.

With all the other prep patches, the checksumming patches become pretty
straight forward. Mostly it's a matter of finding the right spot in our disk
structures. For most blocks, we just take an unused field. Directory data
gets a hidden structure at the end of every block. We'll actually be making
use of this structure in the future for directory indexing support. The
checksum code stores an ECC in each 64 bit field, so single bit errors can
be corrected as those blocks are read.

Checking on read is done with the per-metadata-type callbacks we previously
added. Write checks are done via a new jbd2 mechanism - 'buffer triggers',
which is implemented in the 1st patch of this series. The first version of
the buffer triggers patch got Ted's sign off, but we made some changes and
sent another version to the ext4 list. The version sent here is the latest
one. if I got my git send-email command right, Ted and the Ext4 list should
be CC'd.
        --Mark

--
Mark Fasheh
