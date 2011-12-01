From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 1 Dec 2011 14:53:07 -0800
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 3.2-rc3
Message-ID: <20111201225306.GP1495@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Linus et al,
	Here are the all of the ocfs2 fixes that have been stewing in my
tree.  Almost all of them have been in linux-next since before 3.1; I've
just been behind.
	Please pull.

Joel

The following changes since commit b6844e8f64920cdee620157252169ba63afb0c89:

  Merge branch 'for-linus' of master.kernel.org:/home/rmk/linux-2.6-arm (2011-07-24 10:20:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Akinobu Mita (2):
      ocfs2: use proper little-endian bitops
      ocfs2: avoid unaligned access to dqc_bitmap

Dan Carpenter (2):
      ocfs2: checking the wrong variable in ocfs2_move_extent()
      ocfs2: null deref on allocation error

Dan Magenheimer (1):
      ocfs2: send correct UUID to cleancache initialization

Jan Kara (2):
      ocfs2: Avoid livelock in ocfs2_readpage()
      ocfs2: Use filemap_write_and_wait() instead of write_inode_now()

Joel Becker (1):
      Merge branch 'mw-3.1-jul25' of git://oss.oracle.com/git/smushran/linux-2.6 into ocfs2-fixes

Julia Lawall (1):
      fs/ocfs2/dlm/dlmlock.c: free kmem_cache_zalloc'd data using kmem_cache_free

Mark Fasheh (2):
      ocfs2: serialize unaligned aio
      ocfs2: honor O_(D)SYNC flag in fallocate

Sunil Mushran (16):
      ocfs2/cluster: Abort heartbeat start on hard-ro devices
      ocfs2/cluster: Clean up messages in o2net
      ocfs2/dlm: Clean up messages in o2dlm
      ocfs2: Clean up messages in stack_o2cb.c
      ocfs2/dlm: Cleanup up dlm_finish_local_lockres_recovery()
      ocfs2/dlm: Clean up refmap helpers
      ocfs2/dlm: Trace insert/remove of resource to/from hash
      ocfs2/dlm: Cleanup dlm_wait_for_node_death() and dlm_wait_for_node_recovery()
      ocfs2/dlm: Take inflight reference count for remotely mastered resources too
      ocfs2/dlm: dlmlock_remote() needs to account for remastery
      ocfs2/cluster: Fix output in file elapsed_time_in_ms
      ocfs2/cluster: Add new function o2net_fill_node_map()
      ocfs2/cluster: Cluster up now includes network connections too
      ocfs2: Clean up messages in the fs
      ocfs2: Add comment about orphan scanning
      ocfs2: Implement llseek()

Tiger Yang (1):
      ocfs2: Bugfix for hard readonly mount

Wengang Wang (3):
      ocfs2: Fix ocfs2_page_mkwrite()
      ocfs2: make direntry invalid when deleting it
      ocfs2: Commit transactions in error cases -v2

Xiaowei.Hu (1):
      ocfs2: Add a missing journal credit in ocfs2_link_credits() -v2

 fs/ocfs2/alloc.c             |    2 +-
 fs/ocfs2/aops.c              |   69 +++++++++++++--
 fs/ocfs2/aops.h              |   14 +++
 fs/ocfs2/cluster/heartbeat.c |  194 ++++++++++++++++++++++++++----------------
 fs/ocfs2/cluster/netdebug.c  |  102 +++++++++++++++-------
 fs/ocfs2/cluster/tcp.c       |  138 ++++++++++++++++--------------
 fs/ocfs2/cluster/tcp.h       |    2 +
 fs/ocfs2/dir.c               |    3 +-
 fs/ocfs2/dlm/dlmcommon.h     |   56 +++----------
 fs/ocfs2/dlm/dlmdomain.c     |   44 +++++-----
 fs/ocfs2/dlm/dlmlock.c       |   54 ++++++------
 fs/ocfs2/dlm/dlmmaster.c     |  175 +++++++++++++++++++-------------------
 fs/ocfs2/dlm/dlmrecovery.c   |  164 ++++++++++++++++++------------------
 fs/ocfs2/dlm/dlmthread.c     |   16 ++--
 fs/ocfs2/dlmglue.c           |   21 +++--
 fs/ocfs2/extent_map.c        |   96 +++++++++++++++++++++
 fs/ocfs2/extent_map.h        |    2 +
 fs/ocfs2/file.c              |   96 ++++++++++++++++++++-
 fs/ocfs2/inode.c             |    2 +-
 fs/ocfs2/inode.h             |    3 +
 fs/ocfs2/ioctl.c             |   11 ++-
 fs/ocfs2/journal.c           |   23 +++++-
 fs/ocfs2/journal.h           |    5 +-
 fs/ocfs2/mmap.c              |   53 +++++------
 fs/ocfs2/move_extents.c      |    2 +-
 fs/ocfs2/ocfs2.h             |   51 +++++++++++-
 fs/ocfs2/quota_local.c       |   23 +++--
 fs/ocfs2/slot_map.c          |    4 +-
 fs/ocfs2/stack_o2cb.c        |   71 ++++++++++++++--
 fs/ocfs2/super.c             |   25 ++++--
 fs/ocfs2/xattr.c             |   10 ++-
 31 files changed, 995 insertions(+), 536 deletions(-)
