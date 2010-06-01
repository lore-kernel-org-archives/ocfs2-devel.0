From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 01 Jun 2010 15:07:32 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Move orphan scan work to ocfs2_wq.
In-Reply-To: <1275027779-10371-1-git-send-email-tao.ma@oracle.com>
References: <1275027779-10371-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4C0584A4.90300@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>

On 05/27/2010 11:22 PM, Tao Ma wrote:
> We used to let orphan scan work in the default work queue,
> but there is a corner case which will make the system deadlock.
> The scenario is like this:
> 1. set heartbeat threadshold to 200. this will allow us to have a
>     great chance to have a orphan scan work before our quorum decision.
> 2. mount node 1.
> 3. after 1~2 minutes, mount node 2(in order to make the bug easier
>     to reproduce, better add maxcpus=1 to kernel command line).
> 4. node 1 do orphan scan work.
> 5. node 2 do orphan scan work.
> 6. node 1 do orphan scan work. After this, node 1 hold the orphan scan
>     lock while node 2 know node 1 is the master.
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
> Signed-off-by: Tao Ma<tao.ma@oracle.com>
> ---
>   fs/ocfs2/journal.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 57e3fef..e02788f 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1938,7 +1938,7 @@ void ocfs2_orphan_scan_work(struct work_struct *work)
>   	mutex_lock(&os->os_lock);
>   	ocfs2_queue_orphan_scan(osb);
>   	if (atomic_read(&os->os_state) == ORPHAN_SCAN_ACTIVE)
> -		schedule_delayed_work(&os->os_orphan_scan_work,
> +		queue_delayed_work(ocfs2_wq,&os->os_orphan_scan_work,
>   				      ocfs2_orphan_scan_timeout());
>   	mutex_unlock(&os->os_lock);
>   }
> @@ -1978,8 +1978,8 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
>   		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
>   	else {
>   		atomic_set(&os->os_state, ORPHAN_SCAN_ACTIVE);
> -		schedule_delayed_work(&os->os_orphan_scan_work,
> -				      ocfs2_orphan_scan_timeout());
> +		queue_delayed_work(ocfs2_wq,&os->os_orphan_scan_work,
> +				   ocfs2_orphan_scan_timeout());
>   	}
>   }
>
>    
