From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 25 Aug 2014 09:50:43 +0800
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient
	memory
In-Reply-To: <53F6FFB7.1090305@huawei.com>
References: <53F41CAE.2040204@huawei.com> <53F6FFB7.1090305@huawei.com>
Message-ID: <53FA9673.20205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jiufei,

Maybe you can consider using PF_FSTRANS flag, set this flag before
allocating memory with GFP_KERNEL flag and unset after the allocation.
Checking this flag in ocfs2 when trying to free some pages during memory
direct reclaim. See an example from upstream commit
5cf02d09b50b1ee1c2d536c9cf64af5a7d433f56 (nfs: skip commit in
releasepage if we're freeing memory for fs-related reasons) .

Thanks,
Junxiao.


On 08/22/2014 04:30 PM, Xue jiufei wrote:
> On 2014/8/20 11:57, Xue jiufei wrote:
>> Hi all,
>> We found there may exist a deadlock when system has not sufficient
>> memory. Here's the situation:
>>             N1                                      N2
>>                                              send message to N1
>>       o2net_wq(kworker)
>> receiving message and call corresponding
>> handler to handle this message. It may 
>> need to alloc some memory(use GFP_NOFS or GFP_KERNEL).
>> but there's no sufficient memory, lower then
>> min watermark. So it wakeup kswapd to reclaim memory
>> and itself may also call
>> __alloc_pages_direct_reclaim(), trying to
>> free some pages.
>>
>> It tries to free ocfs2 inode
>> cache and calls ocfs2_drop_lock()->dlmunlock()
>> to drop inode lock, sending unlock message to master,
>> say N2. When reply comes, queue sc_rx_work and
>> wait o2net_wq to handle this work. however
>> o2net_wq is still handling last message, so can not 
>> process the reply message. It will wait
>> o2net_nsw_completed() in o2net_send_message_vec()
>> forever. 
>> Kswapd thread enconter the same situation.
>>
>>
>> So is there any advice to solve this deadlock?
>> And what is the probability that kmalloc return ENOMEM when use GFP_ATOMIC flag?
>>
>> Thanks.
>>
> To avoid this deadlock, we want to alloc memory with flag GFP_ATOMIC
> in all handlers and return ENOMEM to peer when failed. The peer will
> try to resend the message again, o2net_wq can handle other messages.
> However, it can not solve all problems. For example, if o2net_wq is
> processing sc_connect_work which would call sock_alloc_inode() to alloc
> socket_alloc with GFP_KERNEL flag when memory is insufficient and enter
> reclaim progress, it also trigger the deadlock. We can not change this
> alloc flag.
> We have no idea about it. Is there any better ideas. 
> Thanks very much.
> xuejiufei
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
