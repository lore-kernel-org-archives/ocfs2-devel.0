From: Changwei Ge <chge@linux.alibaba.com>
Date: Thu, 22 Aug 2019 14:00:44 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] fs/ocfs2/file.c: remove set but not
 used variables
In-Reply-To: <4cb1ecda-b8a1-29d0-d013-f8a5e9953c43@linux.alibaba.com>
References: <1566393326-25371-1-git-send-email-zhengbin13@huawei.com>
	<1566393326-25371-3-git-send-email-zhengbin13@huawei.com>
	<4cb1ecda-b8a1-29d0-d013-f8a5e9953c43@linux.alibaba.com>
Message-ID: <b9c895f8-8580-f245-0302-2b63ad2f5a2b@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 2019/8/22 9:07 ??, Joseph Qi wrote:
>
> On 19/8/21 21:15, zhengbin wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> fs/ocfs2/file.c: In function ocfs2_prepare_inode_for_write:
>> fs/ocfs2/file.c:2143:9: warning: variable end set but not used [-Wunused-but-set-variable]
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


Reviewed-by: Changwei Ge <chge@linux.alibaba.com>


>> ---
>>   fs/ocfs2/file.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 4435df3..aeb3362 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2126,7 +2126,6 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
>>   	struct dentry *dentry = file->f_path.dentry;
>>   	struct inode *inode = d_inode(dentry);
>>   	struct buffer_head *di_bh = NULL;
>> -	loff_t end;
>>
>>   	/*
>>   	 * We start with a read level meta lock and only jump to an ex
>> @@ -2190,8 +2189,6 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
>>   			}
>>   		}
>>
>> -		end = pos + count;
>> -
>>   		ret = ocfs2_check_range_for_refcount(inode, pos, count);
>>   		if (ret == 1) {
>>   			ocfs2_inode_unlock(inode, meta_level);
>> --
>> 2.7.4
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
