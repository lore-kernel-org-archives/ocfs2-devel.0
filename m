From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Jun 2008 22:48:53 -0700
Subject: [Ocfs2-devel] [GIT PULL] Please pull trivial changes
Message-ID: <20080613054853.GG20581@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,
	Please pull:

    git://oss.oracle.com/git/jlbec/linux-2.6.git trivial

for a couple trivial ocfs2 fixes.  See them at:

    http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=trivial

Joel Becker (2):
      ocfs2: Fix CONFIG_OCFS2_DEBUG_FS #ifdefs
      ocfs2: Don't snprintf() without a format.

 fs/ocfs2/journal.c    |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 fs/ocfs2/ocfs2_fs.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 

Life's Little Instruction Book #313

	"Never underestimate the power of love."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
