From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:41 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 patches for merge window,
	batch 2/3
Message-ID: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

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

Please pull from 'upstream-round2' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-round2

to receive the following updates:

 fs/Kconfig                         |    7 +
 fs/Makefile                        |    1 +
 fs/dquot.c                         |  436 +++++++++----
 fs/ext3/super.c                    |   16 +-
 fs/ext4/super.c                    |   15 +-
 fs/ocfs2/Makefile                  |    2 +
 fs/ocfs2/alloc.c                   |   20 +-
 fs/ocfs2/aops.c                    |   16 +-
 fs/ocfs2/buffer_head_io.c          |    5 +-
 fs/ocfs2/cluster/masklog.c         |    1 +
 fs/ocfs2/cluster/masklog.h         |    1 +
 fs/ocfs2/dir.c                     |   24 +-
 fs/ocfs2/dlmglue.c                 |  146 +++++
 fs/ocfs2/dlmglue.h                 |   19 +
 fs/ocfs2/file.c                    |   78 ++-
 fs/ocfs2/file.h                    |    3 +
 fs/ocfs2/inode.c                   |   16 +-
 fs/ocfs2/inode.h                   |    2 +
 fs/ocfs2/journal.c                 |  142 ++++-
 fs/ocfs2/journal.h                 |   85 ++-
 fs/ocfs2/namei.c                   |   44 ++-
 fs/ocfs2/ocfs2.h                   |    7 +-
 fs/ocfs2/ocfs2_fs.h                |  126 ++++-
 fs/ocfs2/ocfs2_lockid.h            |    5 +
 fs/ocfs2/quota.h                   |  117 ++++
 fs/ocfs2/quota_global.c            |  990 ++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c             | 1253 ++++++++++++++++++++++++++++++++++++
 fs/ocfs2/super.c                   |  277 ++++++++-
 fs/ocfs2/xattr.c                   |  567 +++++++++--------
 fs/quota.c                         |   11 +-
 fs/quota_tree.c                    |  645 +++++++++++++++++++
 fs/quota_tree.h                    |   25 +
 fs/quota_v1.c                      |   28 +-
 fs/quota_v2.c                      |  631 +++----------------
 {include/linux => fs}/quotaio_v1.h |    0 
 {include/linux => fs}/quotaio_v2.h |   33 +-
 fs/reiserfs/super.c                |   10 +-
 include/linux/Kbuild               |    4 -
 include/linux/dqblk_qtree.h        |   56 ++
 include/linux/dqblk_v1.h           |    7 -
 include/linux/dqblk_v2.h           |   22 +-
 include/linux/jbd2.h               |    1 +
 include/linux/quota.h              |  108 +++-
 include/linux/quotaops.h           |   96 +++-
 mm/pdflush.c                       |    1 +
 45 files changed, 4925 insertions(+), 1174 deletions(-)
 create mode 100644 fs/ocfs2/quota.h
 create mode 100644 fs/ocfs2/quota_global.c
 create mode 100644 fs/ocfs2/quota_local.c
 create mode 100644 fs/quota_tree.c
 create mode 100644 fs/quota_tree.h
 rename {include/linux => fs}/quotaio_v1.h (100%)
 rename {include/linux => fs}/quotaio_v2.h (68%)
 create mode 100644 include/linux/dqblk_qtree.h

Jan Kara (36):
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
      mm: Export pdflush_operation()
      ocfs2: Support nested transactions
      ocfs2: Assign feature bits and system inodes to quota feature and quota files
      ocfs2: Mark system files as not subject to quota accounting
      ocfs2: Implementation of local and global quota file handling
      ocfs2: Add quota calls for allocation and freeing of inodes and space
      ocfs2: Implement quota syncing thread
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

Joel Becker (14):
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

Mark Fasheh (2):
      jbd2: Add BH_JBDPrivateStart
      ocfs2: Use BH_JBDPrivateStart instead of BH_Unshadow

Tao Ma (4):
      ocfs2: fix indendation in ocfs2_dquot_drop_slow
      ocfs2/quota: sparse fixes for quota
      ocfs2: Narrow the transaction for deleting xattrs from a bucket.
      ocfs2/quota: Add QUOTA in mlog_attribute.
