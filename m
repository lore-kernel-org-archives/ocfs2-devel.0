From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Sat, 27 May 2017 05:54:06 +0000
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
	direct io. review
References: <E3535A62B291B54FBD1D003696CCB53792E30014@H3CMLB12-EX.srv.huawei-3com.com>,
	<E3535A62B291B54FBD1D003696CCB53792E30049@H3CMLB12-EX.srv.huawei-3com.com>,
	<E3535A62B291B54FBD1D003696CCB53792E309AA@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB53792E319BE@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

--- a/aops.c 2017-05-27 01:23:35.591274026 -0400
+++ b/aops.c 2017-05-27 01:29:44.743285821 -0400
@@ -2396,6 +2396,35 @@
return 0;
}

+/*
+ * TODO: Make this into a generic get_blocks function.
+ *
+ * In ocfs2, ip_alloc_sem is used to protect allocation changes on the node.
+ * In direct IO, we add ip_alloc_sem to protect date consistent between
+ * direct-io and ocfs2_truncate_file race (buffer io use ip_alloc_sem
+ * already). Although inode->i_mutex lock is used to avoid concurrency of
+ * above situation, i think ip_alloc_sem is still needed because protect
+ * allocation changes is significant.
+ *
+ * This function is called directly from get_more_blocks in direct-io.c.
+ *
+ * called like this: dio->get_blocks(dio->inode, fs_startblk,
+ * fs_count, map_bh, dio->rw == READ);
+ */
+static int ocfs2_dio_read_get_block(struct inode *inode, sector_t iblock,
+ struct buffer_head *bh_result, int create)
+{
+ struct ocfs2_inode_info *oi = OCFS2_I(inode);
+ int ret = 0;
+
+ down_read(&oi->ip_alloc_sem);
+ /* This is the fast path for direct-io reading. */
+ ret = ocfs2_get_block(inode, iblock, bh_result, create);
+ up_read(&oi->ip_alloc_sem);
+
+ return ret;
+}
+
static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
{
struct file *file = iocb->ki_filp;
@@ -2416,7 +2445,7 @@
return 0;

if (iov_iter_rw(iter) == READ)
- get_block = ocfs2_get_block;
+ get_block = ocfs2_dio_read_get_block;
else
get_block = ocfs2_dio_get_block;

comments and questions are, as always, welcome. Thanks

________________________________
All the best wishes for you.
zhangguanghui

From: zhangguanghui 10102 (Cloud)<mailto:zhang.guanghui@h3c.com>
Date: 2017-05-26 16:21
To: ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
CC: ryan.ding<mailto:ryan.ding@oracle.com>; Andrew Morton<mailto:akpm@linux-foundation.org>; wangww631<mailto:wangww631@huawei.com>; Joel Becker<mailto:jlbec@evilplan.org>; Mark Fasheh<mailto:mfasheh@suse.com>
Subject: Re: ocfs2: fix sparse file & data ordering issue in direct io. review

Hi

This patch replace that function ocfs2_direct_IO_get_blocks with

this function ocfs2_get_blocks  in ocfs2_direct_IO, and remove the  ip_alloc_sem.

but i think ip_alloc_sem is still needed because protect  allocation changes is very correct.

Now, BUG_ON have been tiggered  in the process of testing direct-io.

Comments and questions are, as always, welcome. Thanks


As wangww631 described

In ocfs2, ip_alloc_sem is used to protect allocation changes on the node.
In direct IO, we add ip_alloc_sem to protect date consistent between
direct-io and ocfs2_truncate_file race (buffer io use ip_alloc_sem
already).  Although inode->i_mutex lock is used to avoid concurrency of
above situation, i think ip_alloc_sem is still needed because protect
allocation changes is significant.

Other filesystem like ext4 also uses rw_semaphore to protect data
consistent between get_block-vs-truncate race by other means, So
ip_alloc_sem in ocfs2 direct io is needed.


Date: Fri, 11 Sep 2015 16:19:18 +0800
From: Ryan Ding <ryan.ding@oracle.com>
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: fix sparse file & data
        ordering        issue in direct io.
To: ocfs2-devel at oss.oracle.com
Cc: mfasheh at suse.de
Message-ID: <1441959559-29947-8-git-send-email-ryan.ding@oracle.com>

There are mainly 3 issue in the direct io code path after commit 24c40b329e03 ("ocfs2: implement ocfs2_direct_IO_write"):
  * Do not support sparse file.
  * Do not support data ordering. eg: when write to a file hole, it will alloc
    extent first. If system crashed before io finished, data will corrupt.
  * Potential risk when doing aio+dio. The -EIOCBQUEUED return value is likely
    to be ignored by ocfs2_direct_IO_write().

To resolve above problems, re-design direct io code with following ideas:
  * Use buffer io to fill in holes. And this will make better performance also.
  * Clear unwritten after direct write finished. So we can make sure meta data
    changes after data write to disk. (Unwritten extent is invisible to user,
    from user's view, meta data is not changed when allocate an unwritten
    extent.)
  * Clear ocfs2_direct_IO_write(). Do all ending work in end_io.

This patch has passed fs,dio,ltp-aiodio.part1,ltp-aiodio.part2,ltp-aiodio.part4
test cases of ltp.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>

________________________________
All the best wishes for you.
zhangguanghui
-------------------------------------------------------------------------------------------------------------------------------------
?????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from New H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170527/2318474d/attachment-0001.html 
