From: wangjian <wangjian161@huawei.com>
Date: Thu, 6 Dec 2018 19:53:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Clean DLM_LKSB_GET_LVB and
 DLM_LKSB_PUT_LVB when the cancel_pending is set
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37301277EFAE6@H3CMLB12-EX.srv.huawei-3com.com>
References: <bffbe5a5-acb6-652d-eb8a-99fb051e6631@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E37301277EFAE6@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <758fcbd8-9f46-7e33-7389-91ba4ca1c2bf@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

The core information that causes the bug in the dlm_proxy_ast_handler function is as follows.

[? 699.795843] kernel BUG at /home/Euler_compile_env/usr/src/linux-4.18/fs/ocfs2/dlm/dlmast.c:427!
[? 699.797525] invalid opcode: 0000 [#1] SMP NOPTI
[? 699.798383] CPU: 8 PID: 510 Comm: kworker/u24:1 Kdump: loaded Tainted: G?????????? OE???? 4.18.0 #1
[? 699.800002] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[? 699.801963] Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
[? 699.803275] RIP: 0010:dlm_proxy_ast_handler+0x738/0x740 [ocfs2_dlm]
[? 699.804710] Code: 00 10 48 8d 7c 24 48 48 89 44 24 48 48 c7 c1 f1 35 92 c0 ba 30 01 00 00 48 c7 c6 30 a9 91 c0 31 c0 e8
ac 88 fb ff 0f 0b 0f 0b <0f> 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 45 89 c7
[? 699.808506] RSP: 0018:ffffba64c6f2fd38 EFLAGS: 00010246
[? 699.809456] RAX: ffff9f34a9b39148 RBX: ffff9f30b7af4000 RCX: ffff9f34a9b39148
[? 699.810698] RDX: 000000000000019e RSI: ffffffffc091a930 RDI: ffffba64c6f2fd80
[? 699.811927] RBP: ffff9f2cb7aa3000 R08: ffff9f2cb7b99400 R09: 000000000000001f
[? 699.813457] R10: ffff9f34a9249200 R11: ffff9f34af23aa00 R12: 0000000040000000
[? 699.814719] R13: ffff9f34a9249210 R14: 0000000000000002 R15: ffff9f34af23aa28
[? 699.815984] FS:? 0000000000000000(0000) GS:ffff9f32b7c00000(0000) knlGS:0000000000000000
[? 699.817417] CS:? 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[? 699.818825] CR2: 00007fd772f5a140 CR3: 000000005b00a001 CR4: 00000000001606e0
[? 699.820123] Call Trace:
[? 699.820658]? o2net_rx_until_empty+0x94b/0xcc0 [ocfs2_nodemanager]
[? 699.821848]? process_one_work+0x171/0x370
[? 699.822595]? worker_thread+0x49/0x3f0
[? 699.823301]? kthread+0xf8/0x130
[? 699.823972]? ? max_active_store+0x80/0x80
[? 699.824881]? ? kthread_bind+0x10/0x10
[? 699.825589]? ret_from_fork+0x35/0x40

The reasons for clearing the LVB flag are as follows. First, The owner of the lock resource
may have died, the lock has been moved to the grant queue, the purpose of the lock
cancellation has been reached, and the LVB flag should be cleared. Second, solve this panic problem.

Thanks,
Jian

On 12/5/2018 10:01 AM, Changwei Ge wrote:
> Hi Jian,
>
> Could your please also share the panic backtrace in dlm_proxy_ast_handler()?
> After that I can help to review this patch and analyze what's wrong in DLM.
>
> It will be better for you to tell your intention why LVB flags should be cleared rather
> than just giving a longggg time sequence diagram.
>
> Moreover, your patches are hard be applied to my tree :(
>
> Thanks,
> Changwei
>
>
> On 2018/12/3 20:08, wangjian wrote:
>> Function dlm_move_lockres_to_recovery_list should clean
>> DLM_LKSB_GET_LVB and DLM_LKSB_PUT_LVB when the cancel_pending
>> is set. Otherwise node may panic in dlm_proxy_ast_handler.
>>
>> Here is the situation: At the beginning, Node1 is the master
>> of the lock resource and has NL lock, Node2 has PR lock,
>> Node3 has PR lock, Node4 has NL lock.
>>
>> Node1        Node2            Node3            Node4
>>                convert lock_2 from
>>                PR to EX.
>>
>> the mode of lock_3 is
>> PR, which blocks the
>> conversion request of
>> Node2. move lock_2 to
>> conversion list.
>>
>>                             convert lock_3 from
>>                             PR to EX.
>>
>> move lock_3 to conversion
>> list. send BAST to Node3.
>>
>>                             receive BAST from Node1.
>>                             downconvert thread execute
>>                             canceling convert operation.
>>
>> Node2 dies because
>> the host is powered down.
>>
>>                             in dlmunlock_common function,
>>                             the downconvert thread set
>>                             cancel_pending. at the same
>>                             time, Node 3 realized that
>>                             Node 1 is dead, so move lock_3
>>                             back to granted list in
>>                             dlm_move_lockres_to_recovery_list
>>                             function and remove Node 1 from
>>                             the domain_map in
>>                             __dlm_hb_node_down function.
>>                             then downconvert thread failed
>>                             to send the lock cancellation
>>                             request to Node1 and return
>>                             DLM_NORMAL from
>>                             dlm_send_remote_unlock_request
>>                             function.
>>
>>                                                   become recovery master.
>>
>>                during the recovery
>>                process, send
>>                lock_2 that is
>>                converting form
>>                PR to EX to Node4.
>>
>>                             during the recovery process,
>>                             send lock_3 in the granted list and
>>                             cantain the DLM_LKSB_GET_LVB
>>                             flag to Node4. Then downconvert thread
>>                             delete DLM_LKSB_GET_LVB flag in
>>                             dlmunlock_common function.
>>
>>                                                   Node4 finish recovery.
>>                                                   the mode of lock_3 is
>>                                                   PR, which blocks the
>>                                                   conversion request of
>>                                                   Node2, so send BAST
>>                                                   to Node3.
>>
>>                             receive BAST from Node4.
>>                             convert lock_3 from PR to NL.
>>
>>                                                   change the mode of lock_3
>>                                                   from PR to NL and send
>>                                                   message to Node3.
>>
>>                             receive message from
>>                             Node4. The message contain
>>                             LKM_GET_LVB flag, but the
>>                             lock->lksb->flags does not
>>                             contain DLM_LKSB_GET_LVB,
>>                             BUG_ON in dlm_proxy_ast_handler
>>                             function.
>>
>> Signed-off-by: Jian Wang<wangjian161@huawei.com>
>> Reviewed-by: Yiwen Jiang<jiangyiwen@huawei.com>
>> ---
>>    fs/ocfs2/dlm/dlmunlock.c | 1 +
>>    1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
>> index 63d701c..6e04fc7 100644
>> --- a/fs/ocfs2/dlm/dlmunlock.c
>> +++ b/fs/ocfs2/dlm/dlmunlock.c
>> @@ -277,6 +277,7 @@ void dlm_commit_pending_cancel(struct dlm_lock_resource *res,
>>    {
>>    	list_move_tail(&lock->list, &res->granted);
>>    	lock->ml.convert_type = LKM_IVMODE;
>> +	lock->lksb->flags &= ~(DLM_LKSB_GET_LVB|DLM_LKSB_PUT_LVB);
>>    }
>>    
>>    
>> -- 
>> 1.8.3.1
>>
> .
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20181206/74f0b3b7/attachment.html 
