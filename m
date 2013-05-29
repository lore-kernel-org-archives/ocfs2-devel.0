From: xiaowei.hu <xiaowei.hu@oracle.com>
Date: Wed, 29 May 2013 09:06:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_prep_new_orphaned_file should
 return ret
In-Reply-To: <20130528153523.f8d9d1a3aca72f857d72e185@linux-foundation.org>
References: <1369186996-7127-1-git-send-email-xiaowei.hu@oracle.com>
	<20130528153523.f8d9d1a3aca72f857d72e185@linux-foundation.org>
Message-ID: <51A554AA.7030405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 05/29/2013 06:35 AM, Andrew Morton wrote:
> On Wed, 22 May 2013 09:43:16 +0800 xiaowei.hu at oracle.com wrote:
>
>> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
>>
>> ---
>>   fs/ocfs2/namei.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 50c93a8..422cbe0 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -2216,7 +2216,7 @@ out:
>>   
>>   	brelse(orphan_dir_bh);
>>   
>> -	return 0;
>> +	return ret;
>>   }
>>   
>>   int ocfs2_create_inode_in_orphan(struct inode *dir,
> The patch is missing your signed-off-by.  I added it - please confirm
> this is OK.
It is ok, sorry for missing that, thanks for adding it.
>
> I also pulled together a changelog based on the discussion.  Please do
> provide good changelogs.
The change log looks great!
>
>
> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
> Subject: ocfs2: ocfs2_prep_new_orphaned_file() should return ret
>
> If an error occurs, for example an EIO in __ocfs2_prepare_orphan_dir,
> ocfs2_prep_new_orphaned_file will release the inode_ac, then when the
> caller of ocfs2_prep_new_orphaned_file gets a 0 return, it will refer to a
> NULL ocfs2_alloc_context struct in the following functions.  A kernel
> panic happens.
>
> Signed-off-by: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
> Reviewed-by: shencanquan <shencanquan@huawei.com>
> Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   fs/ocfs2/namei.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN fs/ocfs2/namei.c~ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret fs/ocfs2/namei.c
> --- a/fs/ocfs2/namei.c~ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret
> +++ a/fs/ocfs2/namei.c
> @@ -2216,7 +2216,7 @@ out:
>   
>   	brelse(orphan_dir_bh);
>   
> -	return 0;
> +	return ret;
>   }
>   
>   int ocfs2_create_inode_in_orphan(struct inode *dir,
> _
>
