From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 21 Apr 2014 12:18:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: limit printk when journal is
 aborted
In-Reply-To: <5350EDE3.2040605@huawei.com>
References: <534FB63A.9090402@huawei.com>
	<20140417210132.GB27178@wotan.suse.de>
	<535079A9.9060603@huawei.com>
	<20140418024539.GE27178@wotan.suse.de>
	<5350EDE3.2040605@huawei.com>
Message-ID: <20140421121824.66710cc2496f84740324137d@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 18 Apr 2014 17:18:27 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> >>>> +			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
> >>>> +				mlog(ML_ERROR, "status = %d, journal is "
> >>>> +						"already aborted.\n", status);
> >>>> +			msleep_interruptible(1000);
> >>>> +		}
> >>>
> >>> Why the msleep? ocfs2_commit_thread will wait on the checkpoint_event queue
> >>> right after this anyway - is there a problem with it waiting on that?
> >>>
> >> Since jbd2 is already aborted, commit cache is meaningless.
> > 
> > I understand that, but I'm asking why the msleep and whether we can avoid
> > that. To go back to my question:
> > 
> > "ocfs2_commit_thread will wait on the checkpoint_event queue right after
> > this anyway - is there a problem with it waiting on that?"
> > 
> > Thanks,
> > 	--Mark
> Sorry for my obscure description.
> If ocfs2_commit_cache fails because of JBD2_ABORT, j_num_trans won't be cleared.
> Then the condition of checkpoint event still evaluates true, so it won't wait.

If Mark didn't understand the reason for the msleep then nobody weill,
so we need to add a comment.  This?

--- a/fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted-fix
+++ a/fs/ocfs2/journal.c
@@ -2193,6 +2193,11 @@ static int ocfs2_commit_thread(void *arg
 			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
 				mlog(ML_ERROR, "status = %d, journal is "
 						"already aborted.\n", status);
+			/*
+			 * After ocfs2_commit_cache() fails, j_num_trans has a
+			 * non-zero value.  Sleep here to avoid a busy-wait
+			 * loop.
+			 */
 			msleep_interruptible(1000);
 		}
 

This patch seems rather hacky :( Isn't there a better solution?

Why even keep the kernel thread running after an abort?
