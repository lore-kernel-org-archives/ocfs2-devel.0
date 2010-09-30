From: Joel Becker <boel.becker@oracle.com>
Date: Wed, 29 Sep 2010 19:07:51 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 symlink walk fix
Message-ID: <20100930020749.GD23107@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus, et al,
	We've discovered that ocfs2 can walk off the end reading a fast
symlink if the NUL got corrupted on disk.  It's a simple
strlen()->strnlen() fix, but I think it should go sooner rather than
later.
	Please pull.

Joel

The following changes since commit 4193d9163582b05e33aca3392e46649e5c3da8d1:

  Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs (2010-09-29 14:58:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

 fs/ocfs2/symlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
