From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 19 Nov 2018 09:45:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clear journal dirty flag after
 shutdown journal
In-Reply-To: <5BF2129B.1030307@huawei.com>
References: <20181116085847.10066-1-junxiao.bi@oracle.com>
	<5BF2129B.1030307@huawei.com>
Message-ID: <fe6c513a-ea61-886b-9bcb-3acacfa6c316@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

ocfs2_journal_shutdown() was only invoked during umount, jbd2 will force all uncommitted metadata to disk, there is no set fs readonly for io error in that case.
To reproduce, you need cause storage return io error between ocfs2_journal_toggle_dirty() and jbd2_journal_destroy().
  
1020         if (status == 0) {
1021                 /*
1022                  * Do not toggle if flush was unsuccessful otherwise
1023                  * will leave dirty metadata in a "clean" journal
1024                  */
1025                 status = ocfs2_journal_toggle_dirty(osb, 0, 0);
1026                 if (status < 0)
1027                         mlog_errno(status);
1028         }
1029
1030         /* Shutdown the kernel journal system */
1031         jbd2_journal_destroy(journal->j_journal);

Thanks,
Junxiao.

On 11/19/18 9:32 AM, piaojun wrote:
> Hi Junxiao,
>
> I'm very interested in this bug, and it seems causing read-only if
> involving metadata. Could you help show how to reproduce this problem?
>
> Thanks,
> Jun
>
> On 2018/11/16 16:58, Junxiao Bi wrote:
>> Dirty flag of the journal should be cleared at the last stage of umount,
>> if do it before jbd2_journal_destroy(), then some metadata in uncommitted
>> transaction could be lost due to io error, but as dirty flag of journal
>> was already cleared, we can't find that until run a full fsck. This may
>> cause system panic or other corruption.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>   fs/ocfs2/journal.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index b63c97f4318e..25d678c92fbb 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -1017,6 +1017,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>>   			mlog_errno(status);
>>   	}
>>   
>> +	/* Shutdown the kernel journal system */
>> +	jbd2_journal_destroy(journal->j_journal);
>> +	journal->j_journal = NULL;
>> +
>>   	if (status == 0) {
>>   		/*
>>   		 * Do not toggle if flush was unsuccessful otherwise
>> @@ -1027,10 +1031,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
>>   			mlog_errno(status);
>>   	}
>>   
>> -	/* Shutdown the kernel journal system */
>> -	jbd2_journal_destroy(journal->j_journal);
>> -	journal->j_journal = NULL;
>> -
>>   	OCFS2_I(inode)->ip_open_count--;
>>   
>>   	/* unlock our journal */
>>
