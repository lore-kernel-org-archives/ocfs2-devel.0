From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 May 2010 11:59:19 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: Block signals for file creation
Message-ID: <20100510185919.GC25670@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

File creation is not idempotent.  Signal interruption can cause a
restart of the operations, but once we have started we cannot safely do
so.  The two patches of this series make the operations signal-safe.

Joel

 inode.c |   14 +++-----------
 mmap.c  |   48 +++++++++---------------------------------------
 namei.c |   21 +++++++++++++++++++++
 super.c |   20 ++++++++++++++++++++
 super.h |    7 +++++++
 5 files changed, 60 insertions(+), 50 deletions(-)

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
