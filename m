From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Mar 26 20:18:22 2004
Subject: [Ocfs2-devel] resend the new patch for bug 48 to remove incorrect
	autowrap in last mail
In-Reply-To: <4064E04F.6060508@intel.com>
References: <4064E04F.6060508@intel.com>
Message-ID: <20040327021816.GL18020@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
