From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 13 Jan 2017 02:52:57 +0000
Subject: [Ocfs2-devel] [PATCH v3] ocfs2/journal: fix umount hang after
 flushing journal failure
Message-ID: <63ADC13FD55D6546B7DECE290D39E37342E74EAD@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, Joseph Qi <jiangqi903@gmail.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Joseph,

Do you think my last version of patch to fix umount hang after journal
flushing failure is OK?

If so, I 'd like to ask Andrew's help to merge this patch into his test
tree.


Thanks,

Br.

Changwei



From 686b52ee2f06395c53e36e2c7515c276dc7541fb Mon Sep 17 00:00:00 2001
From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 11 Jan 2017 09:05:35 +0800
Subject: [PATCH] fix umount hang after journal flushing failure

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/journal.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a244f14..5f3c862 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2315,6 +2315,24 @@ static int ocfs2_commit_thread(void *arg)
                             "commit_thread: %u transactions pending on "
                             "shutdown\n",
                             atomic_read(&journal->j_num_trans));
+
+                       if (status < 0) {
+                               mlog(ML_ERROR, "journal is already abort
and cannot be "
+                                        "flushed any more. So ignore
the pending "
+                                        "transactions to avoid blocking
ocfs2 unmount.\n");
+                               /*
+                                * This may a litte hacky, however, no
chance
+                                * for ocfs2/journal to decrease this
variable
+                                * thourgh commit-thread. I have to do so to
+                                * avoid umount hang after journal flushing
+                                * failure. Since jounral has been
marked ABORT
+                                * within jbd2_journal_flush, commit
cache will
+                                * never do any real work to flush
journal to
+                                * disk.Set it to ZERO so that umount will
+                                * continue during shutting down journal
+                                */
+                               atomic_set(&journal->j_num_trans, 0);
+                       }
                }
        }

--
1.7.9.5

-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
