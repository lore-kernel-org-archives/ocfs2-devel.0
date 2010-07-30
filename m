From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 30 Jul 2010 14:47:00 +0800
Subject: [Ocfs2-devel] [PATCH V4] Fix the nested PR lock calling issue
 in ACL
In-Reply-To: <20100728052106.GA9373@linux-jjzhang>
References: <20100728052106.GA9373@linux-jjzhang>
Message-ID: <4C527564.9050909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ACK.

thanks,
tiger

On 07/28/2010 01:21 PM, Jiaju Zhang wrote:
> Hi,
>
> Thanks a lot for all the review and comments so far;) I'd like to send
> the improved (V4) version of this patch.
>
> This patch fixes a deadlock in OCFS2 ACL. We found this bug in OCFS2
> and Samba integration using scenario, the symptom is several smbd
> processes will be hung under heavy workload. Finally we found out it
> is the nested PR lock calling that leads to this deadlock:
>
>   node1        node2
>                gr PR
>                  |
>                  V
>   PR(EX)--->  BAST:OCFS2_LOCK_BLOCKED
>                  |
>                  V
>                rq PR
>                  |
>                  V
>                wait=1
>
> After requesting the 2nd PR lock, the process "smbd" went into D
> state. It can only be woken up when the 1st PR lock's RO holder equals
> zero. There should be an ocfs2_inode_unlock in the calling path later
> on, which can decrement the RO holder. But since it has been in
> uninterruptible sleep, the unlock function has no chance to be called.
>
> The related stack trace is:
> smbd          D ffff8800013d0600     0  9522   5608 0x00000000
>   ffff88002ca7fb18 0000000000000282 ffff88002f964500 ffff88002ca7fa98
>   ffff8800013d0600 ffff88002ca7fae0 ffff88002f964340 ffff88002f964340
>   ffff88002ca7ffd8 ffff88002ca7ffd8 ffff88002f964340 ffff88002f964340
> Call Trace:
> [<ffffffff80350425>] schedule_timeout+0x175/0x210
> [<ffffffff8034f580>] wait_for_common+0xf0/0x210
> [<ffffffffa03e12b9>] __ocfs2_cluster_lock+0x3b9/0xa90 [ocfs2]
> [<ffffffffa03e7665>] ocfs2_inode_lock_full_nested+0x255/0xdb0 [ocfs2]
> [<ffffffffa0446019>] ocfs2_get_acl+0x69/0x120 [ocfs2]
> [<ffffffffa0446368>] ocfs2_check_acl+0x28/0x80 [ocfs2]
> [<ffffffff800e3507>] acl_permission_check+0x57/0xb0
> [<ffffffff800e357d>] generic_permission+0x1d/0xc0
> [<ffffffffa03eecea>] ocfs2_permission+0x10a/0x1d0 [ocfs2]
> [<ffffffff800e3f65>] inode_permission+0x45/0x100
> [<ffffffff800d86b3>] sys_chdir+0x53/0x90
> [<ffffffff80007458>] system_call_fastpath+0x16/0x1b
> [<00007f34a4ef6927>] 0x7f34a4ef6927
>
> For details, please see:
> https://bugzilla.novell.com/show_bug.cgi?id=614332 and
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1278
>
> Signed-off-by: Jiaju Zhang<jjzhang@suse.de>
> Acked-by: Mark Fasheh<mfasheh@suse.com>
> ---
>   fs/ocfs2/acl.c |   24 +++++++++++++++++++++---
>   1 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index da70229..c34efb2 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -290,12 +290,30 @@ static int ocfs2_set_acl(handle_t *handle,
>
>   int ocfs2_check_acl(struct inode *inode, int mask)
>   {
> -	struct posix_acl *acl = ocfs2_get_acl(inode, ACL_TYPE_ACCESS);
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct buffer_head *di_bh = NULL;
> +	struct posix_acl *acl;
> +	int ret = -EAGAIN;
>
> -	if (IS_ERR(acl))
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
> +
> +	if (IS_ERR(acl)) {
> +		mlog_errno(PTR_ERR(acl));
>   		return PTR_ERR(acl);
> +	}
>   	if (acl) {
> -		int ret = posix_acl_permission(inode, acl, mask);
> +		ret = posix_acl_permission(inode, acl, mask);
>   		posix_acl_release(acl);
>   		return ret;
>   	}
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>    
