From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 6 Jun 2013 20:20:21 -0700 (PDT)
Subject: [Ocfs2-devel] [PATCH] Remove unecessary variable
	needs_checkpoint
In-Reply-To: <CAJtY7HUA744Gy_qVo1UePWFzVrMjV9-S_ZCJsETizHbZbXAeog@mail.gmail.com>
References: <CAJtY7HUA744Gy_qVo1UePWFzVrMjV9-S_ZCJsETizHbZbXAeog@mail.gmail.com>
Message-ID: <51B15175.1090403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for the fix.

I can not apply this patch due to a corruption, checkpatch.pl warning me with:

ERROR: patch seems to be corrupt (line wrapped?)
#36: FILE: fs/ocfs2/super.c:285:
*osb, char *buf, int len)

WARNING: please, no spaces at the start of a line
#41: FILE: fs/ocfs2/super.c:289:
+ "%10s => Pid: %d  Interval: %lu\n", "Commit",$

WARNING: please, no spaces at the start of a line
#45: FILE: fs/ocfs2/super.c:291:
+ osb->osb_commit_interval);$

total: 1 errors, 2 warnings, 33 lines checked

ab.patch has style problems, please review.

-Jeff
On 06/07/2013 09:41 AM, Goldwyn Rodrigues wrote:

> Code cleanup: needs_checkpoint is only assigned but never used to check.
> Delete the variable.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> ---
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index a3385b6..0a99273 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -200,7 +200,6 @@ void ocfs2_complete_quota_recovery(struct ocfs2_super *osb);
> 
>  static inline void ocfs2_start_checkpoint(struct ocfs2_super *osb)
>  {
> - atomic_set(&osb->needs_checkpoint, 1);
>   wake_up(&osb->checkpoint_event);
>  }
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index d355e6e..3a90347 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -347,7 +347,6 @@ struct ocfs2_super
>   struct task_struct *recovery_thread_task;
>   int disable_recovery;
>   wait_queue_head_t checkpoint_event;
> - atomic_t needs_checkpoint;
>   struct ocfs2_journal *journal;
>   unsigned long osb_commit_interval;
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 01b8516..854d809 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -286,10 +286,9 @@ static int ocfs2_osb_dump(struct ocfs2_super
> *osb, char *buf, int len)
>   spin_unlock(&osb->osb_lock);
> 
>   out += snprintf(buf + out, len - out,
> - "%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
> + "%10s => Pid: %d  Interval: %lu\n", "Commit",
>   (osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
> - osb->osb_commit_interval,
> - atomic_read(&osb->needs_checkpoint));
> + osb->osb_commit_interval);
> 
>   out += snprintf(buf + out, len - out,
>   "%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
> @@ -2154,7 +2153,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>   }
> 
>   init_waitqueue_head(&osb->checkpoint_event);
> - atomic_set(&osb->needs_checkpoint, 0);
> 
>   osb->s_atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
