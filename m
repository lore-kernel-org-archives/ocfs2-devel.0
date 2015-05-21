From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 21 May 2015 10:09:01 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: do not BUG if
 jbd2_journal_dirty_metadata fails
In-Reply-To: <555D2B8F.1050704@huawei.com>
References: <55515D2B.8010202@huawei.com> <555C4434.7090807@oracle.com>
	<555C610C.3020902@huawei.com> <555C6B65.2080605@oracle.com>
	<555D2B8F.1050704@huawei.com>
Message-ID: <555D3E3D.8070101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/21/2015 08:49 AM, Joseph Qi wrote:
> On 2015/5/20 19:09, Junxiao Bi wrote:
>> On 05/20/2015 06:25 PM, Joseph Qi wrote:
>>> On 2015/5/20 16:22, Junxiao Bi wrote:
>>>> On 05/12/2015 09:53 AM, Joseph Qi wrote:
>>>>> jbd2_journal_dirty_metadata may fail. Currently it cannot take care of
>>>>> non zero return value and just BUG in ocfs2_journal_dirty.
>>>>> This patch is aborting the handle and journal instead of BUG.
>>>>>
>>>>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>>>>> Cc: joyce.xue <xuejiufei@huawei.com>
>>>>> ---
>>>>>  fs/ocfs2/journal.c | 12 +++++++++++-
>>>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>>>> index ff53192..eefca1e 100644
>>>>> --- a/fs/ocfs2/journal.c
>>>>> +++ b/fs/ocfs2/journal.c
>>>>> @@ -775,7 +775,17 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
>>>>>  	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);
>>>>>
>>>>>  	status = jbd2_journal_dirty_metadata(handle, bh);
>>>>> -	BUG_ON(status);
>>>>> +	if (status) {
>>>>> +		mlog_errno(status);
>>>>> +		if (!is_handle_aborted(handle)) {
>>>>> +			journal_t *journal = handle->h_transaction->t_journal;
>>>>> +
>>>>> +			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
>>>>> +					"Aborting transaction and journal.");
>>>>> +			handle->h_err = status;
>>>>> +			jbd2_journal_abort_handle(handle);
>>>>> +			jbd2_journal_abort(journal, status);
>>>> Let fs go after journal lose affect seemed not safe, may we set fs
>>>> read-only here?
>>>>
>>>> Thanks,
>>>> Junxiao.
>>>>
>>>>
>>> Do you mean journal can still be updated even if it is aborted?
>> No, journal will not be updated. After abort, journal api will return
>> error, at last fs will be set read-only, but there is also api which
>> didn't return error like ocfs2_journal_dirty(), so why not stop at the
>> first time?
>>
>> Thanks,
>> Junxiao.
> Agree with you.
> But here bh can be anything like di, gd, ... As Joyce Xue reported, the
> problem also exists in ocfs2_abort_trigger. So I don't think we can get
> sb we needed.
Yes, right.

> Is there any other way except changing prototype of ocfs2_journal_dirty?
I can't see how to do that. From me, if jbd2_journal_dirty_metadata()
return an error, there seemed a bug, BUG_ON for a bug seemed acceptable
since not easy to set fs read-only from here.
Did you ever watch this BUG_ON triggered not due to a bug?

Thanks,
Junxiao.


> 
>>>
>>>>> +		}
>>>>> +	}
>>>>>  }
>>>>>
>>>>>  #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
>>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>> .
>>
> 
> 
