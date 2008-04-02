From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:10 -0700
Subject: [Ocfs2-devel] [PATCH 0/62] Ocfs2 updates for 2.6.26-rc1
Message-ID: <12071673121124-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

The following series of patches comprises the bulk of our outstanding
changes for Ocfs2.


Aside from the usual set of cleanups and fixes that were inappropriate for
2.6.25, there are a few highlights:


The '/sys/o2cb' directory has been moved to '/sys/fs/o2cb'. The new location
meshes better with modern sysfs layout. A symbolic link has been placed in
the old location so as to not break old versions of ocfs2-tools. New
versions of ocfs2-tools know to look in /sys/fs/o2cb. When an appropriate
amount of time has passed (decided to be two years), we can remove the link.
This change required a small patch to sysfs (entirely external to Ocfs2)
which is included here with the appropriate 'Acked-by' lines.


Inode allocation in Ocfs2 has been modified to better handle an annoying
corner case. When a node's local inode allocator fills up, it attempts to
grow the allocator by adding an inode group. This might be impossible
though, if the main file system bitmap is too full or fragmented to provide
the required space. This used to be treated as an ENOSPC condition, but with
the addition of Tao's "inode stealing" patches, the allocation code will
attempt to allocate from other node's inode allocators before throwing an
error.


Merging of unwritten extents has also undergone an incremental but
significant improvement - extents can now be merged between leaf nodes. This
ensures that the allocation btree stays as compact as possible, even if
previous write patterns had caused it to fragment. Thanks again goes to Tao
for this improvement.


Sunil has improved our ability to debug the Ocfs2 DLM by allowing us to
track DLM state via a set of debugfs files. It's now possible to get a
point-in-time view of master list entries, lock resource states and more.
Debugfs.ocfs2 has been patched to make this process even easier.


And finally, we have Joel's work to allow Ocfs2 to use userspace cluster
stacks. This series of patches is the last step in a multi-year process of
seperating the Ocfs2 file system code from the underlying cluster stack.
The file system is now cluster stack agnostic. Users can choose between
the "o2cb" stack which is comprised of the traditional Ocfs2 cluster
components (including fs/ocfs2/dlm, also referred to as "o2dlm") or the new
"user" cluster stack. The "user" cluster stack requires a userspace
component to communicate node membership information to the file system via
a misc device. In "user" cluster stack mode, Dave Teigland's dlm (fs/dlm) is
used as it already contains a cluster stack agnostic userspace API.

This all has several benefits. The most obvious is that we now get to share
code and maintenance cost with other cluster-related projects instead of
re-implementing cluster and dlm features in parallel. Additionally, Ocfs2
users can now run the cluster stack of their choice. For example, while we
anticipate that some users will want to stick with o2cb for it's simplicity
of setup and use, many will want access to some of the advanced features
(clustered volume management, hardware fencing, service failover, etc) that
are already provided by most userspace cluster stacks. These patches allow
for that sort of decision to be made.

Of course, all of this is 100% backwards compatible with old versions of
Ocfs2-tools. Users only need to download a new version of Ocfs2-tools if
they want to take advantage of the userspace cluster stack feature. An
ocfs2-tools tree with code to enable userspace cluster stacks can be found
at:

http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=stack-user

Right now, the sole stack interface implemented in the toolchain is to Red
Hat's "cluster" project. In time, we anticipate that ocfs2-tools will grow
support for other cluster stacks, including linux-ha. Our thanks go to the
folks involved in the "cluster" project. Their help and advice was
instrumental to getting this together.


Finally, my apologies for the large e-mail. There's a lot of patches here
and I wanted to make sure any interested parties had a good idea of what
they represent.
	--Mark


Git branch with these changes:

git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus


Diffstat and shortlog:

 Documentation/ABI/obsolete/o2cb            |   11 +
 Documentation/ABI/stable/o2cb              |   10 +
 Documentation/ABI/testing/sysfs-ocfs2      |   89 +++
 Documentation/feature-removal-schedule.txt |   10 +
 MAINTAINERS                                |    1 +
 fs/Kconfig                                 |   26 +
 fs/ocfs2/Makefile                          |   14 +-
 fs/ocfs2/alloc.c                           |  465 +++++++++++++--
 fs/ocfs2/aops.c                            |    6 +-
 fs/ocfs2/cluster/sys.c                     |    9 +
 fs/ocfs2/cluster/tcp.c                     |   96 ++--
 fs/ocfs2/cluster/tcp_internal.h            |    2 +
 fs/ocfs2/dlm/dlmcommon.h                   |   49 ++
 fs/ocfs2/dlm/dlmdebug.c                    |  911 +++++++++++++++++++++++++---
 fs/ocfs2/dlm/dlmdebug.h                    |   86 +++
 fs/ocfs2/dlm/dlmdomain.c                   |   70 ++-
 fs/ocfs2/dlm/dlmlock.c                     |   22 +-
 fs/ocfs2/dlm/dlmmaster.c                   |  200 ++-----
 fs/ocfs2/dlmglue.c                         |  645 ++++++++++++--------
 fs/ocfs2/dlmglue.h                         |    5 +-
 fs/ocfs2/file.c                            |    4 +-
 fs/ocfs2/heartbeat.c                       |  184 +------
 fs/ocfs2/heartbeat.h                       |   17 +-
 fs/ocfs2/ioctl.c                           |   13 +-
 fs/ocfs2/ioctl.h                           |    3 +-
 fs/ocfs2/journal.c                         |  211 ++++++-
 fs/ocfs2/journal.h                         |    4 +
 fs/ocfs2/localalloc.c                      |    4 +
 fs/ocfs2/namei.c                           |    4 +-
 fs/ocfs2/ocfs2.h                           |   77 ++-
 fs/ocfs2/ocfs2_fs.h                        |   79 +++-
 fs/ocfs2/ocfs2_lockid.h                    |    2 +-
 fs/ocfs2/slot_map.c                        |  454 +++++++++++---
 fs/ocfs2/slot_map.h                        |   32 +-
 fs/ocfs2/stack_o2cb.c                      |  420 +++++++++++++
 fs/ocfs2/stack_user.c                      |  883 +++++++++++++++++++++++++++
 fs/ocfs2/stackglue.c                       |  568 +++++++++++++++++
 fs/ocfs2/stackglue.h                       |  261 ++++++++
 fs/ocfs2/suballoc.c                        |  103 +++-
 fs/ocfs2/suballoc.h                        |    1 +
 fs/ocfs2/super.c                           |  208 ++++---
 fs/sysfs/symlink.c                         |    9 +-
 42 files changed, 5230 insertions(+), 1038 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/o2cb
 create mode 100644 Documentation/ABI/stable/o2cb
 create mode 100644 Documentation/ABI/testing/sysfs-ocfs2
 create mode 100644 fs/ocfs2/dlm/dlmdebug.h
 create mode 100644 fs/ocfs2/stack_o2cb.c
 create mode 100644 fs/ocfs2/stack_user.c
 create mode 100644 fs/ocfs2/stackglue.c
 create mode 100644 fs/ocfs2/stackglue.h

