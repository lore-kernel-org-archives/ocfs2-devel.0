From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 24 Aug 2009 14:34:30 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 2.6.31-rc7
Message-ID: <20090824213430.GD7698@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here are a couple small ocfs2 fixes for 2.6.31.  They fix
user-visible bugs, so I wanted to make sure they were in this cycle.
	Please pull.

Joel

The following changes since commit b409d7a0ab46fe530efe52734984b4ed5d46c3eb:
  Jan Kara (1):
        ocfs2: Fix possible deadlock when extending quota file

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Goldwyn Rodrigues (1):
      ocfs2/dlm: Wait on lockres instead of erroring cancel requests

Jan Kara (3):
      ocfs2: Handle quota file corruption more gracefully
      ocfs2: Don't oops in ocfs2_kill_sb on a failed mount
      ocfs2: Add missing lock name

Tao Ma (1):
      ocfs2: release the buffer head in ocfs2_do_truncate.

 fs/ocfs2/alloc.c         |    2 +-
 fs/ocfs2/dlm/dlmunlock.c |    4 ++--
 fs/ocfs2/ocfs2_lockid.h  |    1 +
 fs/ocfs2/quota_global.c  |   10 ++++++++++
 fs/ocfs2/super.c         |    6 +++++-
 5 files changed, 19 insertions(+), 4 deletions(-)
-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
