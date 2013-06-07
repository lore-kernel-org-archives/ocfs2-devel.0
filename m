From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 7 Jun 2013 15:35:53 -0700
Subject: [Ocfs2-devel] [PATCH] Remove unecessary variable
	needs_checkpoint
In-Reply-To: <51B1CD65.1070508@oracle.com>
References: <20130607114918.GA3332@shrek.cartoons>
	<51B1CD65.1070508@oracle.com>
Message-ID: <20130607223552.GC5531@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Joel Becker <jlbec@evilplan.org>

On Fri, Jun 07, 2013 at 08:09:09PM +0800, Jeff Liu wrote:
> On 06/07/2013 07:49 PM, Goldwyn Rodrigues wrote:
> 
> > Code cleanup: needs_checkpoint is only assigned but never used to check.
> > Delete the variable.
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > --- 
> > diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> > index a3385b6..0a99273 100644
> > --- a/fs/ocfs2/journal.h
> > +++ b/fs/ocfs2/journal.h
> > @@ -200,7 +200,6 @@ void ocfs2_complete_quota_recovery(struct ocfs2_super *osb);
> >  
> >  static inline void ocfs2_start_checkpoint(struct ocfs2_super *osb)
> >  {
> > -	atomic_set(&osb->needs_checkpoint, 1);
> >  	wake_up(&osb->checkpoint_event);
> >  }
> >  
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index d355e6e..3a90347 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -347,7 +347,6 @@ struct ocfs2_super
> >  	struct task_struct *recovery_thread_task;
> >  	int disable_recovery;
> >  	wait_queue_head_t checkpoint_event;
> > -	atomic_t needs_checkpoint;
> >  	struct ocfs2_journal *journal;
> >  	unsigned long osb_commit_interval;
> >  
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 01b8516..854d809 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -286,10 +286,9 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
> >  	spin_unlock(&osb->osb_lock);
> >  
> >  	out += snprintf(buf + out, len - out,
> > -			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
> > +			"%10s => Pid: %d  Interval: %lu\n", "Commit",
> >  			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
> > -			osb->osb_commit_interval,
> > -			atomic_read(&osb->needs_checkpoint));
> > +			osb->osb_commit_interval);
> >  
> >  	out += snprintf(buf + out, len - out,
> >  			"%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
> > @@ -2154,7 +2153,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
> >  	}
> >  
> >  	init_waitqueue_head(&osb->checkpoint_event);
> > -	atomic_set(&osb->needs_checkpoint, 0);
> >  
> >  	osb->s_atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
> 
> Found another corruption on above line when applying this patch :-P.
> 
> But never mind, I fixed it for saving your time.
> This fix looks good to me, thank you.
> 
> -Jeff
> 
> 
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Code cleanup: needs_checkpoint is only assigned but never used to check.
> Delete the variable.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/ocfs2/journal.h |    1 -
>  fs/ocfs2/ocfs2.h   |    1 -
>  fs/ocfs2/super.c   |    6 ++----
>  3 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index a3385b6..0a99273 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -200,7 +200,6 @@ void ocfs2_complete_quota_recovery(struct ocfs2_super *osb);
>  
>  static inline void ocfs2_start_checkpoint(struct ocfs2_super *osb)
>  {
> -	atomic_set(&osb->needs_checkpoint, 1);
>  	wake_up(&osb->checkpoint_event);
>  }
>  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index d355e6e..3a90347 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -347,7 +347,6 @@ struct ocfs2_super
>  	struct task_struct *recovery_thread_task;
>  	int disable_recovery;
>  	wait_queue_head_t checkpoint_event;
> -	atomic_t needs_checkpoint;
>  	struct ocfs2_journal *journal;
>  	unsigned long osb_commit_interval;
>  
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 01b8516..854d809 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -286,10 +286,9 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
>  	spin_unlock(&osb->osb_lock);
>  
>  	out += snprintf(buf + out, len - out,
> -			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
> +			"%10s => Pid: %d  Interval: %lu\n", "Commit",
>  			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
> -			osb->osb_commit_interval,
> -			atomic_read(&osb->needs_checkpoint));
> +			osb->osb_commit_interval);
>  
>  	out += snprintf(buf + out, len - out,
>  			"%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
> @@ -2154,7 +2153,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	}
>  
>  	init_waitqueue_head(&osb->checkpoint_event);
> -	atomic_set(&osb->needs_checkpoint, 0);
>  
>  	osb->s_atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
>  
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

			http://www.jlbec.org/
			jlbec at evilplan.org
