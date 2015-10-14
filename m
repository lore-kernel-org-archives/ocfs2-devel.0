From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Wed, 14 Oct 2015 07:49:45 +0000
Subject: [Ocfs2-devel] Ocfs2-devel Digest, Vol 138, Issue 31 review
References: <mailman.1701.1440805574.13254.ocfs2-devel@oss.oracle.com>
Message-ID: <2015101415485251084042@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 is often used in high-availaibility systems, This patch enhances robustness for the filesystem.
but storage network is unstable?it still triggers a panic? such as ocfs2_start_trans -> __ocfs2_abort ->panic.
The 's_mount_opt' should depend on the mount option set, If errors=continue is set,
mark as a EIO error, change OCFS2_MOUNT_ERRORS_PANIC to OCFS2_MOUNT_ERRORS_CONT in __ocfs2_abort;
it's better than forcing a panic without decreasing availability,errors=continue seems be well to me.

Finally, any feedback about this process (positive or negative) would be greatly appreciated.

   Aug 11 11:32:25 cvknode73 kernel: [678904.787906] (pool,23256,12):ocfs2_start_trans:367 ERROR: status = -30
Aug 11 11:32:25 cvknode73 kernel: [678904.825046] CPU: 12 PID: 23256 Comm: pool Tainted: GF W IO 3.13.6 #1
Aug 11 11:32:25 cvknode73 kernel: [678904.825050] Hardware name: HP ProLiant BL460c G7, BIOS I27 12/03/2012
Aug 11 11:32:25 cvknode73 kernel: [678904.825054] ffffffffffffffe2 ffff88108c945a88 ffffffff81750690 ffff88180bacfff0
Aug 11 11:32:25 cvknode73 kernel: [678904.825064] ffff88174196d000 ffff88108c945ad8 ffffffffa052f667 ffffffffffffffe2
Aug 11 11:32:25 cvknode73 kernel: [678904.825072] 0000000000001000 ffff88108c945b58 ffff88175e870000 ffff8811ada4f000
Aug 11 11:32:25 cvknode73 kernel: [678904.825087] Call Trace:
Aug 11 11:32:25 cvknode73 kernel: [678904.825103] [<ffffffff81750690>] dump_stack+0x46/0x58
Aug 11 11:32:25 cvknode73 kernel: [678904.825154] [<ffffffffa052f667>] ocfs2_start_trans+0x1d7/0x200 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825183] [<ffffffffa0505b60>] ocfs2_write_begin_nolock+0xda0/0x1c70 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825216] [<ffffffffa052b7cb>] ? ocfs2_read_inode_block_full+0x3b/0x60 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825248] [<ffffffffa051a82f>] ? ocfs2_inode_lock_full_nested+0x52f/0xc60 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825277] [<ffffffffa0516060>] ? ocfs2_should_refresh_lock_res+0x80/0x190 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825304] [<ffffffffa0506b36>] ocfs2_write_begin+0x106/0x230 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825330] [<ffffffffa05180ab>] ? __ocfs2_cluster_unlock.isra.27+0x9b/0xe0 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825342] [<ffffffff8115342b>] generic_file_buffered_write+0xfb/0x280
Aug 11 11:32:25 cvknode73 kernel: [678904.825370] [<ffffffffa051a1c5>] ? ocfs2_rw_lock+0x75/0x1b0 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825398] [<ffffffffa0527f3f>] ocfs2_file_aio_write+0x79f/0x830 [ocfs2]
Aug 11 11:32:25 cvknode73 kernel: [678904.825407] [<ffffffff811c14ba>] do_sync_write+0x5a/0x90
Aug 11 11:32:25 cvknode73 kernel: [678904.825413] [<ffffffff811c1fc5>] vfs_write+0xc5/0x1f0
Aug 11 11:32:25 cvknode73 kernel: [678904.825418] [<ffffffff811c24c2>] SyS_write+0x52/0xa0
Aug 11 11:32:25 cvknode73 kernel: [678904.825426] [<ffffffff8176106d>] system_call_fastpath+0x1a/0x1f
Aug 11 11:32:25 cvknode73 kernel: [678904.825431] OCFS2: abort (device sdu): ocfs2_start_trans: Detected aborted journal

________________________________
zhangguanghui

