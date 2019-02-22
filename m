From: piaojun <piaojun@huawei.com>
Date: Fri, 22 Feb 2019 11:15:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: return DLM_CANCELGRANT if the
 lock is on granted list and the operation is canceled
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373012786751B@H3CMLB14-EX.srv.huawei-3com.com>
References: <98f0e80c-9c13-dbb6-047c-b40e100082b1@huawei.com>
	<00607177-cb1b-d380-e6d3-3d5cb9b3c991@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301277F1589@H3CMLB12-EX.srv.huawei-3com.com>
	<7420155e-f7d6-520c-5134-4a681399a68a@huawei.com>
	<5C652F12.9010408@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301278538DD@H3CMLB14-EX.srv.huawei-3com.com>
	<5C666142.7000100@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301278541E8@H3CMLB14-EX.srv.huawei-3com.com>
	<5C666BA8.4030403@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301278542B3@H3CMLB14-EX.srv.huawei-3com.com>
	<5C66843D.60603@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127854405@H3CMLB14-EX.srv.huawei-3com.com>
	<5C668AFF.1090407@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127865329@H3CMLB14-EX.srv.huawei-3com.com>
	<5C6B523D.3040100@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301278659CC@H3CMLB14-EX.srv.huawei-3com.com>
	<5C6BBDD3.3010400@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373012786751B@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5C6F6967.1030608@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2019/2/21 14:46, Changwei Ge wrote:
> Hi jun
> Good afternoon.
> 
>>>>> If AST doesn't manage to get back to requested node, why must flag OCFS2_LOCK_BUSY be cleared in o2dlm_unlock_ast_wrapper?
>>>>>
>>>>> Yes, OCFS2_LOCK_BUSY can be cleared it either o2dlm_unlock_ast_wrapper() or o2dlm_lock_ast_wrapper() with o2cb stack applied.
>>>>>
>>>>> If we return DLM_CANCELGRANT from ocfs2/dlm to dlm, then we must know that AST has ever come back or master node has moved the lock to grant list itself, thus we clear flag OCFS2_LOCK_BUSY in o2dlm_lock_ast_wrapper().
>>>>> Otherwise we ascertain that we can stop current ongoing locking procedure and must clear OCFS2_LOCK_BUSY in o2dlm_unlock_ast_wrapper() (*synchronized*).
>>>>>
>>>>> Let's summarize this, OCFS2_LOCK_BUSY should be cleared whether by locking success or cancellation success.
>>>>>
>>>>> And my way already check if the lock is granted then return DLM_CANCELGRANT or not.
>>>>>
>>>>
>>>> OCFS2_LOCK_BUSY won't be cleared if DLM_CANCELGRANT is set in
>>>> o2dlm_unlock_ast_wrapper, and that's what I'm concerned about:
>>>
>>> But we already *ascertain* that previous locking request has been *granted* before deciding to return DLM_CANCELGRANT during cancellation to o2dlm_unlock_ast_wrapper().
>>>
>>> If above condition stands, o2dlm_lock_ast_wrapper() must will be or have been called, which also clears OCFS2_LOCK_BUSY.
>>>
>>
>> 1. Node1 already has PR lock, and wants to get ex.
> Well, a locking up-conversion procedure.
> 
>> 2. Node1 receive BAST and do unlock, here OCFS2_LOCK_BUSY is set.
> Because there are two concurrent up-conversion, which conflict, so one of them must be canceled!
> 
>> 3. Node1 can not receive the AST for unlock as master dead.
> So here you mean the lock can't be granted.
> 
>> 4. Then o2dlm_unlock_ast_wrapper will be called rather than o2dlm_lock_ast_wrapper.
> Then the cancellation succeeds as the master dies.
> 
>> 5. Actually the *granted* lock request has nothing to do with OCFS2_LOCK_BUSY.
> Yes, o2dlm_lock_ast_wrapper will not clear OCFS2_LOCK_BUSY.
> 
> But my suggestion was not against above timing sequence.
> Did you misunderstand my suggestion?
> And the original logic of Jian's patch also returns DLM_CANCELGRANT.

Yes, Jian's last patch can't solve the problem either, and I think we
should find another solution for it. I'm considering deleting the check
for DLM_CANCELGRANT, and clear OCFS2_LOCK_BUSY in the following process.

Thanks,
Jun

> 
> Thanks,
> Changwei
> 
> 
>   
> 
> .
> 
