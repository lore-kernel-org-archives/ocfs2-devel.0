From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 29 Mar 2010 14:40:10 -0700
Subject: [Ocfs2-devel]   [GIT PULL] ocfs2 fixes for 2.6.34-rc2
Message-ID: <20100329214010.GB12499@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com


Linus et al,
	Here are various fixes that have collected for ocfs2.  One very
important fix keeps ocfs2 from running out of inodes with plenty of
free space.  Another prevents a local crash when using userspace
cluster stacks.
	Please pull.

Joel


The following changes since commit a3d3203e4bb40f253b1541e310dc0f9305be7c84:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Mark Fasheh (3):
      ocfs2: set i_mode on disk during acl operations
      ocfs2: Always try for maximum bits with new local alloc windows
      ocfs2: Clear undo bits when local alloc is freed

Sachin Prabhu (1):
      Skip check for mandatory locks when unlocking

Srinivas Eeda (1):
      ocfs2: Fix a race in o2dlm lockres mastery

Tao Ma (4):
      ocfs2: Change bg_chain check for ocfs2_validate_gd_parent.
      ocfs2: Update i_blocks in reflink operations.
      ocfs2: Fix the update of name_offset when removing xattrs
      ocfs2: Init meta_ac properly in ocfs2_create_empty_xattr_block.

Tristan Ye (2):
      Ocfs2: Journaling i_flags and i_orphaned_slot when adding inode to orphan dir.
      Ocfs2: Handle deletion of reflinked oprhan inodes correctly.

 fs/ocfs2/acl.c           |   77 +++++++++++++++++++++++++--
 fs/ocfs2/dlm/dlmmaster.c |    4 +-
 fs/ocfs2/inode.c         |   15 +++++
 fs/ocfs2/localalloc.c    |   10 ++--
 fs/ocfs2/locks.c         |    2 +-
 fs/ocfs2/namei.c         |   28 ++++++++--
 fs/ocfs2/ocfs2.h         |   14 ++++-
 fs/ocfs2/refcounttree.c  |    1 +
 fs/ocfs2/suballoc.c      |  129 +++++++++++++++++++++++++++++-----------------
 fs/ocfs2/suballoc.h      |    5 ++
 fs/ocfs2/xattr.c         |   12 ++---
 11 files changed, 223 insertions(+), 74 deletions(-)
