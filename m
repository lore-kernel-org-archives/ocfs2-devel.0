From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon Mar 29 20:53:23 2004
Subject: [Ocfs2-devel] Can you check the patch for bug 48 and commit?
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4C@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Can you check the patch for bug 48 in the attachment and commit? I haven't found it in the svn tree.

This patch adds lines of signal process code, which makes the thread ocfs_volume_thread() really go to sleep after receive the SIGTERM signal. So, it gives routine ocfs_journal_set_unmounted() a chance to run and check the lock status before thread ocfs_volume_thread() wakes up.

Thanks.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004��3��29�� 11:41
To: joel.becker@oracle.com
Cc: ocfs2-devel
Subject: RE: [Ocfs2-devel] resend the new patch for bug 48 to remove incorrectautowrap in last mail

Hi,

	I failed to prevent Mozilla from converting the TABs to Spaces. So, I have to send the patch in attachment.



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: joel.becker@oracle.com [mailto:joel.becker@oracle.com] 
Sent: 2004��3��27�� 10:18
To: Zhang, Sonic
Cc: ocfs2-devel
Subject: Re: [Ocfs2-devel] resend the new patch for bug 48 to remove incorrect autowrap in last mail

Sonic,
	Please, send in proper kernel style.  TABs, not spaces.

Joel

On Sat, Mar 27, 2004 at 10:00:47AM +0800, Sonic Zhang wrote:
> --- ocfs2.old/src/nm.c.old    2004-03-26 15:21:32.000000000 +0800
> +++ ocfs2/src/nm.c    2004-03-27 09:22:06.176266560 +0800
> @@ -119,6 +119,8 @@
>         OcfsIpcCtxt.recv_sock = NULL;
>     }
> 
> +    OcfsIpcCtxt.task = NULL;
> +    
>     /* signal main thread of ipcdlm's exit */
>     complete (&(OcfsIpcCtxt.complete));
> 
> @@ -250,6 +252,7 @@
>     __u64 cfg_seq_num;
>     int which, pruned, prune_iters = 0;
>     struct buffer_head *bh = NULL;
> +    siginfo_t info;
> 
>     LOG_ENTRY ();
> 
> @@ -409,6 +412,7 @@
>                 OCFS_BH_PUT_DATA(bh);
>                 status = ocfs_write_bh(osb, bh, 0, NULL);
>                 if (status < 0) {
> +                    up(&(osb->publish_lock));
>                     LOG_ERROR_STATUS (status);
>                     goto finally;
>                 }
> @@ -439,6 +443,18 @@
>         }
>         set_current_state (TASK_INTERRUPTIBLE);
>         schedule_timeout (osb->hbt - j);
> +
> +        if (signal_pending(current)) {
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> +            /* ignore the actual signal */
> +            dequeue_signal_lock(current, &current->blocked, &info);
> +#else
> +            spin_lock_irq(&current->sigmask_lock);
> +            /* ignore the actual signal */
> +            dequeue_signal(&current->blocked, &info);
> +            spin_unlock_irq(&current->sigmask_lock);
> +#endif
> +        }
>     }
> 
>         /* Flush all scheduled tasks */
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Nothing is wrong with California that a rise in the ocean level
 wouldn't cure."
        - Ross MacDonald

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-nm-reboot1.patch
Type: application/octet-stream
Size: 1171 bytes
Desc: ocfs2-nm-reboot1.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040330/22864a07/ocfs2-nm-reboot1.obj
