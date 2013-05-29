From: shencanquan <shencanquan@huawei.com>
Date: Wed, 29 May 2013 16:12:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: should not use le32_add_cpu to set
 ocfs2_dinode i_flags
In-Reply-To: <51A5B4E4.20901@oracle.com>
References: <51A56B1C.30606@huawei.com> <51A5B4E4.20901@oracle.com>
Message-ID: <51A5B867.4020803@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/5/29 15:57, Jeff Liu wrote:
> Thanks for your patch, Joseph.
>
> On 05/29/2013 10:42 AM, Joseph Qi wrote:
>
>> If we use le32_add_cpu to set ocfs2_dinode i_flags, it may lead to the
>> corresponding flag corrupted. So we should change it to bitwise and/or
>> operation.
>>
>> Signed-off-by: Joseph Qi<joseph.qi@huawei.com>
>> ---
>>   fs/ocfs2/namei.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 04ee1b5..3a5269a 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -522,7 +522,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
>>
>>   	fe->i_last_eb_blk = 0;
>>   	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
>> -	le32_add_cpu(&fe->i_flags, OCFS2_VALID_FL);
>> +	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
>>   	fe->i_atime = fe->i_ctime = fe->i_mtime =
>>   		cpu_to_le64(CURRENT_TIME.tv_sec);
>>   	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
>> @@ -2044,7 +2044,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>>   		goto leave;
>>   	}
>>
>> -	le32_add_cpu(&fe->i_flags, OCFS2_ORPHANED_FL);
>> +	fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
>>   	OCFS2_I(inode)->ip_flags&= ~OCFS2_INODE_SKIP_ORPHAN_DIR;
>>
>>   	/* Record which orphan dir our inode now resides
>> @@ -2434,7 +2434,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>   	}
>>
>>   	di = (struct ocfs2_dinode *)di_bh->b_data;
>> -	le32_add_cpu(&di->i_flags, -OCFS2_ORPHANED_FL);
>> +	di->i_flags&= cpu_to_le32(~OCFS2_ORPHANED_FL);
> Hmm? This is wrong.  Instead it should be:
> di->i_flags&= ~cpu_to_le32(OCFS2_ORPHANED_FL);

  in ocfs2_remove_inode function , it has the following code:
     di->i_dtime = cpu_to_le64(CURRENT_TIME.tv_sec);
     di->i_flags &= cpu_to_le32(~(OCFS2_VALID_FL | OCFS2_ORPHANED_FL));

I think at first clear the flag and then convert to the little end.
>>   	di->i_orphaned_slot = 0;
>>   	set_nlink(inode, 1);
>>   	ocfs2_set_links_count(di, inode->i_nlink);
>
> -Jeff
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
