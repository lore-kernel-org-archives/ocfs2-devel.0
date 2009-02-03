From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 3 Feb 2009 13:24:22 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs fixes
Message-ID: <20090203212422.GT17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/configfs/dir.c       |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.c        |    3 ++
 fs/ocfs2/dcache.c       |   42 +++++++++++++++++++++++++++++++--
 fs/ocfs2/dcache.h       |    9 ++++++-
 fs/ocfs2/dlmglue.c      |    4 +++
 fs/ocfs2/ocfs2.h        |    6 ++++
 fs/ocfs2/quota_global.c |    4 ++-
 fs/ocfs2/super.c        |    3 ++
 fs/ocfs2/xattr.c        |   17 ++++++-------
 9 files changed, 133 insertions(+), 14 deletions(-)

Jan Kara (2):
      ocfs2: Push out dropping of dentry lock to ocfs2_wq
      ocfs2: Fix possible deadlock in ocfs2_write_dquot()

Joel Becker (1):
      configfs: Silence lockdep on mkdir(), rmdir() and configfs_depend_item()

Mark Fasheh (1):
      ocfs2: add quota call to ocfs2_remove_btree_range()

Sunil Mushran (1):
      ocfs2: Wakeup the downconvert thread after a successful cancel convert

Tao Ma (1):
      ocfs2: Access the xattr bucket only before modifying it.

--
Mark Fasheh
