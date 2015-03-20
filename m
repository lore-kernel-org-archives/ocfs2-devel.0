From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Fri, 20 Mar 2015 11:34:25 +0900
Subject: [Ocfs2-devel] [PATCH 3/4 RESEND] ocfs2: need to handle error
 for ocfs2_journal_access_di() call
In-Reply-To: <550AAC4B.8000505@huawei.com>
References: <20150227235100.GA12964@devel.8.8.4.4>
	<550AAC4B.8000505@huawei.com>
Message-ID: <CAHb8M2DMYK8weUSvYOuk5AhsQrFnq3NaqJYG7hEgre=wKVvTOA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@huawei.com>
Cc: mfasheh@suse.com, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard.weinberger@gmail.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>

OK.

I will send this patch again.
This patch will be based on https://lkml.org/lkml/2015/2/27/655

thanks

regards,
Daeseok Youn

2015-03-19 20:00 GMT+09:00 Joseph Qi <joseph.qi@huawei.com>:
> On 2015/2/28 7:51, Daeseok Youn wrote:
>> There is no error handle when ocfs2_journal_access_di() is failed.
>> And also it doesn't need to call ocfs2_dx_dir_insert() when
>> ocfs2_journal_access_db() is failed.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> RESEND: this patch rebased by 1/4
>>
>>  fs/ocfs2/dir.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index c1ab24f..c63f2b6 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -1703,15 +1703,15 @@ int __ocfs2_add_entry(handle_t *handle,
>>                                                                insert_bh,
>>                                             OCFS2_JOURNAL_ACCESS_WRITE);
>>
>> -                             if (ocfs2_dir_indexed(dir)) {
>> +                             if (!retval && ocfs2_dir_indexed(dir))
>>                                       retval = ocfs2_dx_dir_insert(dir,
>>                                                               handle,
>>                                                               lookup);
>> -                                     if (retval)
>> -                                             goto bail;
>> -                             }
>>                       }
>>
>> +                     if (retval)
>> +                             goto bail;
>> +
>>                       /* By now the buffer is marked for journaling */
>>                       offset += le16_to_cpu(de->rec_len);
>>                       if (le64_to_cpu(de->inode)) {
>>
> I agree with you that we should do the corresponding check.
> But I don't think we need remove the mlog as described in my previous
> mail.
>