Andi Kleen (1):
      ocfs2: Convert ocfs2 over to unlocked_ioctl

David Teigland (2):
      ocfs2: handle async EAGAIN from NOQUEUE request
      ocfs2: add fsdlm to stackglue

Jan Kara (1):
      ocfs2: Improve rename locking

Jeff Mahoney (1):
      ocfs2/cluster: Get rid of arguments to the timeout routines

Joel Becker (33):
      ocfs2: Make ocfs2_slot_info private.
      ocfs2: Change the recovery map to an array of node numbers.
      ocfs2: slot_map I/O based on max_slots.
      ocfs2: De-magic the in-memory slot map.
      ocfs2: Define the contents of the slot_map file.
      ocfs2: New slot map format
      ocfs2: Separate out dlm lock functions.
      ocfs2: Use global DLM_ constants in generic code.
      ocfs2: Use -errno instead of dlm_status for ocfs2_dlm_lock/unlock() API.
      ocfs2: Create the lock status block union.
      ocfs2: Introduce the new ocfs2_cluster_connect/disconnect() API.
      ocfs2: Abstract out node number queries.
      ocfs2: Move o2hb functionality into the stack glue.
      ocfs2: Remove CANCELGRANT from the view of dlmglue.
      ocfs2: Abstract out a debugging function for underlying dlms.
      ocfs2: Clean up stackglue initialization
      ocfs2: Split o2cb code from generic stack functions.
      ocfs2: Create ocfs2_stack_operations and split out the o2cb stack.
      ocfs2: Break out stackglue into modules.
      ocfs2: Create stack glue sysfs files.
      ocfs2: Add the USERSPACE_STACK incompat bit.
      ocfs2: Add the 'cluster_stack' sysfs file.
      ocfs2: Add the user stack module.
      ocfs2: Add the ocfs2_control misc device.
      ocfs2: Start the ocfs2_control handshake.
      ocfs2: Introduce the DOWN message to ocfs2_control
      ocfs2: Add the local node id to the handshake.
      ocfs2: Add the 'set version' message to the ocfs2_control device.
      ocfs2: Change mlog_bug_on to BUG_ON in ocfs2_lockid.h
      ocfs2: Add kbuild for ocfs2_stack_user.ko
      ocfs2: Allow selection of cluster plug-ins.
      ocfs2: Document /sys/fs/ocfs2
      ocfs2: Put tree in MAINTAINERS

Julia Lawall (2):
      fs/ocfs2/aops.c: test for IS_ERR rather than 0
      ocfs2: Use BUG_ON

Mark Fasheh (4):
      ocfs2: Move slot map access into slot_map.c
      ocfs2: Fill node number during cluster stack init
      sysfs: Allow removal of symlinks in the sysfs root
      ocfs2: Move /sys/o2cb to /sys/fs/o2cb

Sunil Mushran (12):
      ocfs2/dlm: Rename slabcache dlm_mle_cache to o2dlm_mle
      ocfs2/dlm: Create slabcaches for lock and lockres
      ocfs2/dlm: Link all lockres' to a tracking list
      ocfs2/dlm: Create debugfs dirs
      ocfs2/dlm: Dump the dlm state in a debugfs file
      ocfs2/dlm: Dumps the lockres' into a debugfs file
      ocfs2/dlm: Move struct dlm_master_list_entry to dlmcommon.h
      ocfs2/dlm: Dumps the mles into a debugfs file
      ocfs2/dlm: Dumps the purgelist into a debugfs file
      ocfs2/dlm: Move dlm_print_one_mle() from dlmmaster.c to dlmdebug.c
      ocfs2/dlm: Fix lockname in lockres print function
      ocfs2/dlm: Cleanup lockres print

Tao Ma (6):
      ocfs2:  Reconnect after idle time out.
      ocfs2: Add support for cross extent block
      ocfs2: Enable cross extent block merge.
      ocfs2: Add a new parameter for ocfs2_reserve_suballoc_bits
      ocfs2: Add ac_alloc_slot in ocfs2_alloc_context
      ocfs2: Add inode stealing for ocfs2_reserve_new_inode
