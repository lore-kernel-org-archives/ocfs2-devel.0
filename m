From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 26 Jan 2018 01:00:11 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: return error when we attempt to
 access a dirty bh in jbd2
References: <5A6943BC.5010406@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F291508B@H3CMLB12-EX.srv.huawei-3com.com>
	<5A69CAF5.6080204@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F29150C9@H3CMLB12-EX.srv.huawei-3com.com>
	<5A69D146.4030006@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2915216@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,
Good morning:-)

On 2018/1/25 20:45, piaojun wrote:
> Hi Changwei,
> 
> On 2018/1/25 20:30, Changwei Ge wrote:
>> Hi Jun,
>>
>> On 2018/1/25 20:18, piaojun wrote:
>>> Hi Changwei,
>>>
>>> On 2018/1/25 19:59, Changwei Ge wrote:
>>>> Hi Jun,
>>>>
>>>> On 2018/1/25 10:41, piaojun wrote:
>>>>> We should not reuse the dirty bh in jbd2 directly due to the following
>>>>> situation:
>>>>>
>>>>> 1. When removing extent rec, we will dirty the bhs of extent rec and
>>>> Quick questions:
>>>> Do you mean current code puts modifying extent records belonging to a certain file and modifying truncate log into the same transaction?
>>>> If so, forgive me since I didn't figure it out. Could you point out in your following sequence diagram?
>>>>
>>>> Afterwards, I can understand the issue your change log is describing better.
>>>>
>>>> Thanks,
>>>> Changwei
>>>>
>>> Yes, I mean they are in the same transaction as below:
>>>
>>> ocfs2_remove_btree_range
>>>     ocfs2_remove_extent // modify extent records
>>>       ocfs2_truncate_log_append // modify truncate log
>>
>> If so I think the transaction including operations on extent and truncate log won't be committed.
>> And journal should already be aborted if interval transaction commit thread has been woken.
>> So no metadata will be changed.
>> And later, ocfs2_truncate_log_worker shouldn't see any inode on truncate log.
>> Are you sure this is the root cause of your problem?
>> I feel a little strange for it.
>>
>> Thanks,
>> Changwei
>>
> As you said, the transaction was not committed, but after a while the
> bh of truncate log was committed in another transaction. I'm sure for
> the cause and after applying this patch, the duplicate cluster problem
> is gone. I have tested it a few month.

I think we are talking about two jbd2/transactions. right?
One is for moving clusters from extent to truncate log. Let's name it T1.
Anther is for declaiming clusters from truncate log and returning them back to global bitmap. Let's name it T2.

If jbd2 fails to commit T1 due to an IO error, the whole jbd2/journal will be aborted which means it can't work any more.
All following starting transaction and commit transaction will fail.

So, how can the T2 be committed while T1 fails?

Otherwise, did you ever try to recover jbd2/journal? If so, I think your patch here is not fit for mainline yet.

Thanks,
Changwei    

