From: Joel Becker <boel.becker@oracle.com>
Date: Thu, 12 Aug 2010 15:26:22 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.36, part 1.
Message-ID: <20100812222622.GB22777@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus et al,
	Here is the first batch of ocfs2 changes for 2.6.36.  I
apologize for the LSF delay.  These fixes have been stewing for a while
and I wanted to get them to you.  The remaining batch of changes are
waiting on procedural agreement from the jbd2 folks.  I'll send them
along as soon as we have consensus.
	Please pull.

Joel


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

Jiaju Zhang (1):
      Fix the nested PR lock calling issue in ACL

Srinivas Eeda (1):
      ocfs2 fix o2dlm dlm run purgelist (rev 3)

Tao Ma (1):
      ocfs2: Count more refcount records in file system fragmentation.

Tiger Yang (1):
      ocfs2: do not overwrite error codes in ocfs2_init_acl

Tristan Ye (1):
      O2net: Disallow o2net accept connection request from itself.

Wengang Wang (3):
      ocfs2/dlm: fix a dead lock
      ocfs2/dlm: avoid incorrect bit set in refmap on recovery master
      ocfs2/dlm: remove potential deadlock -V3

 fs/ocfs2/acl.c             |   33 +++++++++++--
 fs/ocfs2/cluster/tcp.c     |   17 +++++--
 fs/ocfs2/dlm/dlmmaster.c   |    9 +---
 fs/ocfs2/dlm/dlmrecovery.c |   22 ++++-----
 fs/ocfs2/dlm/dlmthread.c   |  114 +++++++++++++++++++++-----------------------
 fs/ocfs2/refcounttree.c    |   20 ++++++--
 6 files changed, 122 insertions(+), 93 deletions(-)
