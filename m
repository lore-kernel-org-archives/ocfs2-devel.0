From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 18 Oct 2017 08:42:32 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix cluster hang after a node dies
References: <63ADC13FD55D6546B7DECE290D39E373CED6E0F9@H3CMLB14-EX.srv.huawei-3com.com>
	<59E70E1B.7000303@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED6E946@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: piaojun <piaojun@huawei.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, Mark Fasheh <mfasheh@versity.com>, Junxiao Bi <junxiao.bi@oracle.com>, Joseph Qi <jiangqi903@gmail.com>, Joel Becker <jlbec@evilplan.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Vitaly Mayatskih <v.mayatskih@gmail.com>

On 2017/10/18 16:21, piaojun wrote:
> Hi Changwei,
> 
> Could you share the method to reproduce the problem?
Hi Jun,
It's easy to reproduce this issue, just make a node dead, no mater how.
For example, make a node crash via 'magic sysrq'.
Also you can refer to Vitaly's mail. Perhaps he can provide some better 
or more detailed clues.

Thanks,
Changwei.
> 
> On 2017/10/17 14:48, Changwei Ge wrote:
>> When a node dies, other live nodes have to choose a new master
>> for an existed lock resource mastered by the dead node.
>>
>> As for ocfs2/dlm implementation, this is done by function -
>> dlm_move_lockres_to_recovery_list which marks those lock rsources
>> as DLM_LOCK_RES_RECOVERING and manages them via a list from which
>> DLM changes lock resource's master later.
>>
>> So without invoking dlm_move_lockres_to_recovery_list, no master will
>> be choosed after dlm recovery accomplishment since no lock resource can
>> be found through ::resource list.
>>
>> What's worse is that if DLM_LOCK_RES_RECOVERING is not marked for
>> lock resources mastered a dead node, it will break up synchronization
>> among nodes.
>>
>> So invoke dlm_move_lockres_to_recovery_list again.
>>
>> Fixs: 'commit ee8f7fcbe638 ("ocfs2/dlm: continue to purge recovery
>> lockres when recovery master goes down")'
>>
>> Reported-by: Vitaly Mayatskih <v.mayatskih@gmail.com>
>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>    fs/ocfs2/dlm/dlmrecovery.c |    1 +
>>    1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index 74407c6..ec8f758 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -2419,6 +2419,7 @@ static void dlm_do_local_recovery_cleanup(struct
>> dlm_ctxt *dlm, u8 dead_node)
>>    					dlm_lockres_put(res);
>>    					continue;
>>    				}
>> +				dlm_move_lockres_to_recovery_list(dlm, res);
>>    			} else if (res->owner == dlm->node_num) {
>>    				dlm_free_dead_locks(dlm, res, dead_node);
>>    				__dlm_lockres_calc_usage(dlm, res);
>>
> 
