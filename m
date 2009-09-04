From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 4 Sep 2009 16:06:34 -0700
Subject: [Ocfs2-devel] [GIT PULL] Critical ocfs2 fixes for 2.6.31-rc8
Message-ID: <20090904230633.GB945@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	Here are two important ocfs2 fixes for 2.6.31.  One is
absolutely critical, if fixes an mmap bug introduced by the fix in
commit e7432675f8ca868a4af365759a8d4c3779a3d922.
	Please pull.

Joel

The following changes since commit c795b33ba171e41563ab7e25105c0cd4edd81cd7:
  Goldwyn Rodrigues (1):
        ocfs2/dlm: Wait on lockres instead of erroring cancel requests

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Sunil Mushran (1):
      ocfs2: ocfs2_write_begin_nolock() should handle len=0

Tao Ma (1):
      ocfs2: invalidate dentry if its dentry_lock isn't initialized.

 fs/ocfs2/aops.c   |    4 ++--
 fs/ocfs2/dcache.c |   11 +++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)
-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
