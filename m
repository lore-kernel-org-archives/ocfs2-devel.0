From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 2 Jun 2017 09:40:14 +0000
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io. review
References: <E3535A62B291B54FBD1D003696CCB53792E30014@H3CMLB12-EX.srv.huawei-3com.com>,
	<E3535A62B291B54FBD1D003696CCB53792E30049@H3CMLB12-EX.srv.huawei-3com.com>,
	<E3535A62B291B54FBD1D003696CCB53792E309AA@H3CMLB12-EX.srv.huawei-3com.com>,
	<E3535A62B291B54FBD1D003696CCB53792E319BE@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB53792E39DBF@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi
    Please take a look at this issue.
    BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))  in ocfs2_get_clusters_nocache
    has been triggered, so  i think ip_alloc_sem is still needed.
    the crash have been detailed.

crash> bt
PID: 1558 TASK: ffff88001245e4a0 CPU: 0 COMMAND: "dd"
#0 [ffff8800077df410] machine_kexec at ffffffff8105b311
#1 [ffff8800077df480] crash_kexec at ffffffff8110c358
#2 [ffff8800077df550] oops_end at ffffffff8101a7a8
#3 [ffff8800077df580] die at ffffffff8101ae28
#4 [ffff8800077df5b0] do_trap at ffffffff8101732d
#5 [ffff8800077df610] do_error_trap at ffffffff81017663
#6 [ffff8800077df6d0] do_error_trap at ffffffff81017714
#7 [ffff8800077df710] do_invalid_op at ffffffff81017f60
#8 [ffff8800077df720] invalid_op at ffffffff817f9afe
[exception RIP: ocfs2_get_clusters_nocache+1538]
RIP: ffffffffc08353d2 RSP: ffff8800077df7d8 RFLAGS: 00010297
RAX: 0000000000000081 RBX: ffff8800483c7130 RCX: 0000000000000000
RDX: ffff88007c611f78 RSI: ffff88007c60e708 RDI: ffff88007c60e708
RBP: ffff8800077df888 R8: 0000000000000007 R9: 0000000000000367
R10: 0000000000000006 R11: 0000000000000006 R12: ffff8800077df8b8
R13: ffff8800483c70c0 R14: 0000000000000000 R15: ffff8800483c7000
ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
#9 [ffff8800077df890] ocfs2_get_clusters at ffffffffc0835a0b [ocfs2]
#10 [ffff8800077df910] ocfs2_extent_map_get_blocks at ffffffffc0835bca [ocfs2]
#11 [ffff8800077df980] ocfs2_get_block at ffffffffc081834c [ocfs2]
#12 [ffff8800077dfa40] do_blockdev_direct_IO at ffffffff8123fabc
#13 [ffff8800077dfc80] __blockdev_direct_IO at ffffffff81240c83
#14 [ffff8800077dfcb0] ocfs2_direct_IO at ffffffffc081722f [ocfs2]
#15 [ffff8800077dfce0] generic_file_read_iter at ffffffff8118ba1a
#16 [ffff8800077dfdb0] ocfs2_file_read_iter at ffffffffc083887a [ocfs2]
#17 [ffff8800077dfe50] __vfs_read at ffffffff8120263b
#18 [ffff8800077dfed0] vfs_read at ffffffff812039d5
#19 [ffff8800077dff10] sys_read at ffffffff81203abf
#20 [ffff8800077dff50] system_call_fastpath at ffffffff817f81b2
RIP: 00007f49c8af0f30 RSP: 00007ffcb7b343e8 RFLAGS: 00000246
RAX: ffffffffffffffda RBX: 0000000000100000 RCX: 00007f49c8af0f30
RDX: 0000000000100000 RSI: 00007f49c86ec000 RDI: 0000000000000000
RBP: 00007f49c86ec000 R8: 00000000ffffffff R9: 0000000000000000
R10: 00007ffcb7b34180 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000100000 R14: 0000000000100000 R15: 00007ffcb7b36814
ORIG_RAX: 0000000000000000 CS: 0033 SS: 002b


________________________________
All the best wishes for you.
zhangguanghui

From: zhangguanghui 10102<mailto:zhang.guanghui@h3c.com>
Date: 2017-05-27 13:54
To: ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
CC: ryan.ding<mailto:ryan.ding@oracle.com>; Andrew Morton<mailto:akpm@linux-foundation.org>; wangww631<mailto:wangww631@huawei.com>; Joel Becker<mailto:jlbec@evilplan.org>; Mark Fasheh<mailto:mfasheh@suse.com>
Subject: ocfs2: fix sparse file & data ordering issue in direct io. review
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170602/b3175bb3/attachment-0001.html 
