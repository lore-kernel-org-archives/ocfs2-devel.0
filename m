From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 20 Aug 2014 11:57:34 +0800
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient memory
Message-ID: <53F41CAE.2040204@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
We found there may exist a deadlock when system has not sufficient
memory. Here's the situation:
            N1                                      N2
                                             send message to N1
      o2net_wq(kworker)
receiving message and call corresponding
handler to handle this message. It may 
need to alloc some memory(use GFP_NOFS or GFP_KERNEL).
but there's no sufficient memory, lower then
min watermark. So it wakeup kswapd to reclaim memory
and itself may also call
__alloc_pages_direct_reclaim(), trying to
free some pages.

It tries to free ocfs2 inode
cache and calls ocfs2_drop_lock()->dlmunlock()
to drop inode lock, sending unlock message to master,
say N2. When reply comes, queue sc_rx_work and
wait o2net_wq to handle this work. however
o2net_wq is still handling last message, so can not 
process the reply message. It will wait
o2net_nsw_completed() in o2net_send_message_vec()
forever. 
Kswapd thread enconter the same situation.


So is there any advice to solve this deadlock?
And what is the probability that kmalloc return ENOMEM when use GFP_ATOMIC flag?

Thanks.
