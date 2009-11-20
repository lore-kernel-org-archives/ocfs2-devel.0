From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Nov 2009 18:47:02 -0800
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 updates for 2.6.32-rc8
Message-ID: <20091120024701.GA12968@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus et al,
	Here are a few small fixes for ocfs2.  The most important one 
fixes a crash when duplicating inline data properly.
	Please pull.

Joel

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git upstream-linus

Coly Li (1):
      ocfs2: return f_fsid info in ocfs2_statfs()

Joel Becker (1):
      ocfs2: Return -EINVAL when a device is not ocfs2.

Sunil Mushran (2):
      ocfs2: Refresh documentation
      ocfs2: Trivial cleanup of jbd compatibility layer removal

Tao Ma (2):
      ocfs2: Move ocfs2_complete_reflink to the right place.
      ocfs2: duplicate inline data properly during reflink.

 Documentation/filesystems/ocfs2.txt |    6 ++--
 fs/ocfs2/file.c                     |    3 +-
 fs/ocfs2/ocfs2.h                    |    7 +---
 fs/ocfs2/refcounttree.c             |   69 ++++++++++++++++++++++++++++++++---
 fs/ocfs2/super.c                    |   20 +++++++----
 fs/ocfs2/uptodate.c                 |    5 ---
 6 files changed, 83 insertions(+), 27 deletions(-)

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
