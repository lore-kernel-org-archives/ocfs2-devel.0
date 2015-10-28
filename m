From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 28 Oct 2015 15:05:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add uuid to ocfs2 thread name for
 problem analysis
In-Reply-To: <563068B8.5020409@huawei.com>
References: <562EF05F.2000901@huawei.com> <562F2E28.4020507@oracle.com>
	<562F6266.3090100@huawei.com> <56304962.7000803@oracle.com>
	<563068B8.5020409@huawei.com>
Message-ID: <563073C6.2020603@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/28/2015 02:18 PM, Joseph Qi wrote:
> On 2015/10/28 12:04, Junxiao Bi wrote:
>> On 10/27/2015 07:39 PM, Joseph Qi wrote:
>>> Hi Junxiao,
>>>
>> ...
>>>>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>>>>> index a43f9ef..570509e 100644
>>>>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>>>>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>>>>> @@ -205,7 +205,7 @@ int dlm_launch_recovery_thread(struct dlm_ctxt *dlm)
>>>>>  	mlog(0, "starting dlm recovery thread...\n");
>>>>>
>>>>>  	dlm->dlm_reco_thread_task = kthread_run(dlm_recovery_thread, dlm,
>>>>> -						"dlm_reco_thread");
>>>>> +			"dlm_reco_thread-%s", dlm->name);
>>>> Indeed max length of task name is 16 bytes, and "dlm_reco_thread" plus
>>>> '\0' have taken all the space. So indeed above code is useless. Can we
>>>> rename this name and maybe other one(like "dlm_thread") to leave more
>>>> space for domain marker?
>>>>
>>> Yes, you are right. For dlm_reco_thread it won't print any uuid bytes.
>>> I put it here just for code consistency.
>>> It is really hard for me to rename it to a better one:)
>>> Any suggestions?
>> How about this?
>>
>> dlmwq-xxxx
>> dlmrec-xxxx
>> dlm-xxxx
>> o2dc-xxxx
>> o2cmt-xxx
>> o2rec-xxx
>>
> Thanks very much for your advice. But from our experience, it is usual
> that we can distinguish the messages if plus 3 uuid bytes. So rename
> all of them may not be necessary.
Just want to name the thread in the simple and clear way. The original
name is a little complicated.
> Could we only rename "dlm_reco_thread" to "dlm_reco-xxx"?
You can do this since this do fix your issue.

Thanks,
Junxiao.
> 
> Thanks,
> Joseph
> 
>> Thanks,
>> Junxiao.
>>
>>>
>>> Thanks,
>>> Joseph
>>>
>>
>>
>>
> 
> 
