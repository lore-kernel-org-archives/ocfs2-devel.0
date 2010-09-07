From: Joel Becker <boel.becker@oracle.com>
Date: Tue, 7 Sep 2010 16:41:14 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 fixes for 2.6.36.
Message-ID: <20100907234114.GD21935@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, tao.ma@oracle.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Linus et al,
	Here are the ocfs2 fixes we have ready for pulling right now.  I
have a bit of a procedural question, though.  I've been busy, so Tao was
kind enough to take the fixes I already had and apply all the new fixes.
He coordinated testing them and getting them ready to go upstream.
That's why I have his git tree in the pull request below.
	I wasn't sure how the signoffs work for this.  He's got signoffs
on the stuff he put together, because it's coming through his tree.  My
naive assumption is that this is the correct way to go.  If you'd like
another arrangement (same branch in my tree, a merge commit somewhere to
stick my SoB on, etc), let me know.
	Otherwise, please pull.

Joel


The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:
  Linus Torvalds (1):
        Linux 2.6.36-rc3

are available in the git repository at:

  git://oss.oracle.com/git/tma/linux-2.6.git fixes

Jan Kara (2):
      ocfs2: Flush drive's caches on fdatasync
      ocfs2: Fix deadlock when allocating page

Mark Fasheh (6):
      ocfs2: properly set and use inode group alloc hint
      ocfs2: split out inode alloc code from ocfs2_mknod_locked
      ocfs2: use ocfs2_alloc_dinode_update_counts() instead of open coding
      ocfs2: allow return of new inode block location before allocation of the inode
      ocfs2: split out ocfs2_prepare_orphan_dir() into locking and prep functions
      ocfs2: Fix orphan add in ocfs2_create_inode_in_orphan

Sunil Mushran (2):
      ocfs2: Fix metaecc error messages
      ocfs2: Fix incorrect checksum validation error

Tao Ma (2):
      ocfs2: make __ocfs2_page_mkwrite handle file end properly.
      ocfs2: Use the right group in nfs sync check.

Tristan Ye (1):
      Ocfs2: Fix a regression bug from mainline commit(6b933c8e6f1a2f3118082c455eef25f9b1ac7b45).

 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/blockcheck.c   |    4 +-
 fs/ocfs2/file.c         |   15 ++-
 fs/ocfs2/inode.c        |    6 +-
 fs/ocfs2/mmap.c         |    8 +-
 fs/ocfs2/namei.c        |  302 ++++++++++++++++++++++++++++++++++++-----------
 fs/ocfs2/refcounttree.c |    5 +-
 fs/ocfs2/suballoc.c     |  219 ++++++++++++++++++++++++++++++----
 fs/ocfs2/suballoc.h     |   21 ++++
 9 files changed, 475 insertions(+), 107 deletions(-)
