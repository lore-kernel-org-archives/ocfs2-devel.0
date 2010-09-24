From: Joel Becker <boel.becker@oracle.com>
Date: Fri, 24 Sep 2010 14:04:16 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 2.6.36, part 2.
Message-ID: <20100924210416.GA6359@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here is the second batch of ocfs2 fixes for this cycle.  It's
all small stuff.
	Please pull.

Joel


The following changes since commit 152831be91dfe864e06c3b3ff2bf994e04df4cdf:

  Merge master.kernel.org:/home/rmk/linux-2.6-arm (2010-09-09 18:31:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Srinivas Eeda (1):
      o2dlm: force free mles during dlm exit

Tao Ma (6):
      ocfs2/lockdep: Move ip_xattr_sem out of ocfs2_xattr_get_nolock.
      ocfs2: Fix lockdep warning in reflink.
      ocfs2: update ctime when changing the file's permission by setfacl
      ocfs2: Use cpu_to_le16 for e_leaf_clusters in ocfs2_bg_discontig_add_extent.
      ocfs2: Move 'wanted' into parens of ocfs2_resmap_resv_bits.
      ocfs2: Sync inode flags with ext2.

Tristan Ye (2):
      Ocfs2: Re-access the journal after ocfs2_insert_extent() in dxdir codes.
      Ocfs2: Handle empty list in lockres_seq_start() for dlmdebug.c

Wu Fengguang (1):
      ocfs2/net: fix uninitialized ret in o2net_send_message_vec()

 fs/ocfs2/acl.c           |    3 +++
 fs/ocfs2/cluster/tcp.c   |    2 +-
 fs/ocfs2/dir.c           |   24 ++++++++++++++++--------
 fs/ocfs2/dlm/dlmcommon.h |    1 +
 fs/ocfs2/dlm/dlmdebug.c  |    9 ++++++++-
 fs/ocfs2/dlm/dlmdomain.c |    1 +
 fs/ocfs2/dlm/dlmmaster.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h       |    1 +
 fs/ocfs2/ocfs2_fs.h      |   37 +++++++++++++++++++++++++------------
 fs/ocfs2/ocfs2_ioctl.h   |    8 ++++----
 fs/ocfs2/refcounttree.c  |    5 +++--
 fs/ocfs2/reservations.c  |   22 ++++++++++------------
 fs/ocfs2/suballoc.c      |    4 ++--
 fs/ocfs2/xattr.c         |    4 ++--
 14 files changed, 117 insertions(+), 44 deletions(-)
