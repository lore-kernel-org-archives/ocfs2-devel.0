From: Rob Jones <rob.jones@codethink.co.uk>
Date: Wed, 10 Sep 2014 15:49:15 +0100
Subject: [Ocfs2-devel] [PATCH 0/3] fs: ocfs2: use seq_open_private()
Message-ID: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, dan.carpenter@oracle.com, akpm@linux-foundation.org, jlbec@evilplan.org, mfasheh@suse.com, linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk

Use seq_open_private() and __seq_open_private() to reduce boilerplate
code in ocfs2.

These two functions have been around, undocumented, for years. They can
simplify the set up code for seq file operations.

Note that sparse complains about all three files in this series but the
problems are outside the remit of this patch series.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>

Rob Jones (3):
  fs: ocfs2: use seq_open_private() not seq_open()
  fs: ocfs2: use seq_open_private() not seq_open()
  fs: ocfs2: Use __seq_open_private() not seq_open()

 fs/ocfs2/cluster/netdebug.c |   78 +++++++++++--------------------------------
 fs/ocfs2/dlm/dlmdebug.c     |   39 ++++++++--------------
 fs/ocfs2/dlmglue.c          |   23 +++----------
 3 files changed, 38 insertions(+), 102 deletions(-)

-- 
1.7.10.4
