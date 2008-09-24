From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:00:41 -0700
Subject: [Ocfs2-devel] [PATCH 0/39] Ocfs2 updates for 2.6.28
Message-ID: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

Hi,

	The following patches comprise the bulk of Ocfs2 updates for the
2.6.28 merge window. They can roughly be broken up into 4 sets which add
incremental features to Ocfs2. The patches are presented as they come in
git.


EA Support

The largest set adds support for extended attributes in Ocfs2. Extended
attributes are stored both within the inode block, and externally, when their
numbers grow. Individual attributes can be arbitrarily sized. Smaller ones
have their data stored inline. Larger attributes grow out to a btree. In
theory the btrees have similar limits to inode data. In practice though, the
VFS limits EA sizes to 64K.

When inode space for attributes run low, new ones are created in an external
disk block. When the block fills up, external attributes are moved to an
indexed btree. The btree can store many thousands of attributes, if needed.

The patches leading up to EA support further abstracted portions of the Ocfs2
btree code. Ultimately, this means we can "add" a btree to any Ocfs2 structure
by embedding a header, and providing the proper callbacks to manipulate
certain key fields. The xattr code makes use of this, as will future Ocfs2
features.

Joel made some further improvements to our 'generic' (for Ocfs2 at least)
btree support which completed the interface by cleaning things up and
providing for proper callbacks in a static operations structure. Those patches
follow the xattr series as they were developed afterwards.


JBD2 Support

Ocfs2 can now use JBD2. Amongst other benefits, this allows us to support
large block devices with more than 32 bits worth of block numbers. As a part
of these patches, and 'inode64' mount option is added which toggles creation
of inodes whose inode number requires more than 32 bits to be adequately
described.

JBD2 support in Ocfs2 is compiled in by default, however since journaling is
so central to the operation of a file system, we kept our 'legacy' JBD
support. We did this to provide a fallback for any users who might hit a
problem, while we fix it. Legacy JBD support will be removed from Ocfs2 in
2.6.29.


Cluster Aware POSIX File Locks

This was added via the 'plock' interface which Dave Teigland pulled into
fs/dlm last merge window. The majority of the support is actually provided in
userspace via the dlm_controld. As a result, cluster-aware POSIX locks only
work for userspace cluster stacks right now.


Local Alloc Throttling

These patches allow the "local alloc" file in Ocfs2 to throttle back the
number of free disk blocks it caches. This is done during times of extreme
fragmentation, or very low disk space. The traditional behavior was to
completely disable the local alloc feature, which resulted in performance
problems on some corner cases. The throttling has increased performance by 10
times during such situations.


Please pull from 'merge_window' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git merge_window

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |    4 +
 fs/Kconfig                          |   40 +-
 fs/ocfs2/Makefile                   |    5 +-
 fs/ocfs2/alloc.c                    |  857 +++++--
 fs/ocfs2/alloc.h                    |   86 +-
 fs/ocfs2/aops.c                     |   49 +-
 fs/ocfs2/cluster/masklog.c          |    1 +
 fs/ocfs2/cluster/masklog.h          |    1 +
 fs/ocfs2/dir.c                      |   26 +-
 fs/ocfs2/extent_map.c               |   60 +
 fs/ocfs2/extent_map.h               |    3 +
 fs/ocfs2/file.c                     |  313 +--
 fs/ocfs2/file.h                     |   32 +-
 fs/ocfs2/inode.c                    |   28 +-
 fs/ocfs2/inode.h                    |    4 +
 fs/ocfs2/journal.c                  |   72 +-
 fs/ocfs2/journal.h                  |   52 +-
 fs/ocfs2/localalloc.c               |  362 +++-
 fs/ocfs2/localalloc.h               |    4 +
 fs/ocfs2/locks.c                    |   15 +
 fs/ocfs2/locks.h                    |    1 +
 fs/ocfs2/namei.c                    |   13 +-
 fs/ocfs2/ocfs2.h                    |   56 +-
 fs/ocfs2/ocfs2_fs.h                 |  220 ++-
 fs/ocfs2/ocfs2_jbd_compat.h         |   82 +
 fs/ocfs2/stack_user.c               |   33 +
 fs/ocfs2/stackglue.c                |   20 +
 fs/ocfs2/stackglue.h                |   19 +
 fs/ocfs2/suballoc.c                 |  205 ++-
 fs/ocfs2/suballoc.h                 |   26 +-
 fs/ocfs2/super.c                    |   59 +-
 fs/ocfs2/symlink.c                  |    9 +
 fs/ocfs2/uptodate.c                 |   38 +-
 fs/ocfs2/uptodate.h                 |    3 +
 fs/ocfs2/xattr.c                    | 4851 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h                    |   68 +
 fs/ocfs2/xattr_trusted.c            |   82 +
 fs/ocfs2/xattr_user.c               |   94 +
 38 files changed, 7271 insertions(+), 622 deletions(-)
 create mode 100644 fs/ocfs2/ocfs2_jbd_compat.h
 create mode 100644 fs/ocfs2/xattr.c
 create mode 100644 fs/ocfs2/xattr.h
 create mode 100644 fs/ocfs2/xattr_trusted.c
 create mode 100644 fs/ocfs2/xattr_user.c

