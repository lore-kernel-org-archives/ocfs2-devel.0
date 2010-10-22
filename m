From: Joel Becker <boel.becker@oracle.com>
Date: Thu, 21 Oct 2010 18:43:25 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.37
Message-ID: <20101022014325.GE366@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com, "Patrick J. LoPresti" <lopresti@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here are the ocfs2 changes for 2.6.37.  There are three major
additions.  Tao Ma has added readahead to our CoW operations.  Sunil
Mushran has added a global heartbeat mode, allowing one device
heartbeat to support multiple ocfs2 mounts.  Finally, Patrick J.
LoPresti has done the final work to enable ocfs2 mounts on devices larger
than 16TB.  The ocfs2 disk format has always supported it, but Patrick
finished the last mile of code.
	Please pull.

Joel


The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Goldwyn Rodrigues (3):
      Reorganize data elements to reduce struct sizes
      Track negative entries v3
      Initialize max_slots early

Jan Kara (1):
      ocfs2: Remove ocfs2_sync_inode()

Jeff Liu (1):
      ocfs2: Avoid to evaluate xattr block flags again.

Joel Becker (5):
      Merge branch 'cow_readahead' of git://oss.oracle.com/git/tma/linux-2.6 into merge-2
      libfs: Fix shift bug in generic_check_addressable()
      ocfs2: Silence unused warning.
      ocfs2: Initialize the bktcnt variable properly, and call it bucket_count
      Merge branch 'globalheartbeat-2' of git://oss.oracle.com/git/smushran/linux-2.6 into ocfs2-merge-window

Patrick J. LoPresti (3):
      ext3/ext4: Factor out disk addressability check
      JBD2: Allow feature checks before journal recovery
      OCFS2: Allow huge (> 16 TiB) volumes to mount

Poyo VL (1):
      When I tried to compile I got the following warning:

Srinivas Eeda (1):
      ocfs2: validate bg_free_bits_count after update

Sunil Mushran (23):
      ocfs2/cluster: Add heartbeat mode configfs parameter
      ocfs2: Add an incompat feature flag OCFS2_FEATURE_INCOMPAT_CLUSTERINFO
      ocfs2: Add support for heartbeat=global mount option
      ocfs2/dlm: Expose dlm_protocol in dlm_state
      ocfs2/cluster: Get all heartbeat regions
      ocfs2/dlm: Add message DLM_QUERY_REGION
      ocfs2: Print message if user mounts without starting global heartbeat
      ocfs2/dlm: Add message DLM_QUERY_NODEINFO
      ocfs2/cluster: Print messages when adding/removing heartbeat regions
      ocfs2/cluster: Print messages when adding/removing nodes
      ocfs2/cluster: Check slots for unconfigured live nodes
      ocfs2/cluster: Reorganize o2hb debugfs init
      ocfs2/cluster: Maintain live node bitmap per heartbeat region
      ocfs2/cluster: Track number of global heartbeat regions
      ocfs2/cluster: Track bitmap of live heartbeat regions
      ocfs2/cluster: Maintain bitmap of quorum regions
      ocfs2/cluster: Maintain bitmap of failed regions
      ocfs2/cluster: Create debugfs files for live, quorum and failed region bitmaps
      ocfs2/cluster: Create debugfs dir/files for each region
      ocfs2/cluster: Add mlogs for heartbeat up/down events
      ocfs2/cluster: Show per region heartbeat elapsed time
      ocfs2/cluster: Bump up dlm protocol to version 1.1
      ocfs2/cluster: Release debugfs file elapsed_time_in_ms

Tao Ma (10):
      ocfs2: pass struct file* to ocfs2_write_begin_nolock.
      ocfs2: pass struct file* to ocfs2_prepare_inode_for_write.
      ocfs2: Add struct file to ocfs2_refcount_cow.
      ocfs2: Add readahead support for CoW.
      ocfs2: Add readhead during CoW.
      ocfs2: Add some trace log for orphan scan.
      ocfs2: Remove obscure error handling in direct_write.
      ocfs2: Remove unused old_id in ocfs2_commit_cache.
      ocfs2: Remove obsolete comments before ocfs2_start_trans.
      ocfs2: Cache system inodes of other slots.

Tristan Ye (2):
      Ocfs2: Add new OCFS2_IOC_INFO ioctl for ocfs2 v8.
      ocfs2: Add a mount option "coherency=*" to handle cluster coherency for O_DIRECT writes.

 Documentation/filesystems/ocfs2.txt  |    7 +
 fs/ext3/super.c                      |    4 +-
 fs/ext4/super.c                      |    8 +-
 fs/jbd2/journal.c                    |    4 +
 fs/libfs.c                           |   29 ++
 fs/ocfs2/aops.c                      |    9 +-
 fs/ocfs2/aops.h                      |    3 +-
 fs/ocfs2/cluster/heartbeat.c         |  532 ++++++++++++++++++++++++++++++++--
 fs/ocfs2/cluster/heartbeat.h         |    4 +
 fs/ocfs2/cluster/masklog.h           |    3 +-
 fs/ocfs2/cluster/nodemanager.c       |    5 +
 fs/ocfs2/cluster/ocfs2_nodemanager.h |    6 +
 fs/ocfs2/cluster/tcp.c               |    5 +
 fs/ocfs2/dcache.c                    |   33 ++-
 fs/ocfs2/dcache.h                    |    1 +
 fs/ocfs2/dlm/dlmcommon.h             |   29 ++-
 fs/ocfs2/dlm/dlmdebug.c              |   12 +-
 fs/ocfs2/dlm/dlmdomain.c             |  400 +++++++++++++++++++++++++-
 fs/ocfs2/dlmglue.c                   |    8 +
 fs/ocfs2/file.c                      |   73 +++--
 fs/ocfs2/inode.c                     |    1 +
 fs/ocfs2/inode.h                     |   12 +-
 fs/ocfs2/ioctl.c                     |  356 +++++++++++++++++++++++
 fs/ocfs2/journal.c                   |    9 +-
 fs/ocfs2/journal.h                   |    3 +-
 fs/ocfs2/mmap.c                      |    7 +-
 fs/ocfs2/namei.c                     |    3 +-
 fs/ocfs2/ocfs2.h                     |   63 ++++-
 fs/ocfs2/ocfs2_fs.h                  |   46 +++-
 fs/ocfs2/ocfs2_ioctl.h               |   95 ++++++
 fs/ocfs2/refcounttree.c              |   43 +++-
 fs/ocfs2/refcounttree.h              |    7 +-
 fs/ocfs2/slot_map.c                  |    2 +-
 fs/ocfs2/stack_o2cb.c                |    2 +
 fs/ocfs2/suballoc.c                  |   16 +
 fs/ocfs2/super.c                     |  163 +++++++++--
 fs/ocfs2/sysfile.c                   |   60 +++-
 fs/ocfs2/xattr.c                     |    2 +-
 include/linux/fs.h                   |    2 +
 39 files changed, 1894 insertions(+), 173 deletions(-)
