From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 11 Aug 2009 11:31:34 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 2.6.31-rc5
Message-ID: <20090811183134.GA28478@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here are all the outstanding ocfs2 fixes for 2.6.31.  The major
fixes are for aio write and for non-sparse file extending.  There are
also a couple of b-tree fixes as well as some for quotas.
	Please pull.

Joel

The following changes since commit 44b572809581d5a10dbe35aa6bf689f32b9c5ad6:
  Yinghai Lu (1):
        x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa is not compiled in

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Goldwyn Rodrigues (2):
      ocfs2: Initialize count in aio_write before generic_write_checks
      ocfs2: Remove redundant BUG_ON in __dlm_queue_ast()

Jan Kara (9):
      ocfs2: Fix deadlock on umount
      ocfs2: Make global quota files blocksize aligned
      ocfs2: Mark buffer uptodate before calling ocfs2_journal_access_dq()
      ocfs2: Initialize blocks allocated to local quota file
      ocfs2: Zero out padding of on disk dquot structure
      ocfs2: Fix initialization of blockcheck stats
      ocfs2: Remove syncjiff field from quota info
      ocfs2: Define credit counts for quota operations
      ocfs2: Fix possible deadlock when extending quota file

Jeff Liu (1):
      ocfs2: trivial fix for s/migrate/migration/ in dlmrecovery.c logging

Jeff Mahoney (1):
      ocfs2: Fixup orphan scan cleanup after failed mount

Roel Kluin (1):
      ocfs2: keep index within status_map[]

Subrata Modak (1):
      ocfs2: Fix compilation warning for fs/ocfs2/xattr.c

Sunil Mushran (1):
      ocfs2: Initialize the cluster we're writing to in a non-sparse extend

Tao Ma (3):
      ocfs2: Add extra credits and access the modified bh in update_edge_lengths.
      ocfs2: Use ocfs2_rec_clusters in ocfs2_adjust_adjacent_records.
      ocfs2/quota: Release lock for error in ocfs2_quota_write.

Wengang Wang (3):
      ocfs2: log the actual return value of ocfs2_file_aio_write()
      ocfs2: Fix error return in ocfs2_write_cluster()
      ocfs2: Fail ocfs2_get_block() immediately when a block needs allocation

 fs/ocfs2/alloc.c           |   47 +++++++++++++--
 fs/ocfs2/aops.c            |   69 ++++++++++++++++-------
 fs/ocfs2/dcache.c          |   35 +++++++++---
 fs/ocfs2/dcache.h          |    3 +
 fs/ocfs2/dlm/dlmast.c      |    1 -
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 fs/ocfs2/file.c            |    5 +-
 fs/ocfs2/journal.c         |    8 ++-
 fs/ocfs2/journal.h         |   19 ++++---
 fs/ocfs2/ocfs2.h           |   22 ++++++-
 fs/ocfs2/quota.h           |    1 -
 fs/ocfs2/quota_global.c    |  134 +++++++++++++++++++++++--------------------
 fs/ocfs2/quota_local.c     |  110 +++++++++++++++++++++++++++++++-----
 fs/ocfs2/stack_o2cb.c      |    3 +-
 fs/ocfs2/super.c           |   30 +++++++++-
 fs/ocfs2/xattr.c           |    3 +-
 16 files changed, 357 insertions(+), 135 deletions(-)
-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
