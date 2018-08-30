From: Changwei Ge <gechangwei@live.cn>
Date: Thu, 30 Aug 2018 02:05:56 +0000
Subject: [Ocfs2-devel] [PATCH] fix dead lock caused by
	ocfs2_defrag_extent
In-Reply-To: <4265c81b-26bf-fb54-e911-59773c40f788@suse.com>
References: <20180827080121.31145-1-lchen@suse.com>
	<HK0PR06MB2561A612E5A95B60E7F8E22FD50A0@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<4265c81b-26bf-fb54-e911-59773c40f788@suse.com>
Message-ID: <HK0PR06MB2561632790BCD8DCD5936F47D5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry,

Sorry for this late reply.


On 2018/8/28 12:46, Larry Chen wrote:
> Hi Changwei,
>
> I think there might be some logic error.
>
> Imagine that we remove __ocfs2_flush_truncate_log() in
> ocfs2_defrag_extent().
>
> In ocfs2_reserve_clusters might skip freeing truncate log if there is 
> enough clusters in local. Then __ocfs2_move_extent might return error 
> because ocfs2_truncate_log_append might fail.
I think changing ocfs2 infrastructure methods like your way is not a 
good idea.
So how about this way?
->lock truncate log inode
->__ocfs2_flush_truncate_log()
->ocfs2_lock_allocators_move_extents()
->unlock truncate log inode

Thanks
Changwei

>
> Thanks,
> Larry
>
>
> On 08/28/2018 09:59 AM, Changwei Ge wrote:
>> Hi Larry,
>>
>> I'd like to propose another way to fix this issue, which might be
>> easier. :-)
>> Actually, ocfs2_reserve_clusters() inside will flush truncate log if
>> there is no enough clusters left.
>> So how about just remove __ocfs2_flush_truncate_log() in
>> ocfs2_defrag_extent()?
>>
>> Thanks,
>> Changwei
>>
>> On 2018/8/27 16:01, Larry Chen wrote:
>>> ocfs2_defrag_extent may fall into dead lock.
>>>
>>> ocfs2_ioctl_move_extents
>>> ??? ocfs2_ioctl_move_extents
>>> ????? ocfs2_move_extents
>>> ??????? ocfs2_defrag_extent
>>> ????????? ocfs2_lock_allocators_move_extents
>>>
>>> ??????????? ocfs2_reserve_clusters
>>> ????????????? inode_lock GLOBAL_BITMAP_SYSTEM_INODE
>>>
>>> ????? __ocfs2_flush_truncate_log
>>> ????????????? inode_lock GLOBAL_BITMAP_SYSTEM_INODE
>>>
>>> As back trace shows above, ocfs2_reserve_clusters will call inode_lock
>>> against the global bitmap if local allocator has not sufficient 
>>> cluters.
>>> Once global bitmap could meet the demand, ocfs2_reserve_cluster will
>>> return success with global bitmap locked.
>>>
>>> After ocfs2_reserve_cluster, if truncate log is full,
>>> __ocfs2_flush_truncate_log will definitely fall into dead lock
>>> because it needs to inode_lock global bitmap, which has
>>> already been locked.
>>>
>>> To fix this bug, we could remove from 
>>> ocfs2_lock_allocators_move_extents
>>> the code which intends to lock global allocator, and put the removed
>>> code after __ocfs2_flush_truncate_log
>>>
>>> The ocfs2_lock_allocators_move_extents has been refered by 2 places, 
>>> one
>>> is here, the other does not need the data allocator context, which 
>>> means
>>> this patch does not affect the caller so far.
>>>
>>>
>>>
>>> Signed-off-by: Larry Chen <lchen@suse.com>
>>> ---
>>> ?? fs/ocfs2/move_extents.c | 13 ++++++-------
>>> ?? 1 file changed, 6 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>>> index 7eb3b0a6347e..064dedf40d74 100644
>>> --- a/fs/ocfs2/move_extents.c
>>> +++ b/fs/ocfs2/move_extents.c
>>> @@ -192,13 +192,6 @@ static int 
>>> ocfs2_lock_allocators_move_extents(struct inode *inode,
>>> ?????????? goto out;
>>> ?????? }
>>> ?? -??? if (data_ac) {
>>> -??????? ret = ocfs2_reserve_clusters(osb, clusters_to_move, data_ac);
>>> -??????? if (ret) {
>>> -??????????? mlog_errno(ret);
>>> -??????????? goto out;
>>> -??????? }
>>> -??? }
>>> ?? ?????? *credits += ocfs2_calc_extend_credits(osb->sb, 
>>> et->et_root_el);
>>> ?? @@ -283,6 +276,12 @@ static int ocfs2_defrag_extent(struct 
>>> ocfs2_move_extents_context *context,
>>> ?????????? }
>>> ?????? }
>>> ?? +??? ret = ocfs2_reserve_clusters(osb, *len, &context->data_ac);
>>> +??? if (ret) {
>>> +??????? mlog_errno(ret);
>>> +??????? goto out_unlock_mutex;
>>> +??? }
>>> +
>>> ?????? handle = ocfs2_start_trans(osb, credits);
>>> ?????? if (IS_ERR(handle)) {
>>> ?????????? ret = PTR_ERR(handle);
>>
>
