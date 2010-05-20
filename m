From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 May 2010 16:52:07 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 updates for 2.6.35
Message-ID: <20100520235207.GE8335@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus et al,
	Here are the ocfs2 updates for 2.6.35.  There are two major
changes.  Mark added allocation reservations to our node-local
allocators.  This gets us much more contiguousness when many processes
are growing files in parallel.  On the other end of contiguousness,
ocfs2 has had a major limitation since the beginning.  When ocfs2 needs
new inodes, it has always grown its metadata allocators in contiguous
hunks. As you might expect, badly fragmented filesystems may be unable
to add new inodes even when there is plenty of unused space.  Tao and I
have added discontiguous block groups to fix the problem.
	There's also various small stuff.  The shortlog is below.  Please
pull.

Joel

The following changes since commit a0fe3cc5d36a5f5b4f60abfe1a4b1caf4a5cce5a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Joel Becker (16):
      ocfs2: Define data structures for discontiguous block groups.
      ocfs2: Allocate discontiguous block groups.
      ocfs2: Pass suballocation results back via a structure.
      ocfs2: Add suballoc_loc to metadata blocks.
      ocfs2: ocfs2_claim_suballoc_bits() doesn't need an osb argument.
      ocfs2: Trim suballocations if they cross discontiguous regions
      ocfs2: ocfs2_claim_*() don't need an ocfs2_super argument.
      ocfs2: Return allocated metadata blknos on the ocfs2_suballoc_result.
      ocfs2: Set suballoc_loc on allocated metadata.
      ocfs2: Grow discontig block groups in one transaction.
      ocfs2: Don't relink cluster groups when allocating discontig block groups
      ocfs2: Make ocfs2_journal_dirty() void.
      ocfs2: Wrap signal blocking in void functions.
      ocfs2: Block signals for mkdir/link/symlink/O_CREAT.
      Merge branch 'discontig-bg' of git://oss.oracle.com/git/tma/linux-2.6 into ocfs2-merge-window
      ocfs2: Silence a gcc warning.

Julia Lawall (2):
      fs/ocfs2/dlm: Drop memory allocation cast
      fs/ocfs2/dlm: Use kstrdup

Mark Fasheh (9):
      ocfs2: allocation reservations
      ocfs2: use allocation reservations during file write
      ocfs2: use allocation reservations for directory data
      ocfs2: allocate btree internal block groups from the global bitmap
      ocfs2: remove ocfs2_local_alloc_in_range()
      ocfs2: clean up localalloc mount option size parsing
      ocfs2: increase the default size of local alloc windows
      ocfs2: change default reservation window sizes
      ocfs2: Add dir_resv_level mount option

Srinivas Eeda (1):
      o2net: log socket state changes

Sunil Mushran (3):
      ocfs2/dlm: Make o2dlm domain join/leave messages KERN_NOTICE
      ocfs2: Make nointr a default mount option
      ocfs2/dlm: Increase o2dlm lockres hash size

Tao Ma (11):
      ocfs2: Some tiny bug fixes for discontiguous block allocation.
      ocfs2: ocfs2_group_bitmap_size has to handle old volume.
      ocfs2: Add ocfs2_gd_is_discontig.
      ocfs2: Free block to the right block group.
      ocfs2: Set ac_last_group properly with discontig group.
      ocfs2: enable discontig block group support.
      ocfs2: make ocfs2_adjust_resv_from_alloc simple.
      ocfs2/trivial: Code cleanup for allocation reservation.
      ocfs2: Make ocfs2_extend_trans() really extend.
      ocfs2: Reset xattr value size after xa_cleanup_value_truncate().
      ocfs2: Don't retry xattr set in case value extension fails.

Tristan Ye (4):
      Ocfs2: Optimize ocfs2 truncate to use ocfs2_remove_btree_range() instead.
      Ocfs2: Fix hole punching to correctly do CoW during cluster zeroing.
      Ocfs2: Make ocfs2_find_cpos_for_left_leaf() public.
      Ocfs2: Optimize punching-hole code.

Wengang Wang (2):
      ocfs2: print node # when tcp fails
      ocfs2:dlm: avoid dlm->ast_lock lockres->spinlock dependency break

 Documentation/filesystems/ocfs2.txt |    7 +
 fs/ocfs2/Makefile                   |    1 +
 fs/ocfs2/alloc.c                    |  908 +++++++++--------------------------
 fs/ocfs2/alloc.h                    |   12 +-
 fs/ocfs2/aops.c                     |    3 +
 fs/ocfs2/cluster/masklog.c          |    1 +
 fs/ocfs2/cluster/masklog.h          |    1 +
 fs/ocfs2/cluster/tcp.c              |    3 +
 fs/ocfs2/dir.c                      |   75 +--
 fs/ocfs2/dlm/dlmast.c               |    8 +-
 fs/ocfs2/dlm/dlmcommon.h            |    4 +-
 fs/ocfs2/dlm/dlmconvert.c           |    4 +-
 fs/ocfs2/dlm/dlmdomain.c            |   28 +-
 fs/ocfs2/dlm/dlmlock.c              |    6 +-
 fs/ocfs2/dlm/dlmmaster.c            |   30 +-
 fs/ocfs2/dlm/dlmrecovery.c          |   27 +-
 fs/ocfs2/dlm/dlmthread.c            |   16 +-
 fs/ocfs2/dlm/dlmunlock.c            |    3 +-
 fs/ocfs2/file.c                     |  215 +++++++--
 fs/ocfs2/inode.c                    |   45 +--
 fs/ocfs2/inode.h                    |    2 +
 fs/ocfs2/journal.c                  |   26 +-
 fs/ocfs2/journal.h                  |   15 +-
 fs/ocfs2/localalloc.c               |  275 ++++++++----
 fs/ocfs2/localalloc.h               |    3 +
 fs/ocfs2/mmap.c                     |   48 +--
 fs/ocfs2/namei.c                    |   91 ++---
 fs/ocfs2/ocfs2.h                    |   22 +
 fs/ocfs2/ocfs2_fs.h                 |  144 +++++-
 fs/ocfs2/quota_global.c             |    4 +-
 fs/ocfs2/quota_local.c              |   50 +--
 fs/ocfs2/refcounttree.c             |   74 ++--
 fs/ocfs2/refcounttree.h             |    4 +-
 fs/ocfs2/reservations.c             |  847 ++++++++++++++++++++++++++++++++
 fs/ocfs2/reservations.h             |  159 ++++++
 fs/ocfs2/resize.c                   |   19 +-
 fs/ocfs2/suballoc.c                 |  688 ++++++++++++++++++---------
 fs/ocfs2/suballoc.h                 |   21 +-
 fs/ocfs2/super.c                    |   88 +++-
 fs/ocfs2/super.h                    |    7 +
 fs/ocfs2/xattr.c                    |  103 ++---
 41 files changed, 2596 insertions(+), 1491 deletions(-)
 create mode 100644 fs/ocfs2/reservations.c
 create mode 100644 fs/ocfs2/reservations.h