Message: 8
Date: Fri, 28 Aug 2015 16:45:44 -0700
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [Ocfs2-devel] [patch 04/28] ocfs2: add errors=continue
To: akpm at linux-foundation.org
Cc: ocfs2-devel at oss.oracle.com, rgoldwyn at suse.com
Message-ID: <20150828234544.GN1145@wotan.suse.de>
Content-Type: text/plain; charset=us-ascii

On Wed, Aug 26, 2015 at 03:11:29PM -0700, Andrew Morton wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Subject: ocfs2: add errors=continue
>
> OCFS2 is often used in high-availaibility systems.  However, ocfs2
> converts the filesystem to read-only at the drop of the hat.  This may not
> be necessary, since turning the filesystem read-only would affect other
> running processes as well, decreasing availability.
>
> This attempt is to add errors=continue, which would return the EIO to the
> calling process and terminate furhter processing so that the filesystem is
> not corrupted further.  However, the filesystem is not converted to
> read-only.
>
> As a future plan, I intend to create a small utility or extend fsck.ocfs2
> to fix small errors such as in the inode.  The input to the utility such
> as the inode can come from the kernel logs so we don't have to schedule a
> downtime for fixing small-enough errors.
>
> The patch changes the ocfs2_error to return an error.  The error returned
> depends on the mount option set.  If none is set, the default is to turn
> the filesystem read-only.
>
> Perhaps errors=continue is not the best option name.  Historically it is
> used for making an attempt to progress in the current process itself.
> Should we call it errors=eio?  or errors=killproc?  Suggestions/Comments
> welcome.

errors=continue seems fine to me, thanks for this Goldwyn.


>
> Sources are available at:
> https://github.com/goldwynr/linux/tree/error-cont
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>


