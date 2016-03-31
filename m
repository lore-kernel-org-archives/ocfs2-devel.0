From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 31 Mar 2016 12:17:05 +0800
Subject: [Ocfs2-devel] [PATCH] o2hb: increase unsteady iterations
In-Reply-To: <D1E4D02760513D4B90DC3B40FF32AF355EE24988@H3CMLB14-EX.srv.huawei-3com.com>
References: <D1E4D02760513D4B90DC3B40FF32AF355EE24988@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <56FCA4C1.40302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/29/2016 08:32 PM, Shichangkuo wrote:
> Hi Junxiao,
> If tcp connections take a long time to establish, and hr_unsteady_iterations still may change to 0, then o2hb thread will exit by error.
> What about wait the connection?
NAK, this will hung the mount if network is down.

Thanks,
Junxiao.
> 
> --- a/fs/ocfs2/cluster/heartbeat.c      2016-03-29 20:22:03.066400592 +0800
> +++ a/fs/ocfs2/cluster/heartbeat.c      2016-03-29 20:20:55.494065519 +0800
> @@ -1054,7 +1054,7 @@ bail:
>         }
> 
>         if (atomic_read(&reg->hr_steady_iterations) != 0) {
> -               if (atomic_dec_and_test(&reg->hr_unsteady_iterations)) {
> +               if (!membership_change && atomic_dec_and_test(&reg->hr_unsteady_iterations)) {
>                         printk(KERN_NOTICE "o2hb: Unable to stabilize "
>                                "heartbeart on region %s (%s)\n",
>                                config_item_name(&reg->hr_item),
> 
> Thanks
> Changkuo
> 
> ???: ocfs2-devel-bounces at oss.oracle.com [mailto:ocfs2-devel-bounces at oss.oracle.com] ?? Junxiao Bi
> ????: 2015?11?19? 16:08
> ???: ocfs2-devel at oss.oracle.com
> ??: mfasheh at suse.com
> ??: [Ocfs2-devel] [PATCH] o2hb: increase unsteady iterations
> 
> When run multiple xattr test of ocfs2-test on a three-nodes cluster, mount failed sometimes with the following message.
> 
> o2hb: Unable to stabilize heartbeart on region D18B775E758D4D80837E8CF3D086AD4A (xvdb)
> 
> Stabilize heartbeat depends on the timing order to mount ocfs2 from cluster nodes and how fast the tcp connections are established. So increase unsteady interations to leave more time for it.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c index 709fbbd..a3cc6d2 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -1780,8 +1780,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
>         }
>         ++live_threshold;
>         atomic_set(&reg->hr_steady_iterations, live_threshold);
> -       /* unsteady_iterations is double the steady_iterations */
> -       atomic_set(&reg->hr_unsteady_iterations, (live_threshold << 1));
> +       /* unsteady_iterations is triple the steady_iterations */
> +       atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
> 
>         hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
>                               reg->hr_item.ci_name);
> --
> 1.7.9.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> 
