From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 11 Sep 2019 10:40:04 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: protect get_block with inode
 cluster lock
In-Reply-To: <62c3b635-74f3-1670-4ebc-b22ac84c224d@linux.alibaba.com>
References: <20190910173046.27360-1-junxiao.bi@oracle.com>
	<62c3b635-74f3-1670-4ebc-b22ac84c224d@linux.alibaba.com>
Message-ID: <46a8b1b0-5f5b-daa6-ebce-471651b4d4d6@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph & Changwei,

This is found by just reviewing source code, according the lock 
semantic, for accessing extent tree, alloc_sem and ip cluster lock 
should be acquired. ocfs2_dio_wr_get_block() had these two lock 
acquired. rw_lock can protect the tree from the write, but i am not sure 
whether there were other flow changing extent tree without rw lock held.

Thanks,

Junxiao.

On 9/10/19 7:33 PM, Changwei Ge wrote:
> Hi Junxiao,
>
>
> As _RW_ cluster lock with EX level is held by local node, is that 
> possible other node has a chance to touch the extent tree belonging to 
> the same inode?
>
>
> Thanks,
>
> Changwei
>
>
> On 2019/9/11 1:30 ??, Junxiao Bi wrote:
>> Inode cluster lock should be acquired to avoid extent
>> tree changed by other cluster nodes.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>> ? fs/ocfs2/aops.c | 6 ++++++
>> ? 1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index a4c905d6b575..5ae7253d04b0 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -127,9 +127,15 @@ static int ocfs2_lock_get_block(struct inode 
>> *inode, sector_t iblock,
>> ????? int ret = 0;
>> ????? struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> ? +??? ret = ocfs2_inode_lock(inode, NULL, 0);
>> +??? if (ret) {
>> +??????? mlog_errno(ret);
>> +??????? return ret;
>> +??? }
>> ????? down_read(&oi->ip_alloc_sem);
>> ????? ret = ocfs2_get_block(inode, iblock, bh_result, create);
>> ????? up_read(&oi->ip_alloc_sem);
>> +??? ocfs2_inode_unlock(inode, 0);
>> ? ????? return ret;
>> ? }
