From: Marty Sweet <msweet.dev@gmail.com>
Date: Wed, 19 Feb 2014 17:56:35 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix quota file corruption
In-Reply-To: <20140219144809.GA11275@quack.suse.cz>
References: <1392815462-9522-1-git-send-email-jack@suse.cz>
	<20140219144809.GA11275@quack.suse.cz>
Message-ID: <CALoaWF7+dBMxJmTMm2w46uZnDVJBfZt+AbVN817s2SFsQMx76w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

What errors do you see regarding corrupted quotas, something like below?
kernel: [119890.305935] __quota_error: 3 callbacks suppressed
kernel: [119890.305941] Quota error (device dm-8): find_free_dqentry:
Data block full but it shouldn't
kernel: [119890.306071] Quota error (device dm-8): qtree_write_dquot:
Error -5 occurred while creating quota
kernel: [119890.306203] (smbd,25964,2):ocfs2_acquire_dquot:817 ERROR:
status = -5

There seems to be a lack of documentation regarding this issue, let me
know if you would like me to test anything for you.

Marty

On Wed, Feb 19, 2014 at 2:48 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 19-02-14 14:11:02, Jan Kara wrote:
>> Global quota files are accessed from different nodes and reading and
>> writing of these files happens via block device page cache. Thus even
>> though the access between nodes is properly serialized by quota file's
>> inode lock we cannot rely on consistency of block device page cache
>> between nodes. Indeed currently it is possible to corrupt quota files by
>> creating and deleting quota structures from two nodes in parallel. Fix
>> the problem by using OCFS2_BH_IGNORE_CACHE mount option when reading
>> from quota file.
>>
>> CC: Goldwyn Rodrigues <rgoldwyn@suse.de>
>> CC: Mark Fasheh <mfasheh@suse.de>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/ocfs2/quota_global.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>>   This is a quick fix for quota file corruption I have found during my testing
>> (to be used for 3.13 and -stable kernels). Longer term we likely want to do
>> something more clever. Ideally we would invalidate relevant blocks from buffer
>> cache when node releases quota file's inode lock (similarly as we do it for
>> page cache). I wanted to do it similarly as for e.g. extent tree blocks but
>> I failed to find how consistency of those between nodes is achieved. Can
>> anyone point me in the right direction? Thanks in advance.
>   Hum, so this likely isn't the whole story because I can still see the
> corruption. At least I've now found the metadata cache and basically
> understand how it works so I'm now reading code around that and trying to
> understand what screws up quota code...
>
>                                                                 Honza
>
>>
>> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
>> index aaa50611ec66..f1f0cca15db6 100644
>> --- a/fs/ocfs2/quota_global.c
>> +++ b/fs/ocfs2/quota_global.c
>> @@ -151,7 +151,8 @@ int ocfs2_read_quota_phys_block(struct inode *inode, u64 p_block,
>>       int rc;
>>
>>       *bhp = NULL;
>> -     rc = ocfs2_read_blocks(INODE_CACHE(inode), p_block, 1, bhp, 0,
>> +     rc = ocfs2_read_blocks(INODE_CACHE(inode), p_block, 1, bhp,
>> +                            OCFS2_BH_IGNORE_CACHE,
>>                              ocfs2_validate_quota_block);
>>       if (rc)
>>               mlog_errno(rc);
>> --
>> 1.8.1.4
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel



-- 
Marty
