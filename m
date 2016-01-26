From: xuejiufei <xuejiufei@huawei.com>
Date: Tue, 26 Jan 2016 09:43:57 +0800
Subject: [Ocfs2-devel] ocfs2: A race between refmap setting and clearing
In-Reply-To: <56A08A05.5020002@oracle.com>
References: <56931785.2090603@huawei.com> <56A08A05.5020002@oracle.com>
Message-ID: <56A6CF5D.4090804@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2016/1/21 15:34, Junxiao Bi wrote:
> Hi Jiufei,
> 
> I didn't find other solution for this issue. You can go with yours.
> Looks like your second one is more straightforward, there deref work can
> be removed.
> 
There are two problems with the second solution:
1) Node retry to deref the lock resource will block dlm_thread to process
other lock resources.
2) When node retries to drop the refmap bit, the master may be in another
assert master work, that will take a long time to purge a lockres.
So I prefer the first solution.

Thanks,
Jiufei

> Thanks,
> Junxiao.
> On 01/11/2016 10:46 AM, xuejiufei wrote:
>> Hi all,
>> We have found a race between refmap setting and clearing which
>> will cause the lock resource on master is freed before other nodes
>> purge it.
>>
>> Node 1                               Node 2(master)
>> dlm_do_master_request
>>                                 dlm_master_request_handler
>>                                 -> dlm_lockres_set_refmap_bit
>> call dlm_purge_lockres after unlock
>>                                 dlm_deref_handler
>>                                 -> find lock resource is in
>>                                    DLM_LOCK_RES_SETREF_INPROG state,
>>                                    so dispatch a deref work
>> dlm_purge_lockres succeed.
>>
>> dlm_do_master_request
>>                                 dlm_master_request_handler
>>                                 -> dlm_lockres_set_refmap_bit
>>
>>                                 deref work trigger, call
>>                                 dlm_lockres_clear_refmap_bit
>>                                 to clear Node 1 from refmap
>>
>> Now Node 2 can purge the lock resource but the owner of lock resource
>> on Node 1 is still Node 2 which may trigger BUG if the lock resource
>> is $RECOVERY or other problems.
>>
>> We have discussed 2 solutions:
>> 1)The master return error to Node 1 if the DLM_LOCK_RES_SETREF_INPROG
>> is set. Node 1 will not retry and master send another message to Node 1
>> after clearing the refmap. Node 1 can purge the lock resource after the
>> refmap on master is cleared.
>> 2) The master return error to Node 1 if the DLM_LOCK_RES_SETREF_INPROG
>> is set, and Node 1 will retry to deref the lockres.
>>
>> Does anybody has better ideas?
>>
>> Thanks,
>> --Jiufei
>>
> 
> 
> .
> 
