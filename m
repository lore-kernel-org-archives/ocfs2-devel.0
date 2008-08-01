From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 31 Jul 2008 17:44:25 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs fixes
Message-ID: <20080801004425.GL28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

The only non-fix here is Joel's new configfs convenience macros, but nobody
is using them yet, so I think the patch is safe.

By the way, these patches (as usual) are all rebased on top of your latest
tree. I think that since the vast majority of ocfs2 and configfs patches are
self-contained and within a small area of the kernel that this should
probably be fine. If you feel otherwise however, please let me know and I'll
happily respin this as a set of topic-branch merges.
	--Mark

--
Mark Fasheh

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/configfs/configfs.txt    |   17 ++-
 ...figfs_example.c => configfs_example_explicit.c} |   18 +-
 ...onfigfs_example.c => configfs_example_macros.c} |   75 ++------
 fs/configfs/configfs_internal.h                    |    3 +
 fs/configfs/dir.c                                  |  210 ++++++++++++++++----
 fs/configfs/symlink.c                              |   26 +++
 fs/ocfs2/aops.c                                    |   29 ++--
 fs/ocfs2/file.c                                    |    2 +-
 fs/ocfs2/journal.c                                 |  173 +++++++++++++----
 fs/ocfs2/journal.h                                 |    3 +-
 fs/ocfs2/ocfs2.h                                   |    2 +
 fs/ocfs2/ocfs2_fs.h                                |    5 +-
 fs/ocfs2/super.c                                   |   12 +-
 include/linux/configfs.h                           |   68 ++++++-
 14 files changed, 475 insertions(+), 168 deletions(-)
 copy Documentation/filesystems/configfs/{configfs_example.c => configfs_example_explicit.c} (96%)
 rename Documentation/filesystems/configfs/{configfs_example.c => configfs_example_macros.c} (85%)

Joel Becker (3):
      configfs: Include linux/err.h in linux/configfs.h
      configfs: Pin configfs subsystems separately from new config_items.
      configfs: Convenience macros for attribute definition.

Julia Lawall (1):
      ocfs2: Release mutex in error handling code

Louis Rilling (5):
      configfs: Fix symlink() to a removing item
      configfs: Fix failing symlink() making rmdir() fail
      configfs: Prevent userspace from creating new entries under attaching directories
      configfs: Lock new directory inodes before removing on cleanup after failure
      configfs: Fix open directory making rmdir() fail

Sunil Mushran (3):
      ocfs2: Add counter in struct ocfs2_dinode to track journal replays
      ocfs2: Fix race between mount and recovery
      ocfs2: Fix oops when racing files truncates with writes into an mmap region

--
Mark Fasheh
