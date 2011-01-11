From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 10 Jan 2011 17:28:13 -0800
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 updates for 2.6.38-rc
Message-ID: <20110111012812.GF4879@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Linus et al,
	Here are the ocfs2 updates for 2.6.38-rc.  We've added some
statistics tracking and the ability to replay our truncate logs in the
allocation path.
	Please pull.

The following changes since commit b0c3844d8af6b9f3f18f31e1b0502fbefa2166be:

  Linux 2.6.37-rc6 (2010-12-15 17:24:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Dan Carpenter (1):
      ocfs2/cluster: dereferencing before checking in nst_seq_show()

Joel Becker (1):
      MAINTAINERS: Update Joel Becker's email address

Randy Dunlap (1):
      ocfs2: fix build for OCFS2_FS_STATS not enabled

Sunil Mushran (15):
      ocfs2/dlm: Cleanup mlogs in dlmthread.c, dlmast.c and dlmdomain.c
      ocfs2/cluster: Pin the remote node item in configfs
      ocfs2/cluster: Remove dropped region from o2hb quorum region bitmap
      ocfs2/cluster: Pin/unpin o2hb regions
      ocfs2/cluster: Show pin state for each o2hb region
      ocfs2/cluster: Pin the local node when o2hb thread starts
      ocfs2/dlm: Cleanup dlmdebug.c
      ocfs2/dlm: Minor cleanup
      ocfs2/dlm: Hard code the values for enums
      ocfs2: Add DEBUG_FS dependency
      ocfs2/cluster: Replace timeval with ktime in struct o2net_send_tracking
      ocfs2/cluster: Use ktime instead of timeval in struct o2net_sock_container
      ocfs2/cluster: Track send message timing stats for each socket
      ocfs2/cluster: Track process message timing stats for each socket
      ocfs2/cluster: Show o2net timing statistics

Tao Ma (3):
      ocfs2: Try to free truncate log when meeting ENOSPC in write.
      ocfs2: Release buffer_head in case of error in ocfs2_double_lock.
      ocfs2: Remove unused truncate function from alloc.c

Wengang Wang (1):
      ocfs2/dlm: make existing convertion precedent over new lock

 MAINTAINERS                     |    5 +-
 fs/ocfs2/Kconfig                |    2 +-
 fs/ocfs2/alloc.c                |   77 +----------
 fs/ocfs2/alloc.h                |    4 -
 fs/ocfs2/aops.c                 |   59 ++++++++-
 fs/ocfs2/cluster/heartbeat.c    |  246 ++++++++++++++++++++++++++++-----
 fs/ocfs2/cluster/netdebug.c     |  286 ++++++++++++++++++++++++++-------------
 fs/ocfs2/cluster/tcp.c          |  145 ++++++++++++++------
 fs/ocfs2/cluster/tcp_internal.h |   33 +++--
 fs/ocfs2/dlm/dlmast.c           |   76 +++++++----
 fs/ocfs2/dlm/dlmcommon.h        |   86 ++++++------
 fs/ocfs2/dlm/dlmdebug.c         |  200 ++++++++++-----------------
 fs/ocfs2/dlm/dlmdebug.h         |    5 -
 fs/ocfs2/dlm/dlmdomain.c        |   10 +-
 fs/ocfs2/dlm/dlmlock.c          |    3 +
 fs/ocfs2/dlm/dlmthread.c        |  132 +++++++++---------
 fs/ocfs2/namei.c                |    5 +-
 fs/ocfs2/ocfs2.h                |    5 +
 18 files changed, 845 insertions(+), 534 deletions(-)

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

			http://www.jlbec.org/
			jlbec at evilplan.org
