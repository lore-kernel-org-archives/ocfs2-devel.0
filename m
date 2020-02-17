From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 17 Feb 2020 10:45:41 -0800
Subject: [Ocfs2-devel] [PATCH v6 00/19] Change readahead API
Message-ID: <20200217184613.19668-1-willy@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This series adds a readahead address_space operation to eventually
replace the readpages operation.  The key difference is that
pages are added to the page cache as they are allocated (and
then looked up by the filesystem) instead of passing them on a
list to the readpages operation and having the filesystem add
them to the page cache.  It's a net reduction in code for each
implementation, more efficient than walking a list, and solves
the direct-write vs buffered-read problem reported by yu kuai at
https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/20200116063601.39201-1-yukuai3 at huawei.com/__;!!GqivPVa7Brio!PtIesPWlAr4qdEASxdQ8iLJaLXhbYeTh-Jtaa7fhr8lAutp_j6aTaib8mzYD6v40q344mg$ 

The only unconverted filesystems are those which use fscache.
Their conversion is pending Dave Howells' rewrite which will make the
conversion substantially easier.

v6:
 - Name the private members of readahead_control with a leading underscore
   (suggested by Christoph Hellwig)
 - Fix whitespace in rst file
 - Remove misleading comment in btrfs patch
 - Add readahead_next() API and use it in iomap
 - Add iomap_readahead kerneldoc.
 - Fix the mpage_readahead kerneldoc
 - Make various readahead functions return void
 - Keep readahead_index() and readahead_offset() pointing to the start of
   this batch through the body.  No current user requires this, but it's
   less surprising.
 - Add kerneldoc for page_cache_readahead_limit
 - Make page_idx an unsigned long, and rename it to just 'i'
 - Get rid of page_offset local variable
 - Add patch to call memalloc_nofs_save() before allocating pages (suggested
   by Michal Hocko)
 - Resplit a lot of patches for more logical progression and easier review
   (suggested by John Hubbard)
 - Added sign-offs where received, and I deemed still relevant

v5 switched to passing a readahead_control struct (mirroring the
writepages_control struct passed to writepages).  This has a number of
advantages:
 - It fixes a number of bugs in various implementations, eg forgetting to
   increment 'start', an off-by-one error in 'nr_pages' or treating 'start'
   as a byte offset instead of a page offset.
 - It allows us to change the arguments without changing all the
   implementations of ->readahead which just call mpage_readahead() or
   iomap_readahead()
 - Figuring out which pages haven't been attempted by the implementation
   is more natural this way.
 - There's less code in each implementation.

Matthew Wilcox (Oracle) (19):
  mm: Return void from various readahead functions
  mm: Ignore return value of ->readpages
  mm: Use readahead_control to pass arguments
  mm: Rearrange readahead loop
  mm: Remove 'page_offset' from readahead loop
  mm: rename readahead loop variable to 'i'
  mm: Put readahead pages in cache earlier
  mm: Add readahead address space operation
  mm: Add page_cache_readahead_limit
  fs: Convert mpage_readpages to mpage_readahead
  btrfs: Convert from readpages to readahead
  erofs: Convert uncompressed files from readpages to readahead
  erofs: Convert compressed files from readpages to readahead
  ext4: Convert from readpages to readahead
  f2fs: Convert from readpages to readahead
  fuse: Convert from readpages to readahead
  iomap: Restructure iomap_readpages_actor
  iomap: Convert from readpages to readahead
  mm: Use memalloc_nofs_save in readahead path

 Documentation/filesystems/locking.rst |   6 +-
 Documentation/filesystems/vfs.rst     |  13 ++
 drivers/staging/exfat/exfat_super.c   |   7 +-
 fs/block_dev.c                        |   7 +-
 fs/btrfs/extent_io.c                  |  46 ++-----
 fs/btrfs/extent_io.h                  |   3 +-
 fs/btrfs/inode.c                      |  16 +--
 fs/erofs/data.c                       |  39 ++----
 fs/erofs/zdata.c                      |  29 ++--
 fs/ext2/inode.c                       |  10 +-
 fs/ext4/ext4.h                        |   3 +-
 fs/ext4/inode.c                       |  23 ++--
 fs/ext4/readpage.c                    |  22 ++-
 fs/ext4/verity.c                      |  35 +----
 fs/f2fs/data.c                        |  50 +++----
 fs/f2fs/f2fs.h                        |   5 +-
 fs/f2fs/verity.c                      |  35 +----
 fs/fat/inode.c                        |   7 +-
 fs/fuse/file.c                        |  46 +++----
 fs/gfs2/aops.c                        |  23 ++--
 fs/hpfs/file.c                        |   7 +-
 fs/iomap/buffered-io.c                | 118 +++++++----------
 fs/iomap/trace.h                      |   2 +-
 fs/isofs/inode.c                      |   7 +-
 fs/jfs/inode.c                        |   7 +-
 fs/mpage.c                            |  38 ++----
 fs/nilfs2/inode.c                     |  15 +--
 fs/ocfs2/aops.c                       |  34 ++---
 fs/omfs/file.c                        |   7 +-
 fs/qnx6/inode.c                       |   7 +-
 fs/reiserfs/inode.c                   |   8 +-
 fs/udf/inode.c                        |   7 +-
 fs/xfs/xfs_aops.c                     |  13 +-
 fs/zonefs/super.c                     |   7 +-
 include/linux/fs.h                    |   2 +
 include/linux/iomap.h                 |   3 +-
 include/linux/mpage.h                 |   4 +-
 include/linux/pagemap.h               |  90 +++++++++++++
 include/trace/events/erofs.h          |   6 +-
 include/trace/events/f2fs.h           |   6 +-
 mm/internal.h                         |   8 +-
 mm/migrate.c                          |   2 +-
 mm/readahead.c                        | 184 +++++++++++++++++---------
 43 files changed, 474 insertions(+), 533 deletions(-)


base-commit: 11a48a5a18c63fd7621bb050228cebf13566e4d8
-- 
2.25.0
