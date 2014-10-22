From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2014 15:47:02 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove bogus test from
	ocfs2_read_locked_inode()
Message-ID: <1413985622-8637-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

'args' are always set for ocfs2_read_locked_inode() and brelse() checks
whether bh is NULL. So the test (args && bh) is unnecessary (plus the
args part is really confusing anyway). Remove it.

Coverity-id: 1128856
CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 437de7f768c6..c8b25de9efbb 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -540,8 +540,7 @@ bail:
 	if (status < 0)
 		make_bad_inode(inode);
 
-	if (args && bh)
-		brelse(bh);
+	brelse(bh);
 
 	return status;
 }
-- 
1.8.1.4
