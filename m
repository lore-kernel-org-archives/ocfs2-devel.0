From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 8 Feb 2010 15:44:55 -0800
Subject: [Ocfs2-devel]  [GIT PULL] ocfs2 fixes for 2.6.33-rc7
Message-ID: <20100208234455.GE1832@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hey Linus,
	Here are a number of ocfs2 fixes for 2.6.33.  A good number of
them are in ocfs2's dlmglue, the layer that handling lock caching
between the filesystem and the DLM it is using.  Dave Tiegland,
the maintainter of fs/dlm, has been testing ocfs2 atop fs/dlm.  fs/dlm
is far more asynchronous than ocfs2's own o2dlm, and his tests exposed
a number of places where the dlm glue got lucky in the past.  A big
thank you to Dave for helping find and fix these bugs.
	The rest is a smattering of bugs all over the place.  They are
pretty simple, mostly.
	Please pull.

Joel


The following changes since commit 9a3cbe3265c7714e8ee423feb6e27a080af79608:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

OGAWA Hirofumi (1):
      ocfs2: Fix refcnt leak on ocfs2_fast_follow_link() error path

Roel Kluin (1):
      ocfs2: Fix contiguousness check in ocfs2_try_to_merge_extent_map()

Sunil Mushran (11):
      ocfs2/trivial: Remove trailing whitespaces
      ocfs2/dlm: Ignore LVBs of locks in the Blocked list
      ocfs2/dlm: Print more messages during lock migration
      ocfs2/dlm: Handle EAGAIN for compatibility - v2
      ocfs2: Prevent a livelock in dlmglue
      ocfs2: Do not downconvert if the lock level is already compatible
      ocfs2: Remove overzealous BUG_ON during blocked lock processing
      ocfs2: Plugs race between the dc thread and an unlock ast message
      ocfs2/dlm: Remove BUG_ON in dlm recovery when freeing locks of a dead node
      ocfs2/dlm: Fix printing of lockname
      ocfs2/cluster: Make o2net connect messages KERN_NOTICE

Tao Ma (5):
      ocfs2: Sync max_inline_data_with_xattr from tools.
      ocfs2: Fix memory overflow in cow_by_page.
      ocfs2: Only bug out when page size is larger than cluster size.
      ocfs2: Add parenthesis to wrap the check for O_DIRECT.
      ocfs2: Use compat_ptr in reflink_arguments.

Wengang Wang (2):
      ocfs2: fix a misleading variable name
      ocfs2: Fix setting of OCFS2_LOCK_BLOCKED during bast

 fs/ocfs2/aops.c                 |    4 +-
 fs/ocfs2/buffer_head_io.c       |    2 +-
 fs/ocfs2/cluster/heartbeat.c    |    6 +-
 fs/ocfs2/cluster/tcp.c          |   10 ++--
 fs/ocfs2/cluster/tcp_internal.h |    4 +-
 fs/ocfs2/dlm/dlmapi.h           |    2 +-
 fs/ocfs2/dlm/dlmast.c           |    2 +-
 fs/ocfs2/dlm/dlmconvert.c       |    2 +-
 fs/ocfs2/dlm/dlmdebug.c         |    2 +-
 fs/ocfs2/dlm/dlmdomain.c        |    2 +-
 fs/ocfs2/dlm/dlmlock.c          |    2 +-
 fs/ocfs2/dlm/dlmmaster.c        |   38 +++++-----
 fs/ocfs2/dlm/dlmrecovery.c      |  147 +++++++++++++++++++++++++++-----------
 fs/ocfs2/dlm/dlmunlock.c        |    8 +-
 fs/ocfs2/dlmglue.c              |   85 ++++++++++++++++++++---
 fs/ocfs2/export.c               |    2 +-
 fs/ocfs2/extent_map.c           |    2 +-
 fs/ocfs2/file.c                 |   18 +++---
 fs/ocfs2/inode.c                |    4 +-
 fs/ocfs2/ioctl.c                |   14 ++++-
 fs/ocfs2/journal.c              |    2 +-
 fs/ocfs2/ocfs2.h                |    4 +
 fs/ocfs2/ocfs2_fs.h             |   11 +++-
 fs/ocfs2/refcounttree.c         |   12 ++-
 fs/ocfs2/stack_o2cb.c           |   12 ++--
 fs/ocfs2/super.c                |    2 +-
 fs/ocfs2/symlink.c              |   10 ++--
 fs/ocfs2/uptodate.c             |    4 +-
 28 files changed, 284 insertions(+), 129 deletions(-)

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
