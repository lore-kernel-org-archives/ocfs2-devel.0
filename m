From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Fri, 19 Oct 2012 10:56:42 -0700 (PDT)
Subject: [Ocfs2-devel] FW: [PATCH] workqueue: cancel_delayed_work() should
 return %NULL if work item is idle
Message-ID: <cc10b67d-3afe-4539-8df2-171effbf5b36@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

FYI, it is likely that ocfs2 will not work on 3.7-rcN until
the following one-line patch is merged, as the code in ramster
that provoked it is directly leveraged from ocfs2 o2net.

> From: Tejun Heo [mailto:tj at kernel.org]
> Sent: Thursday, October 18, 2012 5:39 PM
> To: Dan Magenheimer
> Cc: linux-kernel at vger.kernel.org; Konrad Wilk
> Subject: [PATCH] workqueue: cancel_delayed_work() should return %NULL if work item is idle
> 
> From e65120fcfc1cb9697655d29ecd7982451c05d3c2 Mon Sep 17 00:00:00 2001
> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Date: Thu, 18 Oct 2012 16:31:37 -0700
> 
> 57b30ae77b ("workqueue: reimplement cancel_delayed_work() using
> try_to_grab_pending()") made cancel_delayed_work() always return %true
> unless someone else is also trying to cancel the work item, which is
> broken - if the target work item is idle, the return value should be
> %false.
> 
> try_to_grab_pending() indicates that the target work item was idle by
> zero return value.  Use it for return.  Note that this brings
> cancel_delayed_work() in line with __cancel_work_timer() in return
> value handling.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> LKML-Reference: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
> ---
>  kernel/workqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index d951daa..042d221 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2982,7 +2982,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
> 
>  	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
>  	local_irq_restore(flags);
> -	return true;
> +	return ret;
>  }
>  EXPORT_SYMBOL(cancel_delayed_work);
> 
> --
> 1.7.7.3
> 
