From: Daniel Sobe <daniel.sobe@nxp.com>
Date: Fri, 17 May 2019 14:21:35 +0000
Subject: [Ocfs2-devel] [EXT] Re: [PATCH v2] fs/ocfs2: fix race in
 ocfs2_dentry_attach_lock
In-Reply-To: <55acfccf-cdb0-d6a1-0b5d-1f37da1b87dc@oracle.com>
References: <20190507185218.23770-1-wen.gang.wang@oracle.com>
	<HK2PR02MB39244F2B8C362BA6F6F7F809D5320@HK2PR02MB3924.apcprd02.prod.outlook.com>
	<9abd5a73-23bc-6007-c2fd-d7e518c99c11@oracle.com>
	<HK2PR02MB392481F0EA57BC1FBC83E825D5330@HK2PR02MB3924.apcprd02.prod.outlook.com>
	<c25b8d27-dfd4-72ca-f273-21ed632e2697@oracle.com>
	<TY2PR02MB3935F1C067809A0F67E528D5D50C0@TY2PR02MB3935.apcprd02.prod.outlook.com>
	<AM6PR04MB560519CC9D0CEC897C176752ED0C0@AM6PR04MB5605.eurprd04.prod.outlook.com>
	<55acfccf-cdb0-d6a1-0b5d-1f37da1b87dc@oracle.com>
Message-ID: <AM6PR04MB56054E98956A1314DC34EE1BED0B0@AM6PR04MB5605.eurprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

with several days of uptime and several occurrences of the debug print, now I am convinced that the issue is resolved. Thank you again! 

Regards,

Daniel

-----Original Message-----
From: Wengang Wang <wen.gang.wang@oracle.com> 
Sent: Montag, 13. Mai 2019 19:02
To: Daniel Sobe <daniel.sobe@nxp.com>
Cc: Changwei Ge <gechangwei@live.cn>; ocfs2-devel at oss.oracle.com
Subject: Re: [EXT] Re: [Ocfs2-devel] [PATCH v2] fs/ocfs2: fix race in ocfs2_dentry_attach_lock

Caution: EXT Email

Thank you Daniel for your effort on testing this!

Regards,
Wengang

