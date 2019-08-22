From: Changwei Ge <chge@linux.alibaba.com>
Date: Thu, 22 Aug 2019 14:01:03 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] fs/ocfs2/dir.c: remove set but not
 used variables
In-Reply-To: <7f5f74fe-75c6-3915-5f17-8c8dd7128f8b@linux.alibaba.com>
References: <1566393326-25371-1-git-send-email-zhengbin13@huawei.com>
	<1566393326-25371-4-git-send-email-zhengbin13@huawei.com>
	<7f5f74fe-75c6-3915-5f17-8c8dd7128f8b@linux.alibaba.com>
Message-ID: <ed671948-fc94-407a-28df-e75cb767e370@linux.alibaba.com>
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
>> fs/ocfs2/dir.c: In function ocfs2_dx_dir_transfer_leaf:
>> fs/ocfs2/dir.c:3653:42: warning: variable new_list set but not used [-Wunused-but-set-variable]
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


Reviewed-by: Changwei Ge <chge@linux.alibaba.com>


>> ---
>>   fs/ocfs2/dir.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 784426d..bdef72c 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -3636,7 +3636,7 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
>>   	int i, j, num_used;
>>   	u32 major_hash;
>>   	struct ocfs2_dx_leaf *orig_dx_leaf, *new_dx_leaf;
>> -	struct ocfs2_dx_entry_list *orig_list, *new_list, *tmp_list;
>> +	struct ocfs2_dx_entry_list *orig_list, *tmp_list;
>>   	struct ocfs2_dx_entry *dx_entry;
>>
>>   	tmp_list = &tmp_dx_leaf->dl_list;
>> @@ -3645,7 +3645,6 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
>>   		orig_dx_leaf = (struct ocfs2_dx_leaf *) orig_dx_leaves[i]->b_data;
>>   		orig_list = &orig_dx_leaf->dl_list;
>>   		new_dx_leaf = (struct ocfs2_dx_leaf *) new_dx_leaves[i]->b_data;
>> -		new_list = &new_dx_leaf->dl_list;
>>
>>   		num_used = le16_to_cpu(orig_list->de_num_used);
>>
>> --
>> 2.7.4
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
