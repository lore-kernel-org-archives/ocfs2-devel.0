From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:11 2008
Subject: [Ocfs2-devel] [PATCH 0/30] Ocfs2 and Configfs patches for 2.6.25-rc1
Message-ID: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com


The following series of patches comprises the bulk of our outstanding
changes for Ocfs2 and Configfs.


Configfs gets some lockdep updates, and we remove it's EXPERIMENTAL tag as
things have been quite stable for some time now.


Ocfs2 gets fixes that made it in too late for 2.6.24, and several new
features. The most interesting are listed below:

We've been on the path to removing the "vote" cluster messaging in Ocfs2 for
some time now. I'm happy to announce that this series gets rid of the last
set of messages, which were used for "mount" and "unmount". Though not
really a performance problem, the messages required that Ocfs2 track node
information such as IP address, port, etc. By removing those votes, we no
longer need that information in the file system (the dlm still uses it, but
that's ok). As such, total kernel code complexity goes down and we get Ocfs2
in shape for a future where the cluster stack can be kept in userspace and
Ocfs2 can then easily plug into something like fs/dlm.

Initially, Ocfs2 was designed with two locks per inode - a "meta lock"
covering inode meta data, and a "data lock" covering inode data. Recently,
that decision has been revisited in light of some facts: The majority of
users mount the file system in data=ordered mode, which means that
transferring a meta data lock also syncs inode data. Having a 2nd, mostly
unused lock in place only meant extra messaging for lock mastery. Merging
the functionality into one inode lock improves that situation by
streamlining the most common cases of cluster locking.

Ocfs2 now supports online resize. Userspace does most of the setup and then
initiates the operation via a set of Ocfs2 specific ioctls(). This is
similar to how ext3 handles things, though we don't use the same exact
ioctls because Ocfs2 has a different disk structure.

Finally, Ocfs2 now supports cluster aware flock(). This is pretty straight
forward in that we map flock() requests directly to dlm locks. Mandatory
locks aren't supported, as they would require some expensive cluster
messaging. Posix file locks (lockf()) support is a very early work in
progress, so it'll have to wait until at least 2.6.26, quite possibly later.
In the meantime, flock() support is ready and works well.


Also included in this series is a trivial patch to split out some of
include/linux/dlm.h into an include/linux/dlmconstants.h. It's actually part
of a series of patches targetting 2.6.26 which teach Ocfs2 how to optionally
plug into fs/dlm. The patch stands on it's own as a nice cleanup though, so
I'm sending it out for 2.6.25.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |   16 +-
 Documentation/ioctl-number.txt      |    1 +
 fs/Kconfig                          |   14 +-
 fs/configfs/dir.c                   |    5 +-
 fs/configfs/file.c                  |    2 +-
 fs/ocfs2/Makefile                   |    5 +-
 fs/ocfs2/alloc.c                    |    8 +-
 fs/ocfs2/aops.c                     |  137 ++++---
 fs/ocfs2/buffer_head_io.c           |   61 +++
 fs/ocfs2/buffer_head_io.h           |    2 +
 fs/ocfs2/cluster/heartbeat.h        |    2 +-
 fs/ocfs2/cluster/tcp.h              |    4 +-
 fs/ocfs2/cluster/tcp_internal.h     |    8 +-
 fs/ocfs2/cluster/ver.c              |    2 +-
 fs/ocfs2/dcache.c                   |    8 +-
 fs/ocfs2/dir.c                      |    8 +-
 fs/ocfs2/dlm/dlmfsver.c             |    2 +-
 fs/ocfs2/dlm/dlmrecovery.c          |   19 +-
 fs/ocfs2/dlm/dlmver.c               |    2 +-
 fs/ocfs2/dlmglue.c                  |  546 +++++++++++++++++++-------
 fs/ocfs2/dlmglue.h                  |   31 +-
 fs/ocfs2/endian.h                   |    5 -
 fs/ocfs2/export.c                   |    8 +-
 fs/ocfs2/file.c                     |  163 +++++---
 fs/ocfs2/file.h                     |    6 +
 fs/ocfs2/heartbeat.c                |   80 ----
 fs/ocfs2/heartbeat.h                |    2 -
 fs/ocfs2/inode.c                    |   84 ++--
 fs/ocfs2/inode.h                    |   10 +-
 fs/ocfs2/ioctl.c                    |   31 ++-
 fs/ocfs2/journal.c                  |   51 ++--
 fs/ocfs2/journal.h                  |    6 +
 fs/ocfs2/localalloc.c               |   50 ++-
 fs/ocfs2/locks.c                    |  125 ++++++
 fs/ocfs2/{vote.h => locks.h}        |   29 +-
 fs/ocfs2/mmap.c                     |   17 +-
 fs/ocfs2/namei.c                    |   66 ++--
 fs/ocfs2/ocfs2.h                    |   29 +-
 fs/ocfs2/ocfs2_fs.h                 |   22 +
 fs/ocfs2/ocfs2_lockid.h             |    5 +
 fs/ocfs2/resize.c                   |  641 +++++++++++++++++++++++++++++
 fs/ocfs2/{vote.h => resize.h}       |   32 +--
 fs/ocfs2/slot_map.c                 |   19 -
 fs/ocfs2/slot_map.h                 |    2 -
 fs/ocfs2/suballoc.c                 |   20 +-
 fs/ocfs2/suballoc.h                 |    8 +
 fs/ocfs2/super.c                    |  140 ++++----
 fs/ocfs2/sysfile.c                  |    2 +-
 fs/ocfs2/ver.c                      |    2 +-
 fs/ocfs2/vote.c                     |  756 -----------------------------------
 include/linux/Kbuild                |    1 +
 include/linux/dlm.h                 |  140 +-------
 include/linux/dlmconstants.h        |  159 ++++++++
 53 files changed, 1980 insertions(+), 1614 deletions(-)
 create mode 100644 fs/ocfs2/locks.c
 copy fs/ocfs2/{vote.h => locks.h} (54%)
 create mode 100644 fs/ocfs2/resize.c
 rename fs/ocfs2/{vote.h => resize.h} (50%)
 delete mode 100644 fs/ocfs2/vote.c
 create mode 100644 include/linux/dlmconstants.h

Jan Kara (4):
      ocfs2: Silence false lockdep warnings
      ocfs2: Safer read_inline_data()
      ocfs2: Use generic_file_llseek
      ocfs2: printf fixes

Joel Becker (2):
      dlm: Split lock mode and flag constants into a sharable header.
      configfs: Remove EXPERIMENTAL

Joonwoo Park (2):
      configfs: dir.c fix possible recursive locking
      configfs: file.c fix possible recursive locking

Marcin Slusarz (1):
      ocfs2: convert byte order of constant instead of variable

Mark Fasheh (14):
      ocfs2_dlm: Call node eviction callbacks from heartbeat handler
      ocfs2: Remove fs dependency on ocfs2_heartbeat module
      ocfs2: Remove mount/unmount votes
      ocfs2: Add data downconvert worker to inode lock
      ocfs2: Remove data locks
      ocfs2: Rename ocfs2_meta_[un]lock
      ocfs2: Readpages support
      ocfs2: Documentation update
      ocfs2: Add missing permission checks
      ocfs2: build warnings fix
      ocfs2: Support commit= mount option
      ocfs2: add flock lock type
      ocfs2: cluster aware flock()
      ocfs2: bump version number

Sunil Mushran (2):
      ocfs2: Local alloc window size changeable via mount option
      ocfs2: Update default cluster timeouts

Tao Ma (5):
      ocfs2: Initalize bitmap_cpg of ocfs2_super to be the maximum.
      ocfs2: Reserve ioctl range
      ocfs2: Add group extend for online resize
      ocfs2: Implement group add for online resize
      ocfs2/dlm: Clear joining_node on hearbeat node down