> 
> thanks,
> Jun
> 
>>>
>>> thanks,
>>> Jun
>>>
>>>>>       truncate log at the same time, and hand them over to jbd2.
>>>>> 2. The bhs are not flushed to disk due to abnormal storage link.
>>>>> 3. After a while the storage link become normal. Truncate log flush
>>>>>       worker triggered by the next space reclaiming found the dirty bh of
>>>>>       truncate log and clear its 'BH_Write_EIO' and then set it uptodate
>>>>>       in __ocfs2_journal_access():
>>>>>
>>>>> ocfs2_truncate_log_worker
>>>>>      ocfs2_flush_truncate_log
>>>>>        __ocfs2_flush_truncate_log
>>>>>          ocfs2_replay_truncate_records
>>>>>            ocfs2_journal_access_di
>>>>>              __ocfs2_journal_access // here we clear io_error and set 'tl_bh' uptodata.
>>>>>
>>>>> 4. Then jbd2 will flush the bh of truncate log to disk, but the bh of
>>>>>       extent rec is still in error state, and unfortunately nobody will
>>>>>       take care of it.
>>>>> 5. At last the space of extent rec was not reduced, but truncate log
>>>>>       flush worker have given it back to globalalloc. That will cause
>>>>>       duplicate cluster problem which could be identified by fsck.ocfs2.
>>>>>
>>>>> So we should return -EIO in case of ruining atomicity and consistency
>>>>> of space reclaim.
>>>>>
>>>>> Fixes: acf8fdbe6afb ("ocfs2: do not BUG if buffer not uptodate in __ocfs2_journal_access")
>>>>>
>>>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>>>> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
>>>>> ---
>>>>>     fs/ocfs2/journal.c | 45 +++++++++++++++++++++++++++++++++++----------
>>>>>     1 file changed, 35 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>>>>> index 3630443..d769ca2 100644
>>>>> --- a/fs/ocfs2/journal.c
>>>>> +++ b/fs/ocfs2/journal.c
>>>>> @@ -666,21 +666,46 @@ static int __ocfs2_journal_access(handle_t *handle,
>>>>>     	/* we can safely remove this assertion after testing. */
>>>>>     	if (!buffer_uptodate(bh)) {
>>>>>     		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
>>>>> -		mlog(ML_ERROR, "b_blocknr=%llu\n",
>>>>> -		     (unsigned long long)bh->b_blocknr);
>>>>> +		mlog(ML_ERROR, "b_blocknr=%llu, b_state=0x%lx\n",
>>>>> +		     (unsigned long long)bh->b_blocknr, bh->b_state);
>>>>>
>>>>>     		lock_buffer(bh);
>>>>>     		/*
>>>>> -		 * A previous attempt to write this buffer head failed.
>>>>> -		 * Nothing we can do but to retry the write and hope for
>>>>> -		 * the best.
>>>>> +		 * We should not reuse the dirty bh directly due to the
>>>>> +		 * following situation:
>>>>> +		 *
>>>>> +		 * 1. When removing extent rec, we will dirty the bhs of
>>>>> +		 *    extent rec and truncate log at the same time, and
>>>>> +		 *    hand them over to jbd2.
>>>>> +		 * 2. The bhs are not flushed to disk due to abnormal
>>>>> +		 *    storage link.
>>>>> +		 * 3. After a while the storage link become normal.
>>>>> +		 *    Truncate log flush worker triggered by the next
>>>>> +		 *    space reclaiming found the dirty bh of truncate log
>>>>> +		 *    and clear its 'BH_Write_EIO' and then set it uptodate
>>>>> +		 *    in __ocfs2_journal_access():
>>>>> +		 *
>>>>> +		 *    ocfs2_truncate_log_worker
>>>>> +		 *      ocfs2_flush_truncate_log
>>>>> +		 *        __ocfs2_flush_truncate_log
>>>>> +		 *          ocfs2_replay_truncate_records
>>>>> +		 *            ocfs2_journal_access_di
>>>>> +		 *              __ocfs2_journal_access
>>>>> +		 *
>>>>> +		 * 4. Then jbd2 will flush the bh of truncate log to disk,
>>>>> +		 *    but the bh of extent rec is still in error state, and
>>>>> +		 *    unfortunately nobody will take care of it.
>>>>> +		 * 5. At last the space of extent rec was not reduced,
>>>>> +		 *    but truncate log flush worker have given it back to
>>>>> +		 *    globalalloc. That will cause duplicate cluster problem
>>>>> +		 *    which could be identified by fsck.ocfs2.
>>>>> +		 *
>>>>> +		 * So we should return -EIO in case of ruining atomicity
>>>>> +		 * and consistency of space reclaim.
>>>>>     		 */
>>>>>     		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
>>>>> -			clear_buffer_write_io_error(bh);
>>>>> -			set_buffer_uptodate(bh);
>>>>> -		}
>>>>> -
>>>>> -		if (!buffer_uptodate(bh)) {
>>>>> +			mlog(ML_ERROR, "A previous attempt to write this "
>>>>> +				"buffer head failed\n");
>>>>>     			unlock_buffer(bh);
>>>>>     			return -EIO;
>>>>>     		}
>>>>>
>>>> .
>>>>
>>>
>> .
>>
> 
