From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 2 Sep 2014 17:03:27 +0800
Subject: [Ocfs2-devel] [PATCH] fs/super.c: do not shrink fs slab during
 direct memory reclaim
In-Reply-To: <20140901235102.GI26465@dastard>
References: <54004E82.3060608@huawei.com> <20140901235102.GI26465@dastard>
Message-ID: <540587DF.6040302@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, Junxiao Bi <junxiao.bi@oracle.com>

Hi, Dave
On 2014/9/2 7:51, Dave Chinner wrote:
> On Fri, Aug 29, 2014 at 05:57:22PM +0800, Xue jiufei wrote:
>> The patch trys to solve one deadlock problem caused by cluster
>> fs, like ocfs2. And the problem may happen at least in the below
>> situations:
>> 1)Receiving a connect message from other nodes, node queues a
>> work_struct o2net_listen_work.
>> 2)o2net_wq processes this work and calls sock_alloc() to allocate
>> memory for a new socket.
>> 3)It would do direct memory reclaim when available memory is not
>> enough and trigger the inode cleanup. That inode being cleaned up
>> is happened to be ocfs2 inode, so call evict()->ocfs2_evict_inode()
>> ->ocfs2_drop_lock()->dlmunlock()->o2net_send_message_vec(),
>> and wait for the unlock response from master.
>> 4)tcp layer received the response, call o2net_data_ready() and
>> queue sc_rx_work, waiting o2net_wq to process this work.
>> 5)o2net_wq is a single thread workqueue, it process the work one by
>> one. Right now it is still doing o2net_listen_work and cannot handle
>> sc_rx_work. so we deadlock.
>>
>> It is impossible to set GFP_NOFS for memory allocation in sock_alloc().
>> So we use PF_FSTRANS to avoid the task reentering filesystem when
>> available memory is not enough.
>>
>> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> 
> For the second time: use memalloc_noio_save/memalloc_noio_restore.
> And please put a great big comment in the code explaining why you
> need to do this special thing with memory reclaim flags.
> 
> Cheers,
> 
> Dave.
> 
Thanks for your reply. But I am afraid that memalloc_noio_save/
memalloc_noio_restore can not solve my problem. __GFP_IO is cleared
if PF_MEMALLOC_NOIO is set and can avoid doing IO in direct memory
reclaim. However, __GFP_FS is still set that can not avoid pruning
dcache and icache in memory allocation, resulting in the deadlock I
described.

Thanks.
XueJiufei
