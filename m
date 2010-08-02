From: Tao Ma <tao.ma@ORACLE.COM>
Date: Mon, 02 Aug 2010 13:47:23 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Flush drive's caches on
	fdatasync
In-Reply-To: <20100730144704.GA3273@quack.suse.cz>
References: <1280404846-9388-1-git-send-email-jack@suse.cz>
	<4C5233CB.5000600@oracle.com> <20100730144704.GA3273@quack.suse.cz>
Message-ID: <4C565BEB.3020800@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 07/30/2010 10:47 PM, Jan Kara wrote:
> On Fri 30-07-10 10:07:07, Tao Ma wrote:
>> Hi Jan,
>>
>> On 07/29/2010 08:00 PM, Jan Kara wrote:
>>> We have to issue a cache flush during fdatasync even if inode doesn't have
>>> I_DIRTY_DATASYNC set because we still have to get written *data* to disk to
>>> observe fdatasync() guarantees.
>> I am fine with the patch from the code's perspective.
>>
>> But I just noticed the discussion in fsdevel with the subject
>> "relaxed barrier semantics", so with barrier there will be a massive
>> slowdowns according to Christoph. And as ocfs2 is mainly used with
>> some SAN, I guess in most cases the storage will have a battery
>> backed cache, so we may not need this?
>    Yes, barriers are rather heavy operation and battery backed SANs don't
> need them. In this regard, you are right my patch forgot to check the
> OCFS2_MOUNT_BARRIER option. But when the option is set, we must send the
> barrier. Otherwise we risk user's data on crash... Below is a fixed version
> of the patch.
oh, yes, so ack.

Regards,
Tao
>
> 									Honza
> ---
>  From 61c46d394bdc9915554b499f7c3154bde13f3ee5 Mon Sep 17 00:00:00 2001
> From: Jan Kara<jack@suse.cz>
> Date: Thu, 29 Jul 2010 13:32:19 +0200
> Subject: [PATCH 1/2] ocfs2: Flush drive's caches on fdatasync
>
> We have to issue a cache flush during fdatasync even if inode doesn't have
> I_DIRTY_DATASYNC set because we still have to get written *data* to disk to
> observe fdatasync() guarantees.
>
> Signed-off-by: Jan Kara<jack@suse.cz>
> ---
>   fs/ocfs2/file.c |   11 ++++++++++-
>   1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 2b10b36..3ed8efd 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -36,6 +36,7 @@
>   #include<linux/writeback.h>
>   #include<linux/falloc.h>
>   #include<linux/quotaops.h>
> +#include<linux/blkdev.h>
>
>   #define MLOG_MASK_PREFIX ML_INODE
>   #include<cluster/masklog.h>
> @@ -190,8 +191,16 @@ static int ocfs2_sync_file(struct file *file, int datasync)
>   	if (err)
>   		goto bail;
>
> -	if (datasync&&  !(inode->i_state&  I_DIRTY_DATASYNC))
> +	if (datasync&&  !(inode->i_state&  I_DIRTY_DATASYNC)) {
> +		/*
> +		 * We still have to flush drive's caches to get data to the
> +		 * platter
> +		 */
> +		if (osb->s_mount_opt&  OCFS2_MOUNT_BARRIER)
> +			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
> +					   NULL, BLKDEV_IFL_WAIT);
>   		goto bail;
> +	}
>
>   	journal = osb->journal->j_journal;
>   	err = jbd2_journal_force_commit(journal);
