From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 3 Apr 2009 11:46:05 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 updates for 2.6.30
Message-ID: <20090403184605.GC14571@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Hi Linus,

	Here is the Ocfs2 changes for this merge window. I sent all these
patches out to the list a couple weeks ago. Original mail is attached.


Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c               |   57 +
 fs/ocfs2/alloc.h               |    3 +
 fs/ocfs2/aops.c                |   23 +-
 fs/ocfs2/cluster/heartbeat.c   |   96 ++-
 fs/ocfs2/cluster/heartbeat.h   |    3 +-
 fs/ocfs2/cluster/nodemanager.c |    9 +-
 fs/ocfs2/dir.c                 | 2806 ++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/dir.h                 |   57 +-
 fs/ocfs2/dlm/dlmcommon.h       |   58 +-
 fs/ocfs2/dlm/dlmdebug.c        |   87 +-
 fs/ocfs2/dlm/dlmdomain.c       |   29 +-
 fs/ocfs2/dlm/dlmmaster.c       |  387 +++---
 fs/ocfs2/dlm/dlmthread.c       |   20 +-
 fs/ocfs2/dlmglue.c             |   46 +
 fs/ocfs2/dlmglue.h             |    2 +
 fs/ocfs2/export.c              |   84 ++-
 fs/ocfs2/inode.c               |   48 +-
 fs/ocfs2/inode.h               |    5 +
 fs/ocfs2/journal.c             |  173 +++-
 fs/ocfs2/journal.h             |   77 +-
 fs/ocfs2/localalloc.c          |   86 --
 fs/ocfs2/namei.c               |  250 ++--
 fs/ocfs2/ocfs2.h               |   76 +-
 fs/ocfs2/ocfs2_fs.h            |  136 ++-
 fs/ocfs2/ocfs2_lockid.h        |    4 +
 fs/ocfs2/suballoc.c            |  254 ++++-
 fs/ocfs2/suballoc.h            |    4 +
 fs/ocfs2/super.c               |  188 +++
 fs/ocfs2/xattr.c               |    8 +-
 fs/ocfs2/xattr.h               |    2 +-
 30 files changed, 4389 insertions(+), 689 deletions(-)

Hisashi Hifumi (1):
      ocfs2: Pagecache usage optimization on ocfs2

Mark Fasheh (9):
      ocfs2: Introduce dir lookup helper struct
      ocfs2: Add a name indexed b-tree to directory inodes
      ocfs2: Store dir index records inline
      ocfs2: Introduce dir free space list
      ocfs2: Increase max links count
      ocfs2: Add total entry count to dx_root_block
      ocfs2: Enable indexed directories
      ocfs2: re-order ocfs2_empty_dir checks
      ocfs2: fix leaf start calculation in ocfs2_dx_dir_rebalance()

Srinivas Eeda (1):
      ocfs2: recover orphans in offline slots during recovery and mount

Sunil Mushran (17):
      ocfs2/hb: Expose the list of heartbeating nodes via debugfs
      ocfs2: Move struct recovery_map to a header file
      ocfs2: Expose the file system state via debugfs
      ocfs2: Remove debugfs file local_alloc_stats
      ocfs2/dlm: Encapsulate adding and removing of mle from dlm->master_list
      ocfs2/dlm: Clean up struct dlm_lock_name
      ocfs2/dlm: Refactor dlm_clean_master_list()
      ocfs2/dlm: Create and destroy the dlm->master_hash
      ocfs2/dlm: Activate dlm->master_hash for master list entries
      ocfs2/dlm: Indent dlm_cleanup_master_list()
      ocfs2/dlm: Track number of mles
      ocfs2/dlm: Improve lockres counts
      ocfs2/dlm: dlm_set_lockres_owner() and dlm_change_lockres_owner() inlined
      ocfs2/dlm: Show the number of lockres/mles in dlm_state
      ocfs2/dlm: Remove struct dlm_lock_name in struct dlm_master_list_entry
      ocfs2/dlm: Do not purge lockres that is being migrated dlm_purge_lockres()
      ocfs2/dlm: Tweak mle_state output

Tao Ma (3):
      ocfs2: Optimize inode allocation by remembering last group
      ocfs2: Allocate inode groups from global_bitmap.
      ocfs2: Optimize inode group allocation by recording last used group.

wengang wang (1):
      ocfs2: fix rare stale inode errors when exporting via nfs


Hi,

	The following patches comprise the bulk of Ocfs2 updates for the
2.6.30 merge window. Aside from larger, more involved fixes, we're adding
the following features, which I will describe in the order their patches are
mailed.

	Sunil's exported some more state to our debugfs files, and
consolidated some other aspects of our debugfs infrastructure. This will
further aid us in debugging Ocfs2 issues.

	By leveraging our very flexible b-tree code, I was able to add
support for directory indexing. Indexed directories in Ocfs2 look like
regular directories, except they have an additional btree with records
indexed by name hash. This design means we get to keep the existing
POSIX-ness of our directory code, but operations like lookup get the
increased performance of a simple btree lookup.

	Tao's contribution this cycle comes in the form of inode allocation
optimizations. These involved the usual heuristics - try to allocate inodes
close to their parent directory, remember which allocation group was
previously visited, etc. The resulting code yielded a 10x improvement on
some cold-cache stat workloads.

	Finally, Sunil has turned the fs/ocfs2/dlm mastery list into a hash
table. This fixes some performance issues we had seen on large clusters with
very active mastery (typically, lots of unlinks, renames and creates).
	--Mark

--
Mark Fasheh
