From: Changwei Ge <chge@linux.alibaba.com>
Date: Thu, 22 Aug 2019 14:00:17 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] fs/ocfs2/namei.c: remove set but not
 used variables
In-Reply-To: <59283b16-8e47-938d-9d28-af17e55b6256@linux.alibaba.com>
References: <1566393326-25371-1-git-send-email-zhengbin13@huawei.com>
	<1566393326-25371-2-git-send-email-zhengbin13@huawei.com>
	<59283b16-8e47-938d-9d28-af17e55b6256@linux.alibaba.com>
Message-ID: <7ab24e9e-a724-a6ac-f004-bf632e7dc624@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 2019/8/22 9:05 ??, Joseph Qi wrote:
>
> On 19/8/21 21:15, zhengbin wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> fs/ocfs2/namei.c: In function ocfs2_create_inode_in_orphan:
>> fs/ocfs2/namei.c:2503:23: warning: variable di set but not used [-Wunused-but-set-variable]
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


Reviewed-by: Changwei Ge <chge@linux.alibaba.com>

>> ---
>>   fs/ocfs2/namei.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 6f8e1c4..8ea51cf 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -2486,7 +2486,6 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>>   	struct inode *inode = NULL;
>>   	struct inode *orphan_dir = NULL;
>>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>> -	struct ocfs2_dinode *di = NULL;
>>   	handle_t *handle = NULL;
>>   	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
>>   	struct buffer_head *parent_di_bh = NULL;
>> @@ -2552,7 +2551,6 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>>   		goto leave;
>>   	}
>>
>> -	di = (struct ocfs2_dinode *)new_di_bh->b_data;
>>   	status = ocfs2_orphan_add(osb, handle, inode, new_di_bh, orphan_name,
>>   				  &orphan_insert, orphan_dir, false);
>>   	if (status < 0) {
>> --
>> 2.7.4
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
