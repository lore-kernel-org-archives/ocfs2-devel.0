From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 6 Jul 2012 00:44:29 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 3.5-rc5
Message-ID: <20120706074428.GA27550@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Linus et al,
	Here are the all of the ocfs2 fixes that have been stewing in my
tree.  Please pull.

Joel

The following changes since commit 9e85a6f9dc231f3ed3c1dc1b12217505d970142a:

  Merge tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mturquette/linux (2012-07-03 18:06:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

Jan Kara (1):
      ocfs2: Fix bogus error message from ocfs2_global_read_info

Jeff Liu (1):
      ocfs2: for SEEK_DATA/SEEK_HOLE, return internal error unchanged if ocfs2_get_clusters_nocache() or ocfs2_inode_lock() call failed.

Junxiao Bi (2):
      ocfs2: clear unaligned io flag when dio fails
      aio: make kiocb->private NUll in init_sync_kiocb()

Srinivas Eeda (1):
      ocfs2: use spinlock irqsave for downconvert lock.patch

roel (1):
      ocfs2: Misplaced parens in unlikley

 fs/ocfs2/dlmglue.c      |   33 ++++++++++++++++++++-------------
 fs/ocfs2/extent_map.c   |    2 --
 fs/ocfs2/file.c         |    4 +++-
 fs/ocfs2/quota_global.c |    2 --
 include/linux/aio.h     |    1 +
 5 files changed, 24 insertions(+), 18 deletions(-)