> ---
>
>  fs/ocfs2/ocfs2.h |    2 +
>  fs/ocfs2/super.c |   59 ++++++++++++++++++++++++++++++++-------------
>  fs/ocfs2/super.h |    2 -
>  3 files changed, 45 insertions(+), 18 deletions(-)
>
> diff -puN fs/ocfs2/ocfs2.h~add-errors=continue fs/ocfs2/ocfs2.h
> --- a/fs/ocfs2/ocfs2.h~add-errors=continue
> +++ a/fs/ocfs2/ocfs2.h
> @@ -286,6 +286,8 @@ enum ocfs2_mount_options
>       OCFS2_MOUNT_HB_GLOBAL = 1 << 14, /* Global heartbeat */
>
>       OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
> +     OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
> +     OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
>  };
>
>  #define OCFS2_OSB_SOFT_RO    0x0001
> diff -puN fs/ocfs2/super.c~add-errors=continue fs/ocfs2/super.c
> --- a/fs/ocfs2/super.c~add-errors=continue
> +++ a/fs/ocfs2/super.c
> @@ -192,6 +192,7 @@ enum {
>       Opt_resv_level,
>       Opt_dir_resv_level,
>       Opt_journal_async_commit,
> +     Opt_err_cont,
>       Opt_err,
>  };
>
> @@ -224,6 +225,7 @@ static const match_table_t tokens = {
>       {Opt_resv_level, "resv_level=%u"},
>       {Opt_dir_resv_level, "dir_resv_level=%u"},
>       {Opt_journal_async_commit, "journal_async_commit"},
> +     {Opt_err_cont, "errors=continue"},
>       {Opt_err, NULL}
>  };
>
> @@ -1330,10 +1332,19 @@ static int ocfs2_parse_options(struct su
>                       mopt->mount_opt |= OCFS2_MOUNT_NOINTR;
>                       break;
>               case Opt_err_panic:
> +                     mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_CONT;
> +                     mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_ROFS;
>                       mopt->mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
>                       break;
>               case Opt_err_ro:
> +                     mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_CONT;
>                       mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
> +                     mopt->mount_opt |= OCFS2_MOUNT_ERRORS_ROFS;
> +                     break;
> +             case Opt_err_cont:
> +                     mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_ROFS;
> +                     mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
> +                     mopt->mount_opt |= OCFS2_MOUNT_ERRORS_CONT;
>                       break;
>               case Opt_data_ordered:
>                       mopt->mount_opt &= ~OCFS2_MOUNT_DATA_WRITEBACK;
> @@ -1530,6 +1541,8 @@ static int ocfs2_show_options(struct seq
>
>       if (opts & OCFS2_MOUNT_ERRORS_PANIC)
>               seq_printf(s, ",errors=panic");
> +     else if (opts & OCFS2_MOUNT_ERRORS_CONT)
> +             seq_printf(s, ",errors=continue");
>       else
>               seq_printf(s, ",errors=remount-ro");
>
> @@ -2539,31 +2552,43 @@ static void ocfs2_delete_osb(struct ocfs
>       memset(osb, 0, sizeof(struct ocfs2_super));
>  }
>
> -/* Put OCFS2 into a readonly state, or (if the user specifies it),
> - * panic(). We do not support continue-on-error operation. */
> -static void ocfs2_handle_error(struct super_block *sb)
> +/* Depending on the mount option passed, perform one of the following:
> + * Put OCFS2 into a readonly state (default)
> + * Return EIO so that only the process errs
> + * Fix the error as if fsck.ocfs2 -y
> + * panic
> + */
> +static int ocfs2_handle_error(struct super_block *sb)
>  {
>       struct ocfs2_super *osb = OCFS2_SB(sb);
> +     int rv = 0;
> +
> +     ocfs2_set_osb_flag(osb, OCFS2_OSB_ERROR_FS);
> +     pr_crit("On-disk corruption discovered. "
> +             "Please run fsck.ocfs2 once the filesystem is unmounted.\n");
>
> -     if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_PANIC)
> +     if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_PANIC) {
>               panic("OCFS2: (device %s): panic forced after error\n",
>                     sb->s_id);
> +     } else if (osb->s_mount_opt & OCFS2_MOUNT_ERRORS_CONT) {
> +             pr_crit("OCFS2: Returning error to the calling process.\n");
> +             rv = -EIO;
> +     } else { /* default option */
> +             rv = -EROFS;
> +             if (sb->s_flags & MS_RDONLY &&
> +                             (ocfs2_is_soft_readonly(osb) ||
> +                              ocfs2_is_hard_readonly(osb)))
> +                     return rv;
>
> -     ocfs2_set_osb_flag(osb, OCFS2_OSB_ERROR_FS);
> -
> -     if (sb->s_flags & MS_RDONLY &&
> -         (ocfs2_is_soft_readonly(osb) ||
> -          ocfs2_is_hard_readonly(osb)))
> -             return;
> +             pr_crit("OCFS2: File system is now read-only.\n");
> +             sb->s_flags |= MS_RDONLY;
> +             ocfs2_set_ro_flag(osb, 0);
> +     }
>
> -     printk(KERN_CRIT "File system is now read-only due to the potential "
> -            "of on-disk corruption. Please run fsck.ocfs2 once the file "
> -            "system is unmounted.\n");
> -     sb->s_flags |= MS_RDONLY;
> -     ocfs2_set_ro_flag(osb, 0);
> +     return rv;
>  }
>
> -void __ocfs2_error(struct super_block *sb, const char *function,
> +int __ocfs2_error(struct super_block *sb, const char *function,
>                 const char *fmt, ...)
>  {
>       struct va_format vaf;
> @@ -2580,7 +2605,7 @@ void __ocfs2_error(struct super_block *s
>
>       va_end(args);
>
> -     ocfs2_handle_error(sb);
> +     return ocfs2_handle_error(sb);
>  }
>
>  /* Handle critical errors. This is intentionally more drastic than
> diff -puN fs/ocfs2/super.h~add-errors=continue fs/ocfs2/super.h
> --- a/fs/ocfs2/super.h~add-errors=continue
> +++ a/fs/ocfs2/super.h
> @@ -32,7 +32,7 @@ int ocfs2_publish_get_mount_state(struct
>                                 int node_num);
>
>  __printf(3, 4)
> -void __ocfs2_error(struct super_block *sb, const char *function,
> +int __ocfs2_error(struct super_block *sb, const char *function,
>                  const char *fmt, ...);
>
>  #define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
> _
--
Mark Fasheh



------------------------------

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

End of Ocfs2-devel Digest, Vol 138, Issue 31
********************************************

-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151014/36d59342/attachment-0001.html 
