From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Wed, 20 Apr 2016 07:27:48 +0000
Subject: [Ocfs2-devel] ocfs2: disk timeout,
 autoumount the volume to avoid calling emergency_restart
References: <mailman.2069.1458798582.24165.ocfs2-devel@oss.oracle.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB5375E19CDC7@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Hi everyone


In ocfs2, when one storage volume can't access, all nodes which have mounted the volume will fence self

due to write timeout or io error. So I make a useful attempt to add autoumount option.

in the case, I know that for some reason umount may be hung.Based on the analysis process of ocfs2 umount,

it's possible to complete all locks and wake up block events before umounting the volume.

the way is to work well by forever experimenting and devising tests.the patch may be release in the recent times.

Is the patch risky and reasonable? what do you think ? Thanks

Best regards



------------------------------

Message: 3
Date: Thu, 24 Mar 2016 10:50:31 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [Ocfs2-devel] [patch 19/25] ocfs2: o2hb: add negotiate
        timer
To: akpm at linux-foundation.org, mfasheh at suse.de, jlbec at evilplan.org,
        joseph.qi at huawei.com, ocfs2-devel at oss.oracle.com, ghe at suse.com,
        rwxybh at 126.com, ryan.ding at oracle.com
Message-ID: <56F355F7.2040004@oracle.com>
Content-Type: text/plain; charset=windows-1252

This is v1 version, I sent out V2 patch set before to fix all code style
issue.

On 03/24/2016 04:12 AM, akpm at linux-foundation.org wrote:
> From: Junxiao Bi <junxiao.bi@oracle.com>
> Subject: ocfs2: o2hb: add negotiate timer
>
> This series of patches is to fix the issue that when storage down, all
> nodes will fence self due to write timeout.
>
> With this patch set, all nodes will keep going until storage back online,
> except if the following issue happens, then all nodes will do as before to
> fence self.
>
> 1. io error got
> 2. network between nodes down
> 3. nodes panic
>
>
> This patch (of 6):
>
> When storage down, all nodes will fence self due to write timeout.  The
> negotiate timer is designed to avoid this, with it node will wait until
> storage up again.
>
> Negotiate timer working in the following way:
>
> 1. The timer expires before write timeout timer, its timeout is half
>    of write timeout now.  It is re-queued along with write timeout timer.
>    If expires, it will send NEGO_TIMEOUT message to master node(node with
>    lowest node number).  This message does nothing but marks a bit in a
>    bitmap recording which nodes are negotiating timeout on master node.
>
> 2. If storage down, nodes will send this message to master node, then
>    when master node finds its bitmap including all online nodes, it sends
>    NEGO_APPROVL message to all nodes one by one, this message will
>    re-queue write timeout timer and negotiate timer.  For any node doesn't
>    receive this message or meets some issue when handling this message, it
>    will be fenced.  If storage up at any time, o2hb_thread will run and
>    re-queue all the timer, nothing will be affected by these two steps.
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
> Cc: Gang He <ghe@suse.com>
> Cc: rwxybh <rwxybh@126.com>
> Cc: Mark Fasheh <mfasheh@suse.de>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/ocfs2/cluster/heartbeat.c |   52 ++++++++++++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 4 deletions(-)
>
> diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-negotiate-timer fs/ocfs2/cluster/heartbeat.c
> --- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-negotiate-timer
> +++ a/fs/ocfs2/cluster/heartbeat.c
> @@ -272,6 +272,10 @@ struct o2hb_region {
>       struct delayed_work     hr_write_timeout_work;
>       unsigned long           hr_last_timeout_start;
>
> +     /* negotiate timer, used to negotiate extending hb timeout. */
> +     struct delayed_work     hr_nego_timeout_work;
> +     unsigned long           hr_nego_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +
>       /* Used during o2hb_check_slot to hold a copy of the block
>        * being checked because we temporarily have to zero out the
>        * crc field. */
> @@ -319,7 +323,7 @@ static void o2hb_write_timeout(struct wo
>       o2quo_disk_timeout();
>  }
>
> -static void o2hb_arm_write_timeout(struct o2hb_region *reg)
> +static void o2hb_arm_timeout(struct o2hb_region *reg)
>  {
>       /* Arm writeout only after thread reaches steady state */
>       if (atomic_read(&reg->hr_steady_iterations) != 0)
> @@ -337,11 +341,50 @@ static void o2hb_arm_write_timeout(struc
>       reg->hr_last_timeout_start = jiffies;
>       schedule_delayed_work(&reg->hr_write_timeout_work,
>                             msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
> +
> +     cancel_delayed_work(&reg->hr_nego_timeout_work);
> +     /* negotiate timeout must be less than write timeout. */
> +     schedule_delayed_work(&reg->hr_nego_timeout_work,
> +                           msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS)/2);
> +     memset(reg->hr_nego_node_bitmap, 0, sizeof(reg->hr_nego_node_bitmap));
>  }
>
> -static void o2hb_disarm_write_timeout(struct o2hb_region *reg)
> +static void o2hb_disarm_timeout(struct o2hb_region *reg)
>  {
>       cancel_delayed_work_sync(&reg->hr_write_timeout_work);
> +     cancel_delayed_work_sync(&reg->hr_nego_timeout_work);
> +}
> +
> +static void o2hb_nego_timeout(struct work_struct *work)
> +{
> +     struct o2hb_region *reg =
> +             container_of(work, struct o2hb_region,
> +                          hr_nego_timeout_work.work);
> +     unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
> +     int master_node;
> +
> +     o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
> +     /* lowest node as master node to make negotiate decision. */
> +     master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
> +
> +     if (master_node == o2nm_this_node()) {
> +             set_bit(master_node, reg->hr_nego_node_bitmap);
> +             if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
> +                             sizeof(reg->hr_nego_node_bitmap))) {
> +                     /* check negotiate bitmap every second to do timeout
> +                      * approve decision.
> +                      */
> +                     schedule_delayed_work(&reg->hr_nego_timeout_work,
> +                             msecs_to_jiffies(1000));
> +
> +                     return;
> +             }
> +
> +             /* approve negotiate timeout request. */
> +     } else {
> +             /* negotiate timeout with master node. */
> +     }
> +
>  }
>
>  static inline void o2hb_bio_wait_init(struct o2hb_bio_wait_ctxt *wc)
> @@ -1032,7 +1075,7 @@ static int o2hb_do_disk_heartbeat(struct
>       /* Skip disarming the timeout if own slot has stale/bad data */
>       if (own_slot_ok) {
>               o2hb_set_quorum_device(reg);
> -             o2hb_arm_write_timeout(reg);
> +             o2hb_arm_timeout(reg);
>       }
>
>  bail:
> @@ -1114,7 +1157,7 @@ static int o2hb_thread(void *data)
>               }
>       }
>
> -     o2hb_disarm_write_timeout(reg);
> +     o2hb_disarm_timeout(reg);
>
>       /* unclean stop is only used in very bad situation */
>       for(i = 0; !reg->hr_unclean_stop && i < reg->hr_blocks; i++)
> @@ -1763,6 +1806,7 @@ static ssize_t o2hb_region_dev_store(str
>       }
>
>       INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
> +     INIT_DELAYED_WORK(&reg->hr_nego_timeout_work, o2hb_nego_timeout);
>
>       /*
>        * A node is considered live after it has beat LIVE_THRESHOLD
> _
>


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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160420/a492a618/attachment-0001.html 
