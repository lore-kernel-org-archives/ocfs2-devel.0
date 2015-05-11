From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 11 May 2015 15:48:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not BUG if
 jbd2_journal_dirty_metadata fails
In-Reply-To: <554041B3.2070405@huawei.com>
References: <553F7BA9.1090303@huawei.com> <554041B3.2070405@huawei.com>
Message-ID: <55505EBD.8000101@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/4/29 10:28, Xue jiufei wrote:
> Hi Joseph,
> On 2015/4/28 20:23, Joseph Qi wrote:
>> jbd2_journal_dirty_metadata may fail. Currently it cannot take care of
>> non zero return value and just BUG in ocfs2_journal_dirty.
>> This patch is aborting the handle instead of BUG.
>>
>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>> ---
>>  fs/ocfs2/journal.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index ff53192..4482420 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -775,7 +775,15 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
>>  	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);
>>
>>  	status = jbd2_journal_dirty_metadata(handle, bh);
>> -	BUG_ON(status);
>> +	if (status) {
>> +		mlog_errno(status);
>> +		if (!is_handle_aborted(handle)) {
>> +			handle->h_err = status;
>> +			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
>> +					"Aborting transaction.");
>> +			jbd2_journal_abort_handle(handle);
> The buffers dirtied before are still committed to disk while handle is aborted
> and may cause some inconsistency.
> Maybe the journal should also be set aborted if jbd2_journal_dirty_metadata
> fails like ext4?
Maybe aborting the handle and journal is also not enough.
Though the journal is aborted, the caller still returns success. Then
the user space thinks the operation is successful, but the metadata
cannot be committed to disk due to aborted journal.
Do we also have to return the error in ocfs2_journal_dirty and then
handle it in caller? If so, it must be huge work:)

>> +		}
>> +	}
>>  }
>>
>>  #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
>>
> 
> 
> 
> .
> 
