From: piaojun <piaojun@huawei.com>
Date: Sat, 24 Feb 2018 14:42:19 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean unrelated comment
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2925A5A@H3CMLB12-EX.srv.huawei-3com.com>
References: <1519371054-4648-1-git-send-email-ge.changwei@h3c.com>
	<5A8FDB1E.6040900@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2925A5A@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5A91094B.5000108@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2018/2/23 17:55, Changwei Ge wrote:
> Hi Jun,
> 
> On 2018/2/23 17:13, piaojun wrote:
>> Hi changwei,
>>
>> On 2018/2/23 15:30, ge.changwei at h3c.com wrote:
>>> From: Changwei Ge <ge.changwei@h3c.com>
>> This line seems unnecessary, others looks good to me.
> I used git send-email, thus this line was added by parameter --from.
> I suppose you could ignore it if it seems strange to you:-)
If this won't affect the patch format, you could add:
Reviewed-by: Jun Piao <piaojun@huawei.com>

thanks,
Jun
> 
> Thanks,
> Changwei
> 
>>
>> thanks,
>> Jun
>>>
>>> Obviously, the comment before dlm_do_local_recovery_cleanup() has
>>> nothing to do with it. So remove it.
>>>
>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>> ---
>>>   fs/ocfs2/dlm/dlmrecovery.c | 7 -------
>>>   1 file changed, 7 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>>> index ec8f758..65f0c54 100644
>>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>> @@ -2331,13 +2331,6 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
>>>   	__dlm_dirty_lockres(dlm, res);
>>>   }
>>>   
>>> -/* if this node is the recovery master, and there are no
>>> - * locks for a given lockres owned by this node that are in
>>> - * either PR or EX mode, zero out the lvb before requesting.
>>> - *
>>> - */
>>> -
>>> -
>>>   static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
>>>   {
>>>   	struct dlm_lock_resource *res;
>>>
>>
> .
> 
