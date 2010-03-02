From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 2 Mar 2010 15:32:30 -0800
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.34
Message-ID: <20100302233230.GE11860@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus,
	Here are the ocfs2 changes for the 2.6.34 merge window.  There's
a cleanup of the xattr setting code (so we have one set path instead of
three), we give ocfs2_dlmfs the ability to run atop fs/dlm as well as
our internal o2dlm, and we improve metadata allocation near ENOSPC.
Also included are various sundry bug fixes and some tracing
improvements.
	Please pull.

Joel


The following changes since commit a5f28ae4df291d81d9d23066f88c55ca45e388d3:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../jlbec/ocfs2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Coly Li (1):
      ocfs2: fix warning in ocfs2_file_aio_write()

Joel Becker (26):
      ocfs2: Introduce ocfs2_xa_loc
      ocfs2: Remove xattrs via ocfs2_xa_loc
      ocfs2: Prefix the member fields of struct ocfs2_xattr_info.
      ocfs2: Add a name_len field to ocfs2_xattr_info.
      ocfs2: Wrap calculation of name+value pair size.
      ocfs2: Set the xattr name+value pair in one place
      ocfs2: Handle value tree roots in ocfs2_xa_set_inline_value()
      ocfs2: Provide ocfs2_xa_fill_value_buf() for external value processing
      ocfs2: Teach ocfs2_xa_loc how to do its own journal work
      ocfs2: Allocation in ocfs2_xa_prepare_entry(), values in ocfs2_xa_store_value()
      ocfs2: Gell into ocfs2_xa_set()
      ocfs2: Let ocfs2_xa_prepare_entry() do space checks.
      ocfs2: Set xattr block entries with ocfs2_xa_set()
      ocfs2: Set inline xattr entries with ocfs2_xa_set()
      ocfs2: Handle errors while setting external xattr values.
      ocfs2_dlmfs: Add capabilities parameter.
      ocfs2_dlmfs: Use poll() to signify BASTs.
      ocfs2_dlmfs: Move to its own directory
      ocfs2: Pass lksbs back from stackglue ast/bast functions.
      ocfs2: Attach the connection to the lksb
      ocfs2: Hang the locking proto on the cluster conn and use it in asts.
      ocfs2: Remove the ast pointers from ocfs2_stack_plugins
      ocfs2: Pass the locking protocol into ocfs2_cluster_connect().
      ocfs2_dlmfs: Don't honor truncate.  The size of a dlmfs file is LVB_LEN
      ocfs2_dlmfs: Use the stackglue.
      ocfs2_dlmfs: Enable the use of user cluster stacks.

Srinivas Eeda (1):
      dlm: allow dlm do recovery during shutdown

Sunil Mushran (3):
      ocfs2: Add current->comm in trace output
      ocfs2: Use a separate masklog for AST and BASTs
      ocfs2/userdlm: Add tracing in userdlm

Tao Ma (1):
      ocfs2: Only bug out in direct io write for reflinked extent.

Tiger Yang (1):
      ocfs2: add extent block stealing for ocfs2 v5

Tristan Ye (1):
      Ocfs2: Move ocfs2 ioctl definitions from ocfs2_fs.h to newly added ocfs2_ioctl.h

Wengang Wang (2):
      ocfs2: Clean up the checks for CoW and direct I/O.
      ocfs2: send SIGXFSZ if new filesize exceeds limit -v2

 fs/ocfs2/Makefile                  |    1 +
 fs/ocfs2/alloc.c                   |    5 +-
 fs/ocfs2/aops.c                    |    5 +-
 fs/ocfs2/cluster/masklog.c         |    1 +
 fs/ocfs2/cluster/masklog.h         |    7 +-
 fs/ocfs2/dir.c                     |    2 +-
 fs/ocfs2/dlm/Makefile              |    3 +-
 fs/ocfs2/dlm/dlmrecovery.c         |    2 +-
 fs/ocfs2/dlmfs/Makefile            |    5 +
 fs/ocfs2/{dlm => dlmfs}/dlmfs.c    |  127 ++-
 fs/ocfs2/{dlm => dlmfs}/dlmfsver.c |    0
 fs/ocfs2/{dlm => dlmfs}/dlmfsver.h |    0
 fs/ocfs2/{dlm => dlmfs}/userdlm.c  |  308 +++---
 fs/ocfs2/{dlm => dlmfs}/userdlm.h  |   16 +-
 fs/ocfs2/dlmglue.c                 |  284 +++--
 fs/ocfs2/file.c                    |   13 +-
 fs/ocfs2/ioctl.h                   |    6 +-
 fs/ocfs2/localalloc.c              |    2 +-
 fs/ocfs2/ocfs2.h                   |   32 +-
 fs/ocfs2/ocfs2_fs.h                |   57 -
 fs/ocfs2/ocfs2_ioctl.h             |   79 ++
 fs/ocfs2/ocfs2_lockingver.h        |    2 +
 fs/ocfs2/refcounttree.c            |    6 +-
 fs/ocfs2/stack_o2cb.c              |   37 +-
 fs/ocfs2/stack_user.c              |   49 +-
 fs/ocfs2/stackglue.c               |   98 +-
 fs/ocfs2/stackglue.h               |   95 +-
 fs/ocfs2/suballoc.c                |  171 +++-
 fs/ocfs2/suballoc.h                |    1 +
 fs/ocfs2/super.c                   |   10 +-
 fs/ocfs2/xattr.c                   | 2180 +++++++++++++++++++-----------------
 31 files changed, 2013 insertions(+), 1591 deletions(-)
 create mode 100644 fs/ocfs2/dlmfs/Makefile
 rename fs/ocfs2/{dlm => dlmfs}/dlmfs.c (82%)
 rename fs/ocfs2/{dlm => dlmfs}/dlmfsver.c (100%)
 rename fs/ocfs2/{dlm => dlmfs}/dlmfsver.h (100%)
 rename fs/ocfs2/{dlm => dlmfs}/userdlm.c (67%)
 rename fs/ocfs2/{dlm => dlmfs}/userdlm.h (89%)
 create mode 100644 fs/ocfs2/ocfs2_ioctl.h
