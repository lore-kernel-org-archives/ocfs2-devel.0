From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 13 Mar 2009 10:14:27 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 fixes
Message-ID: <20090313171427.GL17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c    |    3 ++-
 fs/ocfs2/aops.c     |    7 +++++--
 fs/ocfs2/namei.c    |    3 ++-
 fs/ocfs2/ocfs2_fs.h |    6 ------
 fs/ocfs2/xattr.c    |   30 ++++++++++++++++++++++++------
 5 files changed, 33 insertions(+), 16 deletions(-)

Tao Ma (2):
      ocfs2: Fix a bug found by sparse check.
      ocfs2: Use xs->bucket to set xattr value outside

Tiger Yang (2):
      ocfs2: reserve xattr block for new directory with inline data
      ocfs2: tweak to get the maximum inline data size with xattr

--
Mark Fasheh
