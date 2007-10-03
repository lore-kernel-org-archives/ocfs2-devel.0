From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Oct  3 11:20:33 2007
Subject: [Ocfs2-devel] [git patch] small ocfs2 fix
Message-ID: <20071003182028.GA30360@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

One more well tested Ocfs2 fix to get in before 2.6.24.

Thanks,
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/localalloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Sunil Mushran (1):
      ocfs2: Unlock mutex in local alloc failure case

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index de984d2..d272847 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -514,8 +514,10 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 	ac->ac_bh = osb->local_alloc_bh;
 	status = 0;
 bail:
-	if (status < 0 && local_alloc_inode)
+	if (status < 0 && local_alloc_inode) {
+		mutex_unlock(&local_alloc_inode->i_mutex);
 		iput(local_alloc_inode);
+	}
 
 	mlog_exit(status);
 	return status;
