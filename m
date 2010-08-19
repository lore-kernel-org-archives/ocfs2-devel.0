From: Joel Becker <boel.becker@oracle.com>
Date: Thu, 19 Aug 2010 13:44:20 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.36, part 2.
Message-ID: <20100819204419.GA1585@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus et al,
	Here is the second batch of ocfs2 changes for 2.6.36.  We've
ironed out all of the ordering with the extN/jbd2 folks, and they have
stewed for a little as well.
	There's nothing large in here.  ocfs2 has long supported devices
larger than 2^32 sectors in the code; we now toggle that capability on.
Tao has added readahead to our CoW operations.  We also have one more
ECC fix and a data flush correction.
	Since negotiating the procedural stuff took a bit, I'm well
aware that we're past -rc1.  If you would rather any of this wait for
.37, let me know which pieces and I can respin without them.
	Please pull.

Joel

The following changes since commit 5af568cbd55f60b5a1d174f621b273e4f585dc35:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2010-08-11 09:23:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Goldwyn Rodrigues (1):
      Reorganize data elements to reduce struct sizes

Jan Kara (2):
      ocfs2: Flush drive's caches on fdatasync
      ocfs2: Remove ocfs2_sync_inode()

Joel Becker (2):
      Merge branch 'cow_readahead' of git://oss.oracle.com/git/tma/linux-2.6 into ocfs2-merge-window
      libfs: Fix shift bug in generic_check_addressable()

Patrick J. LoPresti (3):
      ext3/ext4: Factor out disk addressability check
      JBD2: Allow feature checks before journal recovery
      OCFS2: Allow huge (> 16 TiB) volumes to mount

Sunil Mushran (2):
      ocfs2: Fix metaecc error messages
      ocfs2: Fix incorrect checksum validation error

Tao Ma (9):
      ocfs2: Add some trace log for orphan scan.
      ocfs2: Remove obscure error handling in direct_write.
      ocfs2: Remove unused old_id in ocfs2_commit_cache.
      ocfs2: Remove obsolete comments before ocfs2_start_trans.
      ocfs2: pass struct file* to ocfs2_write_begin_nolock.
      ocfs2: pass struct file* to ocfs2_prepare_inode_for_write.
      ocfs2: Add struct file to ocfs2_refcount_cow.
      ocfs2: Add readahead support for CoW.
      ocfs2: Add readhead during CoW.

Tristan Ye (1):
      Ocfs2: Add new OCFS2_IOC_INFO ioctl for ocfs2 v8.

 fs/ext3/super.c         |    4 +-
 fs/ext4/super.c         |    8 +-
 fs/jbd2/journal.c       |    4 +
 fs/libfs.c              |   29 ++++
 fs/ocfs2/aops.c         |    9 +-
 fs/ocfs2/aops.h         |    3 +-
 fs/ocfs2/blockcheck.c   |    4 +-
 fs/ocfs2/file.c         |   49 +++----
 fs/ocfs2/inode.c        |    6 +-
 fs/ocfs2/inode.h        |   11 +-
 fs/ocfs2/ioctl.c        |  356 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/journal.c      |    9 +-
 fs/ocfs2/journal.h      |    3 +-
 fs/ocfs2/mmap.c         |    7 +-
 fs/ocfs2/ocfs2.h        |   23 ++-
 fs/ocfs2/ocfs2_ioctl.h  |   95 +++++++++++++
 fs/ocfs2/refcounttree.c |   43 ++++++-
 fs/ocfs2/refcounttree.h |    7 +-
 fs/ocfs2/super.c        |   51 ++++++-
 include/linux/fs.h      |    2 +
 20 files changed, 645 insertions(+), 78 deletions(-)
