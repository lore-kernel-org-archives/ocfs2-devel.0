From: shencanquan <shencanquan@huawei.com>
Date: Wed, 22 May 2013 10:44:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_prep_new_orphaned_file should
 return ret
In-Reply-To: <519C2F93.3070408@oracle.com>
References: <1369186996-7127-1-git-send-email-xiaowei.hu@oracle.com>
	<519C2E1F.40507@huawei.com> <519C2F93.3070408@oracle.com>
Message-ID: <519C3123.6070908@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/5/22 10:38, xiaowei.hu wrote:
> if there is error happen in , for example EIO in 
> __ocfs2_prepare_orphan_dir, ocfs2_prep_new_orphaned_file will release 
> the inode_ac, the the caller of ocfs2_prep_new_orphaned_file get a 0 
> return, it will refer to a NULL ocfs2_alloc_context struct in the 
> following functions.Kernel panic happens.
Hmm, I see, this patch looks good .
Reviewed-by: shencanquan <shencanquan@huawei.com>
>
> On 05/22/2013 10:31 AM, shencanquan wrote:
>> if return 0,  what's wrong with this?
>> On 2013/5/22 9:43, xiaowei.hu at oracle.com wrote:
>>> From: "Xiaowei.Hu"<xiaowei.hu@oracle.com>
>>>
>>> ---
>>>   fs/ocfs2/namei.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>>> index 50c93a8..422cbe0 100644
>>> --- a/fs/ocfs2/namei.c
>>> +++ b/fs/ocfs2/namei.c
>>> @@ -2216,7 +2216,7 @@ out:
>>>
>>>       brelse(orphan_dir_bh);
>>>
>>> -    return 0;
>>> +    return ret;
>>>   }
>>>
>>>   int ocfs2_create_inode_in_orphan(struct inode *dir,
>>
>>
>
>
>
