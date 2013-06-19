From: Younger Liu <younger.liu@huawei.com>
Date: Wed, 19 Jun 2013 12:48:26 +0800
Subject: [Ocfs2-devel] [PATCH] fs/jbd2: t_updates should increase when
 start_this_handle() failed in jbd2__journal_restart()
Message-ID: <51C1381A.2@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>

jbd2_journal_restart() would restart a handle. In this function, it
calls start_this_handle(). Before calling start_this_handle()?subtract
1 from transaction->t_updates.
If start_this_handle() succeeds, transaction->t_updates increases by 1
in it. But if start_this_handle() fails, transaction->t_updates does
not increase.
So, when commit the handle's transaction in jbd2_journal_stop(), the
assertion is false, and then trigger a bug.
The assertion is as follows:
J_ASSERT(atomic_read(&transaction->t_updates) > 0) 

Signed-off-by: Younger Liu <younger.liu@huawei.com>
---
 fs/jbd2/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 325bc01..9ddb444 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -530,6 +530,8 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 	lock_map_release(&handle->h_lockdep_map);
 	handle->h_buffer_credits = nblocks;
 	ret = start_this_handle(journal, handle, gfp_mask);
+	if (ret < 0)
+		atomic_inc(&transaction->t_updates);
 	return ret;
 }
 EXPORT_SYMBOL(jbd2__journal_restart);
-- 
1.7.9.7
