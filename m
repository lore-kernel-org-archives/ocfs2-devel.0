From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Fri, 20 Mar 2015 11:22:53 +0900
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
 status for checking error
In-Reply-To: <550A6BB3.5000901@huawei.com>
References: <20150227234840.GA12922@devel.8.8.4.4>
	<550A6BB3.5000901@huawei.com>
Message-ID: <CAHb8M2AXygqC5tJZrE7qKu_9+0rB4qzQFvM5uAR9F80X01Rx8A@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@huawei.com>
Cc: mfasheh@suse.com, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard.weinberger@gmail.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>

2015-03-19 15:24 GMT+09:00 Joseph Qi <joseph.qi@huawei.com>:
> Looks good to me.
>
> On 2015/2/28 7:48, Daeseok Youn wrote:
>> The use of 'status' in __ocfs2_add_entry() can return wrong
>> status when some functions are failed.
>>
>> If ocfs2_journal_access_db() in __ocfs2_add_entry() is failed,
>> that status is saved to 'status' but return variable is 'retval'
>> which is saved 'success' status. In case of this,  __ocfs2_add_entry()
>> is failed but can be returned as 'success'.
>>
>> So replace 'status' with 'retval'.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Hi, Joseph.

Thanks for review this patch. I have actually tried to set this file
system on my machine with qemu but I didn't success, yet.

Regards,
Daeseok Youn.

>> ---
>> V2 : update changelog
>>
>>  fs/ocfs2/dir.c |   12 ++++++------
>>  1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index b08050b..1478a50 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -1617,7 +1617,7 @@ int __ocfs2_add_entry(handle_t *handle,
>>       struct ocfs2_dir_entry *de, *de1;
>>       struct ocfs2_dinode *di = (struct ocfs2_dinode *)parent_fe_bh->b_data;
>>       struct super_block *sb = dir->i_sb;
>> -     int retval, status;
>> +     int retval;
>>       unsigned int size = sb->s_blocksize;
>>       struct buffer_head *insert_bh = lookup->dl_leaf_bh;
>>       char *data_start = insert_bh->b_data;
>> @@ -1695,22 +1695,22 @@ int __ocfs2_add_entry(handle_t *handle,
>>                       }
>>
>>                       if (insert_bh == parent_fe_bh)
>> -                             status = ocfs2_journal_access_di(handle,
>> +                             retval = ocfs2_journal_access_di(handle,
>>                                                                INODE_CACHE(dir),
>>                                                                insert_bh,
>>                                                                OCFS2_JOURNAL_ACCESS_WRITE);
>>                       else {
>> -                             status = ocfs2_journal_access_db(handle,
>> +                             retval = ocfs2_journal_access_db(handle,
>>                                                                INODE_CACHE(dir),
>>                                                                insert_bh,
>>                                             OCFS2_JOURNAL_ACCESS_WRITE);
>>
>>                               if (ocfs2_dir_indexed(dir)) {
>> -                                     status = ocfs2_dx_dir_insert(dir,
>> +                                     retval = ocfs2_dx_dir_insert(dir,
>>                                                               handle,
>>                                                               lookup);
>> -                                     if (status) {
>> -                                             mlog_errno(status);
>> +                                     if (retval) {
>> +                                             mlog_errno(retval);
>>                                               goto bail;
>>                                       }
>>                               }
>>
>
>
