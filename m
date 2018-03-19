From: Shichangkuo <shi.changkuo@h3c.com>
Date: Mon, 19 Mar 2018 09:02:42 +0000
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: Fix quota recovery failure on
	unmount
In-Reply-To: <20180228111802.23967-3-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
	<20180228111802.23967-3-jack@suse.cz>
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF35E22F45D2@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,
    This patch will cause kernel crashes while umounting ocfs2.
    After parsing the core file, I find the root reason is as follows:
    osb->recovery_map is freed when recovery thread exited, but following functions still access it by calling ocfs2_inode_lock.
    So, we should disable quotas between ocfs2_truncate_log_shutdown and ocfs2_recovery_exit.
    Am I right?

Thanks
Changkuo

>>>
> When filesystem is unmounted while there is still some recovery work going
> on, it can happen that quotas get disabled before quota recovery is complete
> resulting in failed quota recovery and inconsistent quota accounting. Move
> disabling of recovery in ocfs2_dismount_volume() before disabling of quotas
> to fix this race.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/super.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c index
> ffa4952d432b..14c3d5ee6e24 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1904,6 +1904,13 @@ static void ocfs2_dismount_volume(struct
> super_block *sb, int mnt_err)
>       /* Orphan scan should be stopped as early as possible */
>       ocfs2_orphan_scan_stop(osb);
>
> +     /*
> +      * This will disable recovery and flush any recovery work. This needs
> +      * to happen before disabling quotas as quota recovery needs quotas
> +      * enabled.
> +      */
> +     ocfs2_recovery_exit(osb);
> +
>       ocfs2_disable_quotas(osb);
>
>       /* All dquots should be freed by now */ @@ -1915,9 +1922,6 @@
> static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>
>       ocfs2_truncate_log_shutdown(osb);
>
> -     /* This will disable recovery and flush any recovery work. */
> -     ocfs2_recovery_exit(osb);
> -
>       ocfs2_journal_shutdown(osb);
>
>       ocfs2_sync_blockdev(sb);
> --
> 2.13.6

-------------------------------------------------------------------------------------------------------------------------------------
?????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from New H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
