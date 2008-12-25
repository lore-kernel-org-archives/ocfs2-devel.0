From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:15 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 patches for merge window,
	batch 3/3
Message-ID: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

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

Please pull from 'upstream-round3' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-round3

to receive the following updates:

 fs/jbd2/commit.c             |    9 +
 fs/jbd2/journal.c            |   19 ++
 fs/jbd2/transaction.c        |   47 ++++
 fs/ocfs2/Makefile            |    1 +
 fs/ocfs2/alloc.c             |  315 ++++++++++++++++------------
 fs/ocfs2/alloc.h             |    9 +-
 fs/ocfs2/aops.c              |    8 +-
 fs/ocfs2/blockcheck.c        |  477 ++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/blockcheck.h        |   82 +++++++
 fs/ocfs2/dir.c               |  282 ++++++++++++++++++++++---
 fs/ocfs2/dir.h               |    2 +
 fs/ocfs2/dlm/dlmast.c        |   52 +++---
 fs/ocfs2/dlm/dlmcommon.h     |    3 +
 fs/ocfs2/dlm/dlmdebug.c      |   53 ++---
 fs/ocfs2/dlm/dlmdomain.c     |    1 +
 fs/ocfs2/dlm/dlmmaster.c     |   42 ++++-
 fs/ocfs2/dlm/dlmthread.c     |    3 +-
 fs/ocfs2/file.c              |   16 +-
 fs/ocfs2/inode.c             |   33 +++-
 fs/ocfs2/journal.c           |  188 ++++++++++++++++-
 fs/ocfs2/journal.h           |   32 +++-
 fs/ocfs2/localalloc.c        |   18 +-
 fs/ocfs2/namei.c             |   38 ++--
 fs/ocfs2/ocfs2.h             |   15 ++
 fs/ocfs2/ocfs2_fs.h          |   87 +++++++-
 fs/ocfs2/quota_global.c      |   25 ++-
 fs/ocfs2/quota_local.c       |   18 +-
 fs/ocfs2/resize.c            |   16 +-
 fs/ocfs2/suballoc.c          |   87 ++++++---
 fs/ocfs2/super.c             |   11 +
 fs/ocfs2/xattr.c             |  312 ++++++++++++++++++----------
 fs/ocfs2/xattr.h             |   14 ++
 include/linux/jbd2.h         |   31 +++
 include/linux/journal-head.h |    8 +
 34 files changed, 1910 insertions(+), 444 deletions(-)
 create mode 100644 fs/ocfs2/blockcheck.c
 create mode 100644 fs/ocfs2/blockcheck.h

Joel Becker (23):
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

Mark Fasheh (1):
      ocfs2: Add directory block trailers.

Sunil Mushran (5):
      ocfs2/dlm: Fix a race between migrate request and exit domain
      ocfs2/dlm: Clean up errors in dlm_proxy_ast_handler()
      ocfs2/dlm: Hold off sending lockres drop ref message while lockres is migrating
      ocfs2/dlm: Fix race in adding/removing lockres' to/from the tracking list
      ocfs2/dlm: Fix race during lockres mastery

Tao Ma (3):
      ocfs2/xattr: Remove extend_trans call and add its credits from the beginning
      ocfs2/xattr: Always updating ctime during xattr set.
      ocfs2/xattr: fix credits calculation during index create

Tiger Yang (3):
      ocfs2: calculate and reserve credits for xattr value in mknod
      ocfs2: alloc xattr bucket in ocfs2_xattr_set_handle
      ocfs2: Add xattr support checking in init_security