Joel Becker (15):
      ocfs2: Prefix the extent tree operations structure.
      ocfs2: Prefix the ocfs2_extent_tree structure.
      ocfs2: Make ocfs2_extent_tree get/put instead of alloc.
      ocfs2: Make 'private' into 'object' on ocfs2_extent_tree.
      ocfs2: Provide the get_root_el() method to ocfs2_extent_tree_operations.
      ocfs2: Use struct ocfs2_extent_tree in ocfs2_num_free_extents().
      ocfs2: Determine an extent tree's max_leaf_clusters in an et_op.
      ocfs2: Create specific get_extent_tree functions.
      ocfs2: Add an insertion check to ocfs2_extent_tree_operations.
      ocfs2: Make ocfs2_extent_tree the first-class representation of a tree.
      ocfs2: Comment struct ocfs2_extent_tree_operations.
      ocfs2: Change ocfs2_get_*_extent_tree() to ocfs2_init_*_extent_tree()
      ocfs2: Limit inode allocation to 32bits.
      ocfs2: Add the 'inode64' mount option.
      ocfs2: Switch over to JBD2.

Mark Fasheh (5):
      ocfs2: POSIX file locks support
      ocfs2: Track local alloc bits internally
      ocfs2: throttle back local alloc when low on disk space
      ocfs2: track local alloc state via debugfs
      ocfs2: fix printk format warnings

Sunil Mushran (1):
      ocfs2: Add xattr mount option in ocfs2_show_options()

Tao Ma (15):
      ocfs2: Modify ocfs2_num_free_extents for future xattr usage.
      ocfs2: Use ocfs2_extent_list instead of ocfs2_dinode.
      ocfs2: Abstract ocfs2_extent_tree in b-tree operations.
      ocfs2: Make high level btree extend code generic
      ocfs2: Add the basic xattr disk layout in ocfs2_fs.h
      ocfs2: Add helper function in uptodate.c for removing xattr clusters
      ocfs2: Add extent tree operation for xattr value btrees
      ocfs2: Add xattr index tree operations
      ocfs2: Add xattr bucket iteration for large numbers of EAs
      ocfs2: Add xattr lookup code xattr btrees
      ocfs2: Optionally limit extent size in ocfs2_insert_extent()
      ocfs2: Enable xattr set in index btree
      ocfs2: Delete all xattr buckets during inode removal
      ocfs2: bug-fix for journal extend in xattr.
      ocfs2: Resolve deadlock in ocfs2_xattr_free_block.

Tiger Yang (3):
      ocfs2: reserve inline space for extended attribute
      ocfs2: Add extended attribute support
      ocfs2: Add incompatible flag for extended attribute
