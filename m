From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 28 May 2010 17:12:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Move orphan scan work to ocfs2_wq.
In-Reply-To: <1275027779-10371-1-git-send-email-tao.ma@oracle.com>
References: <1275027779-10371-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100528091211.GB2575@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tao,

Checking the workers in ocfs2_wq, I found osb_truncate_log_wq. The worker
function ocfs2_truncate_log_worker() can with the following call trace.

ocfs2_truncate_log_worker()
ocfs2_flush_truncate_log()
__ocfs2_flush_truncate_log()
ocfs2_inode_lock()

So I think during ocfs2_inode_lock(), we still have the possibility that
it hang the work queue at dlm_wait_for_node_death().

So maybe a dedicated work queue is the only choice?

regards,
wengang.
On 10-05-28 14:22, Tao Ma wrote:
> We used to let orphan scan work in the default work queue,
> but there is a corner case which will make the system deadlock.
> The scenario is like this:
> 1. set heartbeat threadshold to 200. this will allow us to have a
>    great chance to have a orphan scan work before our quorum decision.
> 2. mount node 1.
> 3. after 1~2 minutes, mount node 2(in order to make the bug easier
>    to reproduce, better add maxcpus=1 to kernel command line).
> 4. node 1 do orphan scan work.
> 5. node 2 do orphan scan work.
> 6. node 1 do orphan scan work. After this, node 1 hold the orphan scan
>    lock while node 2 know node 1 is the master.
> 7. ifdown eth2 in node 2(eth2 is what we do ocfs2 interconnection).
> 
> Now when node 2 begins orphan scan, the system queue is blocked.
> 
> The root cause is that both orphan scan work and quorum decision work
> will use the system event work queue. orphan scan has a chance of
> blocking the event work queue(in dlm_wait_for_node_death) so that there
> is no chance for quorum decision work to proceed.
> 
> This patch resolve it by moving orphan scan work to ocfs2_wq.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/journal.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 57e3fef..e02788f 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1938,7 +1938,7 @@ void ocfs2_orphan_scan_work(struct work_struct *work)
>  	mutex_lock(&os->os_lock);
>  	ocfs2_queue_orphan_scan(osb);
>  	if (atomic_read(&os->os_state) == ORPHAN_SCAN_ACTIVE)
> -		schedule_delayed_work(&os->os_orphan_scan_work,
> +		queue_delayed_work(ocfs2_wq, &os->os_orphan_scan_work,
>  				      ocfs2_orphan_scan_timeout());
>  	mutex_unlock(&os->os_lock);
>  }
> @@ -1978,8 +1978,8 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
>  		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
>  	else {
>  		atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
> -		schedule_delayed_work(&os->os_orphan_scan_work,
> -				      ocfs2_orphan_scan_timeout());
> +		queue_delayed_work(ocfs2_wq, &os->os_orphan_scan_work,
> +				   ocfs2_orphan_scan_timeout());
>  	}
>  }
>  
> -- 
> 1.5.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
