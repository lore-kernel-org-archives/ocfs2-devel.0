From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 15 Feb 2019 08:27:27 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: checkpoint appending truncate log
 transaction before flushing
References: <1550116993-17084-1-git-send-email-ge.changwei@h3c.com>
	<5C6525AB.2020603@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127853771@H3CMLB14-EX.srv.huawei-3com.com>
	<5C653D96.1030508@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E3730127853911@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373012785431C@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

Do you have any other question, advise or concern?
I am expecting an explicit feedback(ack/nack) if you already understand the problem and my way fixing it.

Thanks,
Changwei

On 2019/2/14 18:25, Changwei Ge wrote:
> On 2019/2/14 18:06, piaojun wrote:
>> Hi Changwei,
>>
>> On 2019/2/14 16:53, Changwei Ge wrote:
>>> Hi Jun,
>>>
>>> Thanks for looking into this :-)
>>>
>>> On 2019/2/14 16:24, piaojun wrote:
>>>> Hi Changwei,
>>>>
>>>> On 2019/2/14 12:03, Changwei Ge wrote:
>>>>> Appending truncate log(TA) and and flushing truncate log(TF) are
>>>>> two separated transactions. They can be both committed but not
>>>>> checkpointed. If crash occurs then, both two transaction will be
>>>>> replayed with several already released to global bitmap clusters.
>>>>
>>>> Do you mean that both the two transactions will release cluster to
>>>> global bitmap? But I think the TA won't give back clusters to global
>>>> bitmap.
>>>>
>>>
>>> No, I don't mean that both TA and TF are releasing clusters to global bitmap.
>>>
>>> But consideration into clusters reclaim , clusters will first be recorded in truncate
>>> log and then be returned to global bitmap, which involves TA and TF jdb2/transactions.
>>>
>>> TA's job is to append cluster records to truncate log, by which we can overcome a potential space leak problem.
>>> TF's job is to return clusters to global bitmap.
>>>
>>> It's possible that TA and TF are both committed to JBD but sadly none of them is check-pointed.
>>> So journal replaying need to replay both TA and TF during next mount.
>>> Then there is a record residing in truncate log representing the already released cluster
>>> which has been returned to global bitmap by replaying TF.
>>>
>>> Now the double free shows up.
>>
>> Do you mean that when mount again, truncate log recovery will find
>> record residing in truncate log which already released? But after the
>> TF transaction replayed during mount, truncate log won't be recovered
>> as tl->tl_used is less than tl->tl_count.
> 
> Um, not just truncate log relaying but also involves a jbd2 transaction recording its last append operation.
> That operation may meet the flush condition (ocfs2_truncate_log_needs_flush)
> 
> Thanks,
> Changwei
> 
>>
>> Thanks,
>> Jun
>>
>>>
>>>
>>>>> Then truncate log will be replayed resulting in cluster double free.
>>>>
>>>> Does this problem only cause some error log? As below:
>>>>
>>>> ocfs2_replay_truncate_records
>>>>      ocfs2_free_clusters
>>>>        _ocfs2_free_clusters
>>>>          _ocfs2_free_suballoc_bits
>>>>            ocfs2_block_group_clear_bits
>>>>              "Trying to clear %u bits at offset %u in group descriptor"
>>>>
>>>
>>> Exactly, when the issue occurs, it will be printed as above.
>>>
>>> Thanks,
>>> Changwei
>>>
>>>> Thanks,
>>>> Jun
>>>>
>>>>>
>>>>> To reproduce this issue, just crash the host while punching hole to files.
>>>>>
>>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>>> ---
>>>>>     fs/ocfs2/alloc.c | 15 +++++++++++++++
>>>>>     1 file changed, 15 insertions(+)
>>>>>
>>>>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>>>>> index d1cbb27..29bc777 100644
>>>>> --- a/fs/ocfs2/alloc.c
>>>>> +++ b/fs/ocfs2/alloc.c
>>>>> @@ -6007,6 +6007,7 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>>>>>     	struct buffer_head *data_alloc_bh = NULL;
>>>>>     	struct ocfs2_dinode *di;
>>>>>     	struct ocfs2_truncate_log *tl;
>>>>> +	struct ocfs2_journal *journal = osb->journal;
>>>>>     
>>>>>     	BUG_ON(inode_trylock(tl_inode));
>>>>>     
>>>>> @@ -6027,6 +6028,20 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>>>>>     		goto out;
>>>>>     	}
>>>>>     
>>>>> +	/* Appending truncate log(TA) and and flushing truncate log(TF) are
>>>>> +	 * two separated transactions. They can be both committed but not
>>>>> +	 * checkpointed. If crash occurs then, both two transaction will be
>>>>> +	 * replayed with several already released to global bitmap clusters.
>>>>> +	 * Then truncate log will be replayed resulting in cluster double free.
>>>>> +	 */
>>>>> +	jbd2_journal_lock_updates(journal->j_journal);
>>>>> +	status = jbd2_journal_flush(journal->j_journal);
>>>>> +	jbd2_journal_unlock_updates(journal->j_journal);
>>>>> +	if (status < 0) {
>>>>> +		mlog_errno(status);
>>>>> +		goto out;
>>>>> +	}
>>>>> +
>>>>>     	data_alloc_inode = ocfs2_get_system_file_inode(osb,
>>>>>     						       GLOBAL_BITMAP_SYSTEM_INODE,
>>>>>     						       OCFS2_INVALID_SLOT);
>>>>>
>>>>
>>> .
>>>
>>
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
