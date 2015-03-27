From: Joe Perches <joe@perches.com>
Date: Thu, 26 Mar 2015 20:07:06 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: logging neatening
Message-ID: <cover.1427425496.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Cc: Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org

Joe Perches (2):
  ocfs2: Logging: Remove static buffer, use vsprintf extension %pV
  ocfs2: Neaten do_error, ocfs2_error and ocfs2_abort

 fs/ocfs2/alloc.c        | 90 +++++++++++++++++++------------------------------
 fs/ocfs2/aops.c         |  4 +--
 fs/ocfs2/dir.c          | 49 +++++++++++++--------------
 fs/ocfs2/extent_map.c   | 22 ++++++------
 fs/ocfs2/inode.c        | 18 +++++-----
 fs/ocfs2/journal.c      |  2 +-
 fs/ocfs2/localalloc.c   |  3 +-
 fs/ocfs2/move_extents.c |  5 ++-
 fs/ocfs2/quota_local.c  |  3 +-
 fs/ocfs2/refcounttree.c | 53 +++++++++++++----------------
 fs/ocfs2/suballoc.c     | 75 +++++++++++++++++++----------------------
 fs/ocfs2/super.c        | 34 ++++++++++---------
 fs/ocfs2/super.h        |  6 ++--
 fs/ocfs2/xattr.c        | 35 +++++++++----------
 14 files changed, 182 insertions(+), 217 deletions(-)

-- 
2.1.2
