From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Mon, 6 Jul 2015 02:29:54 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not BUG if buffer not uptodate
 in __ocfs2_journal_access
References: <5599E264.7080606@huawei.com>
Message-ID: <2015070610294906954814@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


This patch is currently verified and working well for two weeks.
So it is reasonable for the case.

Finally, any feedback about this process (positive or negative) would be greatly appreciated.
________________________________
zhangguanghui

From: Joseph Qi<mailto:joseph.qi@huawei.com>
Date: 2015-07-06 10:05
To: Andrew Morton<mailto:akpm@linux-foundation.org>
CC: Mark Fasheh<mailto:mfasheh@suse.com>; Joel Becker<mailto:jlbec@evilplan.org>; zhangguanghui 10102 (CCPL)<mailto:zhang.guanghui@h3c.com>; ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
Subject: [PATCH] ocfs2: do not BUG if buffer not uptodate in __ocfs2_journal_access

When storage network is unstable, it may trigger the BUG in
__ocfs2_journal_access because of buffer not uptodate. We can retry the
write in this case or return error instead of BUG.

Reported-by: Zhangguanghui <zhang.guanghui@h3c.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f8206d1..e731374 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -670,7 +670,23 @@ static int __ocfs2_journal_access(handle_t *handle,
                mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
                mlog(ML_ERROR, "b_blocknr=%llu\n",
                     (unsigned long long)bh->b_blocknr);
-               BUG();
+
+               lock_buffer(bh);
+               /*
+                * A previous attempt to write this buffer head failed.
+                * Nothing we can do but to retry the write and hope for
+                * the best.
+                */
+               if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
+                       clear_buffer_write_io_error(bh);
+                       set_buffer_uptodate(bh);
+               }
+
+               if (!buffer_uptodate(bh)) {
+                       unlock_buffer(bh);
+                       return -EIO;
+               }
+               unlock_buffer(bh);
        }

        /* Set the current transaction information on the ci so
--
1.8.4.3



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
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150706/5d63c9ea/attachment.html 
