From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 26 May 2017 08:21:00 +0000
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io. review
References: <E3535A62B291B54FBD1D003696CCB53792E30014@H3CMLB12-EX.srv.huawei-3com.com>,
	<E3535A62B291B54FBD1D003696CCB53792E30049@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB53792E309AA@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170526/4c63b20e/attachment.html 
