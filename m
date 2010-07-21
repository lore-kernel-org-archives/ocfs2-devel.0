From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 21 Jul 2010 11:26:42 -0700
Subject: [Ocfs2-devel] [PATCH V2] Fix the nested PR lock calling issue
In-Reply-To: <20100721160542.GA19036@linux-jjzhang>
References: <20100721144805.GA12822@linux-jjzhang>	<20100721151701.GA3579@laptop.jp.oracle.com>
	<20100721160542.GA19036@linux-jjzhang>
Message-ID: <4C473BE2.8000608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Why not add _ocfs2_get_acl() that does the same without
taking the cluster locks?

On 07/21/2010 09:05 AM, Jiaju Zhang wrote:
> On Wed, Jul 21, 2010 at 11:17:01PM +0800, Wengang Wang wrote:
>    
>> On 10-07-21 22:48, Jiaju Zhang wrote:
>>      
>>> Hi,
>>>
>>> This is an improved patch for the bug
>>> https://bugzilla.novell.com/show_bug.cgi?id=614332
>>> (also http://oss.oracle.com/bugzilla/show_bug.cgi?id=1278)
>>>
>>> It is a nested PR lock calling issue, the referenced stack trace is
>>> as:
>>> smbd          D ffff8800013d0600     0  9522   5608 0x00000000
>>>   ffff88002ca7fb18 0000000000000282 ffff88002f964500 ffff88002ca7fa98
>>>   ffff8800013d0600 ffff88002ca7fae0 ffff88002f964340 ffff88002f964340
>>>   ffff88002ca7ffd8 ffff88002ca7ffd8 ffff88002f964340 ffff88002f964340
>>> Call Trace:
>>> [<ffffffff80350425>] schedule_timeout+0x175/0x210
>>> [<ffffffff8034f580>] wait_for_common+0xf0/0x210
>>> [<ffffffffa03e12b9>] __ocfs2_cluster_lock+0x3b9/0xa90 [ocfs2]
>>> [<ffffffffa03e7665>] ocfs2_inode_lock_full_nested+0x255/0xdb0 [ocfs2]
>>> [<ffffffffa0446019>] ocfs2_get_acl+0x69/0x120 [ocfs2]
>>> [<ffffffffa0446368>] ocfs2_check_acl+0x28/0x80 [ocfs2]
>>> [<ffffffff800e3507>] acl_permission_check+0x57/0xb0
>>> [<ffffffff800e357d>] generic_permission+0x1d/0xc0
>>> [<ffffffffa03eecea>] ocfs2_permission+0x10a/0x1d0 [ocfs2]
>>> [<ffffffff800e3f65>] inode_permission+0x45/0x100
>>> [<ffffffff800d86b3>] sys_chdir+0x53/0x90
>>> [<ffffffff80007458>] system_call_fastpath+0x16/0x1b
>>> [<00007f34a4ef6927>] 0x7f34a4ef6927
>>>
>>> Many thanks for your review and comments;)
>>>
>>> Thanks,
>>> Jiaju
>>>
>>> Signed-off-by:<jjzhang@suse.de>
>>> Cc: Joel Becker<Joel.Becker@oracle.com>
>>> Cc: Mark Fasheh<mfasheh@suse.com>
>>> Cc: Sunil Mushran<sunil.mushran@oracle.com>
>>> Cc: Tao Ma<tao.ma@oracle.com>
>>> Cc: Tiger Yang<tiger.yang@oracle.com>
>>> Cc: Wengang Wang<wen.gang.wang@oracle.com>
>>> ---
>>>   fs/ocfs2/acl.c |   21 +++++++++++++++++----
>>>   1 files changed, 17 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
>>> index da70229..ecf73f4 100644
>>> --- a/fs/ocfs2/acl.c
>>> +++ b/fs/ocfs2/acl.c
>>> @@ -290,17 +290,30 @@ static int ocfs2_set_acl(handle_t *handle,
>>>
>>>   int ocfs2_check_acl(struct inode *inode, int mask)
>>>   {
>>> -	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
>>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>> +	struct posix_acl *acl;
>>> +	struct buffer_head *di_bh = NULL;
>>> +	int ret = -EAGAIN;
>>> +
>>> +	if (!(osb->s_mount_opt&  OCFS2_MOUNT_POSIX_ACL))
>>> +		return ret;
>>> +
>>> +	ret = ocfs2_read_inode_block(inode,&di_bh);
>>> +	if (ret<  0) {
>>> +		mlog_errno(ret);
>>> +		return ret;
>>> +	}
>>> +
>>> +	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, di_bh);
>>>        
>> > From here on, you need to release di_bh.
>>      
> Oh yes, sorry, I should check the code more closely before sending it
> out;)
>
> Here is the new patch:
>
> Signed-off-by: Jiaju Zhang<jjzhang@suse.de>
> ---
>   fs/ocfs2/acl.c |   23 +++++++++++++++++++----
>   1 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index da70229..a1d25ca 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -290,17 +290,32 @@ static int ocfs2_set_acl(handle_t *handle,
>
>   int ocfs2_check_acl(struct inode *inode, int mask)
>   {
> -	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct posix_acl *acl;
> +	struct buffer_head *di_bh = NULL;
> +	int ret = -EAGAIN;
> +
> +	if (!(osb->s_mount_opt&  OCFS2_MOUNT_POSIX_ACL))
> +		return ret;
> +
> +	ret = ocfs2_read_inode_block(inode,&di_bh);
> +	if (ret<  0) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +
> +	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, di_bh);
> +
> +	brelse(di_bh);
>
>   	if (IS_ERR(acl))
>   		return PTR_ERR(acl);
>   	if (acl) {
> -		int ret = posix_acl_permission(inode, acl, mask);
> +		ret = posix_acl_permission(inode, acl, mask);
>   		posix_acl_release(acl);
> -		return ret;
>   	}
>
> -	return -EAGAIN;
> +	return ret;
>   }
>
>   int ocfs2_acl_chmod(struct inode *inode)
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>    
