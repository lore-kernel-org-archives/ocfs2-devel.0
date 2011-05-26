From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 26 May 2011 02:46:33 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 features for $next_version
Message-ID: <20110526094632.GB8252@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Linus et al,
	Here are the new ocfs2 changes for the $next_version merge
window.  They include FITRIM support and the basics of online
defragmentation.
	Please pull.

Joel

The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5:

  tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git linux-next

Amerigo Wang (1):
      ocfs2: remove the /sys/o2cb symlink

Joel Becker (1):
      Merge branch 'move_extents' of git://oss.oracle.com/git/tye/linux-2.6 into ocfs2-merge-window

Robin Dong (1):
      ocfs2: change incorrect 'extern' keyword to 'static' in dlmfs

Sunil Mushran (3):
      ocfs2/dlm: dlm_is_lockres_migrateable() returns boolean
      ocfs2/dlm: Add new dlm message DLM_BEGIN_EXIT_DOMAIN_MSG
      ocfs2/dlm: Do not migrate resource to a node that is leaving the domain

Tao Ma (3):
      ocfs2: Add ocfs2_trim_fs for SSD trim support.
      ocfs2: Add FITRIM ioctl.
      ocfs2: Add trace event for trim.

Tiger Yang (1):
      ocfs2: clean up mount option about atime in ocfs2.txt

Tristan Ye (19):
      Ocfs2: Using inline funcs to set/clear *FILLED* flags in info handler.
      Ocfs2: Add a new code 'OCFS2_INFO_FREEINODE' for o2info ioctl.
      Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
      Ocfs2/refcounttree: Publicize couple of funcs from refcounttree.c
      Ocfs2/move_extents: Adding new ioctl code 'OCFS2_IOC_MOVE_EXT' to ocfs2.
      Ocfs2/move_extents: Add basic framework and source files for extent moving.
      Ocfs2/move_extents: lock allocators and reserve metadata blocks and data clusters for extents moving.
      Ocfs2/move_extents: move a range of extent.
      Ocfs2/move_extents: defrag a range of extent.
      Ocfs2/move_extents: find the victim alloc group, where the given #blk fits.
      Ocfs2/move_extents: helper to validate and adjust moving goal.
      Ocfs2/move_extents: helper to probe a proper region to move in an alloc group.
      Ocfs2/move_extents: helpers to update the group descriptor and global bitmap inode.
      Ocfs2/move_extents: move entire/partial extent.
      Ocfs2/move_extents: helper to calculate the defraging length in one run.
      Ocfs2/move_extents: move/defrag extents within a certain range.
      Ocfs2/move_extents: Let defrag handle partial extent moving.
      Ocfs2/move_extents: Set several trivial constraints for threshold.
      Ocfs2: Teach local-mounted ocfs2 to handle unwritten_extents correctly.

 Documentation/ABI/{obsolete => removed}/o2cb |    9 +-
 Documentation/feature-removal-schedule.txt   |   10 -
 Documentation/filesystems/ocfs2.txt          |    8 +-
 fs/ocfs2/Makefile                            |    1 +
 fs/ocfs2/alloc.c                             |  166 ++++
 fs/ocfs2/alloc.h                             |    1 +
 fs/ocfs2/cluster/sys.c                       |    9 -
 fs/ocfs2/dlm/dlmcommon.h                     |   14 +
 fs/ocfs2/dlm/dlmdebug.c                      |    6 +
 fs/ocfs2/dlm/dlmdomain.c                     |   94 ++-
 fs/ocfs2/dlm/dlmmaster.c                     |  255 ++----
 fs/ocfs2/dlm/dlmrecovery.c                   |    1 +
 fs/ocfs2/dlmfs/dlmfs.c                       |    2 +-
 fs/ocfs2/file.c                              |    1 +
 fs/ocfs2/ioctl.c                             |  492 +++++++++++-
 fs/ocfs2/move_extents.c                      | 1153 ++++++++++++++++++++++++++
 fs/ocfs2/move_extents.h                      |   22 +
 fs/ocfs2/ocfs2_ioctl.h                       |   68 ++
 fs/ocfs2/ocfs2_trace.h                       |   25 +
 fs/ocfs2/refcounttree.c                      |   58 +-
 fs/ocfs2/refcounttree.h                      |   11 +
 fs/ocfs2/super.c                             |    2 +-
 22 files changed, 2146 insertions(+), 262 deletions(-)
 rename Documentation/ABI/{obsolete => removed}/o2cb (65%)
 create mode 100644 fs/ocfs2/move_extents.c
 create mode 100644 fs/ocfs2/move_extents.h
