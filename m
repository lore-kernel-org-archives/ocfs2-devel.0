From: Joel Becker <boel.becker@oracle.com>
Date: Fri, 16 Jul 2010 13:53:25 -0700
Subject: [Ocfs2-devel] [GIT PULL] Important ocfs2 fixes for 2.6.35
Message-ID: <20100716205325.GB30859@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here are the major ocfs2 fixes for 2.6.35-rc5.  A few more
fixes have trickled in, but as these major fixes have been tested, I
didn't want to delay them any longer.
	The first major fix you know about: the tail zeroing fix when
extending files.  It's been run under heavy testing for a week now, and
we're quite happy.  We should also no longer be touching any pages past
i_size in write or CoW.
	The second major fix was discovered and fixed by Mark and Jan.
The jbd2 triggers we added for block checksumming had a small window
where the checksum from transaction N-2 could be written in transaction
N-1 because transaction N accessed the buffer but never actually
modified it.  We fix this by checksumming at the moment we freeze the
data rather than the moment we write the commit.  This was a hard bug
to trap, and very good work by Mark and Jan.
	Please pull.

Joel


The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Dan Carpenter (1):
      ocfs2: tighten up strlen() checking

Jan Kara (1):
      jbd2/ocfs2: Fix block checksumming when a buffer is used in several transactions

Joel Becker (4):
      ocfs2: When zero extending, do it by page.
      ocfs2: Zero the tail cluster when extending past i_size.
      ocfs2: No need to zero pages past i_size.
      ocfs2: Silence gcc warning in ocfs2_write_zero_page().

Julia Lawall (1):
      fs/ocfs2/dlm: Add missing spin_unlock

Tao Ma (6):
      ocfs2: Move orphan scan work to ocfs2_wq.
      ocfs2: Limit default local alloc size within bitmap range.
      ocfs2: Remove the redundant cpu_to_le64.
      ocfs2: make xattr extension work with new local alloc reservation.
      ocfs2: Make xattr reflink work with new local alloc reservation.
      ocfs2: Don't duplicate pages past i_size during CoW.

Wengang Wang (2):
      ocfs2/dlm: don't access beyond bitmap size
      ocfs2/dlm: Remove BUG_ON from migration in the rare case of a down node

 fs/jbd2/journal.c          |   15 +-
 fs/jbd2/transaction.c      |    9 +-
 fs/ocfs2/aops.c            |   94 +++++++-------
 fs/ocfs2/dlm/dlmdomain.c   |    3 +-
 fs/ocfs2/dlm/dlmmaster.c   |   22 ++-
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 fs/ocfs2/file.c            |  309 +++++++++++++++++++++++++++++++++++---------
 fs/ocfs2/file.h            |    6 +-
 fs/ocfs2/journal.c         |   30 ++--
 fs/ocfs2/localalloc.c      |    7 +
 fs/ocfs2/quota_global.c    |    2 +-
 fs/ocfs2/quota_local.c     |    4 +-
 fs/ocfs2/refcounttree.c    |   12 ++
 fs/ocfs2/suballoc.c        |    2 +-
 fs/ocfs2/xattr.c           |  200 +++++++++++++++++++---------
 include/linux/jbd2.h       |   11 +-
 16 files changed, 504 insertions(+), 224 deletions(-)
