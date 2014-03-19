From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 19 Mar 2014 14:10:00 -0700
Subject: [Ocfs2-devel] [patch 2/8] ocfs2: flock: drop cross-node lock when
	failed locally
Message-ID: <20140319211000.A597C31C25A@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: flock: drop cross-node lock when failed locally

ocfs2_do_flock() calls ocfs2_file_lock() to get the cross-node clock and
then call flock_lock_file_wait() to compete with local processes.  In case
flock_lock_file_wait() failed, say -ENOMEM, clean up work is not done. 
This patch adds the cleanup --drop the cross-node lock which was just
granted.

[akpm at linux-foundation.org: coding-style fixes]
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/locks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally fs/ocfs2/locks.c
--- a/fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally
+++ a/fs/ocfs2/locks.c
@@ -82,6 +82,8 @@ static int ocfs2_do_flock(struct file *f
 	}
 
 	ret = flock_lock_file_wait(file, fl);
+	if (ret)
+		ocfs2_file_unlock(file);
 
 out:
 	mutex_unlock(&fp->fp_mutex);
_
