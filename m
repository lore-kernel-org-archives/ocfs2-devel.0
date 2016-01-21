From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 21 Jan 2016 16:18:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmglue: fix false deadlock caused
 by clearing UPCONVERT_FINISHING too early
In-Reply-To: <20160121081054.GA19164@laptop.ha>
References: <1453222013-9425-1-git-send-email-zren@suse.com>
	<56A0845C.5050208@oracle.com> <20160121081054.GA19164@laptop.ha>
Message-ID: <56A0945E.40206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/21/2016 04:10 PM, Eric Ren wrote:
> Hi Junxiao,
> 
> On Thu, Jan 21, 2016 at 03:10:20PM +0800, Junxiao Bi wrote: 
>> Hi Eric,
>>
>> This patch should fix your issue.
>> "NFS hangs in __ocfs2_cluster_lock due to race with ocfs2_unblock_lock"
> 
> Thanks a lot for bringing up this patch! It hasn't been merged into mainline(
> at least 4.4), right?
Right, it is still in linux-next.

Thanks,
Junxiao.
> 
> I have found this patch in maillist and it looks good! I'd like to test it right
> now and give feadback!
> 
> Thanks again,
> Eric
> 
>>
>> Thanks,
>> Junxiao.
>> On 01/20/2016 12:46 AM, Eric Ren wrote:
>>> This problem was introduced by commit a19128260107f951d1b4c421cf98b92f8092b069.
>>> OCFS2_LOCK_UPCONVERT_FINISHING is set just before clearing OCFS2_LOCK_BUSY. This
>>> will prevent dc thread from downconverting immediately, and let mask-waiters in
>>> ->l_mask_waiters list whose requesting level is compatible with ->l_level to take
>>> the lock. But if we have two waiters in mw list, the first is to get EX lock, and
>>> the second is to to get PR lock. The first may fail to get lock and then clear
>>> UPCONVERT_FINISHING. It's too early to clear the flag because this second will be
>>> also queued again even if ->l_level is PR. As a result, nobody would kick up dc
>>> thread, leaving dlmglue a deadlock until another lockres relative thread wake it
>>> up.
>>>
>>> More specifically, for example:
>>> On node1, there is thread W1 keeping writing; on node2, there are thread R1 and
>>> R2 keeping reading; sure this 3 threads make IO on the same shared file. At a
>>> time, node2 is receiving ast(0=>3), followed immediately by a bast requesting EX
>>> lock on behave of node1. Then this may happen:
>>> node2:                                          node1:
>>> l_level==3; R1(3); R2(3)                        l_level==3
>>> R1(unlock); R1(3=>5, update atime)              W1(3=>5)
>>> BAST
>>> R2(unlock); AST(3=>0)
>>> R2(0=>3)
>>>                                                 BAST
>>> AST(0=>3)
>>> set OCFS2_LOCK_UPCONVERT_FINISHING
>>> clear OCFS2_LOCK_BUSY
>>>                                                 W1(3=>5)
>>> BAST
>>> dc thread requeue=yes
>>> R1(clear OCFS2_LOCK_UPCONVERT_FINISHING,wait)
>>> R2(wait)
>>> ...
>>> dlmglue deadlock util dc thread woken up by others
>>>
>>> This fix is to clear OCFS2_LOCK_UPCONVERT_FINISHING util OCFS2_LOCK_BUSY has
>>> been cleared and every waiters has been looped.
>>>
>>> Signed-off-by: Eric Ren <zren@suse.com>
>>> ---
>>>  fs/ocfs2/dlmglue.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>> index f92612e..72f8b6c 100644
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -824,6 +824,8 @@ static void lockres_clear_flags(struct ocfs2_lock_res *lockres,
>>>  				unsigned long clear)
>>>  {
>>>  	lockres_set_flags(lockres, lockres->l_flags & ~clear);
>>> +	if(clear & OCFS2_LOCK_BUSY)
>>> +		lockres->l_flags &= ~OCFS2_LOCK_UPCONVERT_FINISHING;
>>>  }
>>>  
>>>  static inline void ocfs2_generic_handle_downconvert_action(struct ocfs2_lock_res *lockres)
>>> @@ -1522,8 +1524,6 @@ update_holders:
>>>  
>>>  	ret = 0;
>>>  unlock:
>>> -	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
>>> -
>>>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>>>  out:
>>>  	/*
>>>
>>
>>
