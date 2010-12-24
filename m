From: Joel Becker <joel.becker@Oracle.COM>
Date: Thu, 23 Dec 2010 16:16:37 -0800
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 2.6.37-rc7
Message-ID: <20101224001637.GA25361@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com


Dear Linus et al,
	Here are hopefully the last remaining ocfs2 fixes for 2.6.37-rc.
The most important are a fix for the new coherency mode added in the
merge window and a regression fix for users with quota enabled.
	Please pull.

Joel

The following changes since commit b0c3844d8af6b9f3f18f31e1b0502fbefa2166be:

  Linux 2.6.37-rc6 (2010-12-15 17:24:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Sunil Mushran (2):
      ocfs2/dlm: Migrate lockres with no locks if it has a reference
      ocfs2: Adjust masklog flag values

Tao Ma (2):
      ocfs2: Hold ip_lock when set/clear flags for indexed dir.
      ocfs2: Fix system inodes cache overflow.

Tristan Ye (1):
      Ocfs2: Teach 'coherency=full' O_DIRECT writes to correctly up_read i_alloc_sem.

 fs/ocfs2/aops.c            |    7 +++++--
 fs/ocfs2/aops.h            |   23 +++++++++++++++++++++--
 fs/ocfs2/cluster/masklog.c |    3 ++-
 fs/ocfs2/cluster/masklog.h |   15 ++++++++-------
 fs/ocfs2/dir.c             |    4 ++++
 fs/ocfs2/dlm/dlmmaster.c   |   40 +++++++++++++++++++++++++++-------------
 fs/ocfs2/file.c            |   15 +++++++++++++--
 fs/ocfs2/ocfs2_fs.h        |    2 +-
 8 files changed, 81 insertions(+), 28 deletions(-)
