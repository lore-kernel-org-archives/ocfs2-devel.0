From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 28 Mar 2011 12:36:46 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.39-rc
Message-ID: <20110328193642.GE23209@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Linus et al,
	Here are the ocfs2 changes for 2.6.39.  The major change is
Tao's tracing rework.  We've had our own tracing infrastructure forever,
and this is the first stage of replacing it with trace events.
	Please pull.

Joel

The following changes since commit 1788c208aab15f9d9d1d24cff0d0c64b5c73bbee:

  Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-28 07:52:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2 upstream-linus

Goldwyn Rodrigues (1):
      Treat writes as new when holes span across page boundaries

Joel Becker (1):
      Merge branch 'mlog_replace_for_39' of git://repo.or.cz/taoma-kernel into ocfs2-merge-window-fix

Rakib Mullick (1):
      fs,ocfs2: Move o2net_get_func_run_time under CONFIG_OCFS2_FS_STATS.

Sunil Mushran (2):
      ocfs2: Use hrtimer to track ocfs2 fs lock stats
      ocfs2/dlm: Move kmalloc() outside the spinlock

Tao Ma (33):
      ocfs2: optimize ocfs2_check_dir_entry() with unlikely() annotations
      ocfs2: Remove ENTRY from masklog.
      ocfs2: Remove EXIT from masklog.
      ocfs2: Remove mlog(0) from fs/ocfs2/alloc.c
      ocfs2: Remove mlog(0) from fs/ocfs2/localalloc.c
      ocfs2: Remove mlog(0) from fs/ocfs2/suballoc.c
      ocfs2: Remove mlog(0) from fs/ocfs2/suballoc.c
      ocfs2: Remove DISK_ALLOC from masklog.
      ocfs2: Remove masklog ML_REFCOUNT.
      ocfs2: Remove mlog(0) from fs/ocfs2/aops.c
      ocfs2: Remove FILE_IO from masklog.
      ocfs2: remove INODE from unused files.
      ocfs2: Remove mlog(0) from fs/ocfs2/file.c
      ocfs2: Little refactoring against ocfs2_iget.
      ocfs2: Remove masklog ML_INODE.
      ocfs2: Remove masklog ML_EXTENT_MAP.
      ocfs2: Remove mlog(0) from fs/ocfs2/slot_map.c
      ocfs2: Remove mlog(0) from fs/ocfs2/heartbeat.c
      ocfs2: Remove masklog ML_SUPER.
      ocfs2: Remove masklog ML_XATTR.
      ocfs2: Remove masklog ML_RESERVATIONS.
      ocfs2: Remove mlog(0) from quota_local.c.
      ocfs2: Remove masklog ML_QUOTA.
      ocfs2: remove NAMEI from symlink.c
      ocfs2: Remove mlog(0) from fs/ocfs2/dir.c
      ocfs2: Remove masklog ML_NAMEI.
      ocfs2: Remove masklog ML_DCACHE.
      ocfs2: Remove masklog ML_EXPORT.
      ocfs2: Remove masklog ML_JOURNAL.
      ocfs2: Remove masklog ML_BH_IO.
      ocfs2: Remove masklog ML_UPTODATE.
      ocfs2: Remove masklog ML_AIO.
      ocfs2: Make the left masklogs compat.

Tristan Ye (1):
      Ocfs2: Using macro to set/clear *FILLED* flags in info handler.

Wengang Wang (1):
      ocfs2: Add ocfs2_trace.h.

 fs/ocfs2/acl.c               |    1 -
 fs/ocfs2/alloc.c             |  214 ++--
 fs/ocfs2/aops.c              |   82 +-
 fs/ocfs2/buffer_head_io.c    |   49 +-
 fs/ocfs2/cluster/heartbeat.c |    3 -
 fs/ocfs2/cluster/masklog.c   |   20 +-
 fs/ocfs2/cluster/masklog.h   |  105 +--
 fs/ocfs2/cluster/tcp.c       |   10 +-
 fs/ocfs2/dcache.c            |   45 +-
 fs/ocfs2/dir.c               |  121 +--
 fs/ocfs2/dlm/dlmconvert.c    |    6 +-
 fs/ocfs2/dlm/dlmdomain.c     |   36 +-
 fs/ocfs2/dlm/dlmlock.c       |   10 +-
 fs/ocfs2/dlm/dlmmaster.c     |    6 +-
 fs/ocfs2/dlm/dlmrecovery.c   |    9 +-
 fs/ocfs2/dlm/dlmunlock.c     |    4 +-
 fs/ocfs2/dlmglue.c           |  246 +---
 fs/ocfs2/export.c            |   47 +-
 fs/ocfs2/extent_map.c        |   10 +-
 fs/ocfs2/file.c              |  220 ++--
 fs/ocfs2/heartbeat.c         |    4 +-
 fs/ocfs2/inode.c             |  134 +--
 fs/ocfs2/ioctl.c             |   41 +-
 fs/ocfs2/journal.c           |  168 +--
 fs/ocfs2/localalloc.c        |  109 +-
 fs/ocfs2/locks.c             |    1 -
 fs/ocfs2/mmap.c              |    7 +-
 fs/ocfs2/namei.c             |  175 ++--
 fs/ocfs2/ocfs2.h             |   23 +-
 fs/ocfs2/ocfs2_trace.h       | 2739 ++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_global.c      |   45 +-
 fs/ocfs2/quota_local.c       |   16 +-
 fs/ocfs2/refcounttree.c      |  158 ++--
 fs/ocfs2/reservations.c      |   57 +-
 fs/ocfs2/resize.c            |   23 +-
 fs/ocfs2/slot_map.c          |   16 +-
 fs/ocfs2/suballoc.c          |  189 ++--
 fs/ocfs2/super.c             |   89 +-
 fs/ocfs2/symlink.c           |   14 +-
 fs/ocfs2/sysfile.c           |    1 -
 fs/ocfs2/uptodate.c          |   73 +-
 fs/ocfs2/xattr.c             |  155 ++--
 42 files changed, 3855 insertions(+), 1626 deletions(-)
 create mode 100644 fs/ocfs2/ocfs2_trace.h