On 2019/5/10 0:17, Daniel Sobe wrote:
> Hi,
>
> I'm running version 2 of the patch with the optional debug print enabled. Judging by that, the issue did not occur yet (no print so far). I will report any failures, or, after having seen the debug print for several times without any issues, success.
>
> Thank you already for helping me out by finding the cause for this issue!
>
> Regards,
>
> Daniel
>
> -----Original Message-----
> From: ocfs2-devel-bounces at oss.oracle.com 
> <ocfs2-devel-bounces@oss.oracle.com> On Behalf Of Changwei Ge
> Sent: Freitag, 10. Mai 2019 03:47
> To: Wengang Wang <wen.gang.wang@oracle.com>; 
> ocfs2-devel at oss.oracle.com
> Subject: [EXT] Re: [Ocfs2-devel] [PATCH v2] fs/ocfs2: fix race in 
> ocfs2_dentry_attach_lock
>
> Caution: EXT Email
>
> On 2019/5/10 1:08 ??, Wengang Wang wrote:
>> Hi Changwei,
>>
>> On 2019/5/8 18:52, Changwei Ge wrote:
>>> Hi Wengang?
>>>
>>>
>>> After checking out your further elaboration,  all my concerns are 
>>> cleared.
>>>
>>> I truly had a overlook on your patch then ...
>> Thank you for your active review! Let's wait for Daniel's test result.
>
> OK. You can also add my
>
> Reviewed-by:  Changwei Ge <gechangwei@live.cn>
>
> together with Daniel's positive feedback(if any) :)
>
>
> Thank you for your effort into this issue. I suppose Daniel has been reporting it since a long time ago.
>
>
> Thanks,
>
> Changwei
>
>
>> thanks,
>> wengang
>>
>>>
>>> Thanks?
>>>
>>> Changwei
>>>
>>>
>>> On 2019/5/9 12:32 ??, Wengang Wang wrote:
>>>> On 2019/5/7 19:06, Changwei Ge wrote:
>>>>> Hi Wengang,
>>>>>
>>>>>
>>>>> I think this version might need be improved.
>>>>>
>>>>>
>>>>> On 2019/5/8 2:52 ??, Wengang Wang wrote:
>>>>>> ocfs2_dentry_attach_lock() can be executed in parallel threads 
>>>>>> against the same dentry. Make that race safe.
>>>>>> The race is like this:
>>>>>>
>>>>>>                 thread A thread B
>>>>>>
>>>>>> (A1) enter ocfs2_dentry_attach_lock, seeing dentry->d_fsdata is 
>>>>>> NULL, and no alias found by ocfs2_find_local_alias, so kmalloc a 
>>>>>> new ocfs2_dentry_lock structure to local variable "dl", dl1
>>>>>>
>>>>>>                    .....
>>>>>>
>>>>>>                                         (B1) enter 
>>>>>> ocfs2_dentry_attach_lock,
>>>>>>                                         seeing dentry->d_fsdata 
>>>>>> is NULL,
>>>>>>                                         and no alias found by 
>>>>>> ocfs2_find_local_alias so kmalloc
>>>>>>                                         a new ocfs2_dentry_lock 
>>>>>> structure
>>>>>>                                         to local variable "dl", dl2.
>>>>>>
>>>>>> ......
>>>>>>
>>>>>> (A2) set dentry->d_fsdata with dl1, call ocfs2_dentry_lock() and 
>>>>>> increase
>>>>>> dl1->dl_lockres.l_ro_holders to 1 on
>>>>>> success.
>>>>>>                   ......
>>>>>>
>>>>>>                                         (B2) set dentry->d_fsdata 
>>>>>> with
>>>>>> dl2
>>>>>>                                         call ocfs2_dentry_lock() 
>>>>>> and increase
>>>>>>                       dl2->dl_lockres.l_ro_holders to 1 on
>>>>>>                       success.
>>>>>>
>>>>>> ......
>>>>>>
>>>>>> (A3) call ocfs2_dentry_unlock()
>>>>>> and decrease
>>>>>> dl2->dl_lockres.l_ro_holders to 0
>>>>>> on success.
>>>>>>                  ....
>>>>>>
>>>>>>                                         (B3) call 
>>>>>> ocfs2_dentry_unlock(),
>>>>>>                                         decreasing
>>>>>>                       dl2->dl_lockres.l_ro_holders, but
>>>>>>                       see it's zero now, panic
>>>>>>
>>>>>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>>>>>> ---
>>>>>> v2: 1) removed lock on dentry_attach_lock at the first access of
>>>>>>            dentry->d_fsdata since it helps very little.
>>>>>>         2) do cleanups before freeing the duplicated dl
>>>>>>         3) return after freeing the duplicated dl found.
>>>>>> ---
>>>>>>      fs/ocfs2/dcache.c | 16 ++++++++++++++--
>>>>>>      1 file changed, 14 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c index 
>>>>>> 290373024d9d..0d220a66297e 100644
>>>>>> --- a/fs/ocfs2/dcache.c
>>>>>> +++ b/fs/ocfs2/dcache.c
>>>>>> @@ -230,6 +230,7 @@ int ocfs2_dentry_attach_lock(struct dentry 
>>>>>> *dentry,
>>>>>>          int ret;
>>>>>>          struct dentry *alias;
>>>>>>          struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
>>>>>> +    struct ocfs2_dentry_lock *dl_free_on_race = NULL;
>>>>>> trace_ocfs2_dentry_attach_lock(dentry->d_name.len,
>>>>>> dentry->d_name.name,
>>>>>>                             (unsigned long long)parent_blkno, 
>>>>>> dl); @@ -310,10 +311,21 @@ int ocfs2_dentry_attach_lock(struct 
>>>>>> dentry *dentry,
>>>>>>         out_attach:
>>>>>>          spin_lock(&dentry_attach_lock);
>>>>>> -    dentry->d_fsdata = dl;
>>>>>> -    dl->dl_count++;
>>>>>> +    /* d_fsdata could be set by parallel thread */
>>>>>> +    if (unlikely(dentry->d_fsdata && !alias)) {
>>>>>> +        dl_free_on_race = dl;
>>>>>> +    } else {
>>>>>> +        dentry->d_fsdata = dl;
>>>>>> +        dl->dl_count++;
>>>>>> +    }
>>>>>>          spin_unlock(&dentry_attach_lock);
>>>>>>      +    if (unlikely(dl_free_on_race)) {
>>>>>> +        iput(dl_free_on_race->dl_inode); 
>>>>>> + ocfs2_lock_res_free(&dl_free_on_race->dl_lockres);
>>>>> I am afraid we are meeting a great risk here as we don't know if 
>>>>> the another dentry lock code path is still using the being freed 
>>>>> lock resource.
>>>> Any access to this lock resource via dlm_debug->d_lockres_tracking 
>>>> should be with ocfs2_dlm_tracking_lock locked. That lock protects 
>>>> the lock resources well.  This is the design. If any access is 
>>>> without the lock protection, it should take a reference of that 
>>>> lock resource thus there should be a reference count field in ocfs2_lock_res structure.
>>>> But there is no such reference count there. It's not designed to 
>>>> access the lock resource "offlock".
>>>>
>>>> The dl I am freeing is still local (though it's in 
>>>> d_lockres_tracking list, I explained it's safe above). I didn't set 
>>>> it do dentry->fs_data yet, so another dentry lock path can't see it 
>>>> at all so can't have any access to it.
>>>>
>>>>
>>>>> So another code path might use a freed lock resource.
>>>> There is no such possibility.
>>>>> This might be the
>>>>> cause of the problem Daniel reported last night(in China).
>>>> Nope, the problem that Daniel reported is just because I didn't 
>>>> remove this lock resource from that list.
>>>>
>>>> I freed that dl (including the lock resource) leaving that lock 
>>>> resource (freed memory) in d_lockres_tracking list. That memory 
>>>> then is reused for other purpose causing the original "next" and "prev"
>>>> changed, leading the corruption on that list.
>>>>
>>>>
>>>>>> +        kfree(dl_free_on_race);
>>>>>> +        return 0;
>>>>> Moreover, I think we can't directly return from here especially we 
>>>>> are returning 0 here since we even don't increase dentry lock 
>>>>> resource holders counter. :(
>>>> This hit the race case, means another path is doing the same thing.
>>>> That racing path would do the lock and then unlock stuff. This path 
>>>> doesn't need to do the duplicated work.
>>>>
>>>> Returning 0 is the same behavior as the original code does at the 
>>>> very beginning of ocfs2_dentry_attach_lock on seeing 
>>>> dentry->fs_data is not NULL.
>>>>
>>>> Actually this function doesn't return with increased holder 
>>>> counter, it lock (increase ro_holders by 1) and unlock immediately 
>>>> (decrease ro_holders by 1), so the holder counter remains 
>>>> unchanged. The purpose is not to lock but to get a chance (via 
>>>> callback
>>>> ocfs2_dentry_convert_worker) to get notified when the file is 
>>>> removed by remote node.
>>>>
>>>> thanks,
>>>> wengang
>>>>
>>>>> Thanks,
>>>>>
>>>>> Changwei
>>>>>
>>>>>> +    }
>>>>>>          /*
>>>>>>           * This actually gets us our PRMODE level lock. From now on,
>>>>>>           * we'll have a notification if one of these names is
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://urldefense.proofpoint.com/v2/url?u=https-3A__eur01.safelinks.protection.outlook.com_-3Furl-3Dhttps-253A-252F-252Foss&d=DwIGaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Gz7_NR-FntEMsX_dGTWM6WAmtQzCzraf8N8rgZ5XxWI&s=3Aukp4l74jZb8W-KGtCtmXO9qC1azKFkWAXc_4wWc4w&e=.
> oracle.com%2Fmailman%2Flistinfo%2Focfs2-devel&amp;data=02%7C01%7Cdanie
> l.sobe%40nxp.com%7C1b23960ebdec48a5dd7808d6d7c4bc59%7C686ea1d3bc2b4c6f
> a92cd99c5c301635%7C0%7C0%7C636933637309761294&amp;sdata=JTi6hQGsYS%2Fy
> rI16neiae8Q055Rg%2BLVaOLnG4BqxQyo%3D&amp;reserved=0
