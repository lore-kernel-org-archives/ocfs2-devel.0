From: Richard Weinberger <richard@nod.at>
Date: Fri, 13 Mar 2015 09:15:59 +0100
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
 status for checking error
In-Reply-To: <CAHb8M2AMPhDwMjgvrT=igUCcCH4CgRHid9683kSjFAWHnpNQZw@mail.gmail.com>
References: <20150227234840.GA12922@devel.8.8.4.4>
	<CAHb8M2AMPhDwMjgvrT=igUCcCH4CgRHid9683kSjFAWHnpNQZw@mail.gmail.com>
Message-ID: <55029CBF.5060400@nod.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: DaeSeok Youn <daeseok.youn@gmail.com>, mfasheh@suse.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Joel Becker <jlbec@evilplan.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>

Am 13.03.2015 um 04:59 schrieb DaeSeok Youn:
> Hi,
> 
> This patch have been pending for 2 weeks.
> Do I need to check other things?
> 
> please, check for me.

I cannot speak for OCFS2 folks. But maybe you can give them a
better feeling if you proof that your patch is tested.

Thanks,
//richard

> Thanks!
> 
> regards,
> Daeseok Youn
> 
> 2015-02-28 8:48 GMT+09:00 Daeseok Youn <daeseok.youn@gmail.com>:
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
>>         struct ocfs2_dir_entry *de, *de1;
>>         struct ocfs2_dinode *di = (struct ocfs2_dinode *)parent_fe_bh->b_data;
>>         struct super_block *sb = dir->i_sb;
>> -       int retval, status;
>> +       int retval;
>>         unsigned int size = sb->s_blocksize;
>>         struct buffer_head *insert_bh = lookup->dl_leaf_bh;
>>         char *data_start = insert_bh->b_data;
>> @@ -1695,22 +1695,22 @@ int __ocfs2_add_entry(handle_t *handle,
>>                         }
>>
>>                         if (insert_bh == parent_fe_bh)
>> -                               status = ocfs2_journal_access_di(handle,
>> +                               retval = ocfs2_journal_access_di(handle,
>>                                                                  INODE_CACHE(dir),
>>                                                                  insert_bh,
>>                                                                  OCFS2_JOURNAL_ACCESS_WRITE);
>>                         else {
>> -                               status = ocfs2_journal_access_db(handle,
>> +                               retval = ocfs2_journal_access_db(handle,
>>                                                                  INODE_CACHE(dir),
>>                                                                  insert_bh,
>>                                               OCFS2_JOURNAL_ACCESS_WRITE);
>>
>>                                 if (ocfs2_dir_indexed(dir)) {
>> -                                       status = ocfs2_dx_dir_insert(dir,
>> +                                       retval = ocfs2_dx_dir_insert(dir,
>>                                                                 handle,
>>                                                                 lookup);
>> -                                       if (status) {
>> -                                               mlog_errno(status);
>> +                                       if (retval) {
>> +                                               mlog_errno(retval);
>>                                                 goto bail;
>>                                         }
>>                                 }
>> --
>> 1.7.1
>>
