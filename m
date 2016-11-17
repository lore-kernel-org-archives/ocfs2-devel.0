From: Joseph Qi <jiangqi903@gmail.com>
Date: Thu, 17 Nov 2016 15:00:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix umount hang
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37342E59EFA@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E37342E59EFA@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <38d004a3-2dd7-fab5-a4fd-b0ccb602a41e@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

Why are the dead nodes still in live map, according to your dlm_state file?

Thanks,

Joseph

On 16/11/17 14:03, Gechangwei wrote:
> Hi
>
> During my recent test on OCFS2, an umount hang issue was found.
> Below clues can help us to analyze this issue.
>
>  From the debug information, we can see some abnormal stats like only node 1 is in DLM domain map, however, node 3 - 9 are still
> in MLE's node map and vote map.
> The root cause of unchanging vote map I think is that HB events are detached too early!
> That caused no chance of transforming from BLOCK MLE into MASTER MLE. Thus NODE 1 can't master lock resource even
> other nodes are all dead.
>
> To fix this, I propose a patch.
>
>  From 3163fa7024d96f8d6e6ec2b37ad44e2cc969abd9 Mon Sep 17 00:00:00 2001
> From: gechangwei <ge.changwei@h3c.com>
> Date: Thu, 17 Nov 2016 14:00:45 +0800
> Subject: [PATCH] fix umount hang
>
> Signed-off-by: gechangwei <ge.changwei@h3c.com>
> ---
>   fs/ocfs2/dlm/dlmmaster.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 6ea06f8..3c46882 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -3354,8 +3354,6 @@ static void dlm_clean_block_mle(struct dlm_ctxt *dlm,
>                  spin_unlock(&mle->spinlock);
>                  wake_up(&mle->wq);
>
> -               /* Do not need events any longer, so detach from heartbeat */
> -               __dlm_mle_detach_hb_events(dlm, mle);
>                  __dlm_put_mle(mle);
>          }
>   }
> --
> 2.5.1.windows.1
>
>
> root at HXY-CVK110:~# grep P000000000000000000000000000000 bbb
> Lockres: P000000000000000000000000000000   Owner: 255  State: 0x10 InProgress
>
> root at HXY-CVK110:/sys/kernel/debug/o2dlm/7DA412FEB1374366B0F3C70025EB1437# cat dlm_state
> Domain: 7DA412FEB1374366B0F3C70025EB1437  Key: 0x8ff804a1  Protocol: 1.2
> Thread Pid: 21679  Node: 1  State: JOINED
> Number of Joins: 1  Joining Node: 255
> Domain Map: 1
> Exit Domain Map:
> Live Map: 1 2 3 4 5 6 7 8 9
> Lock Resources: 29 (116)
> MLEs: 1 (119)
>    Blocking: 1 (4)
>    Mastery: 0 (115)
>    Migration: 0 (0)
> Lists: Dirty=Empty  Purge=Empty  PendingASTs=Empty  PendingBASTs=Empty
> Purge Count: 0  Refs: 1
> Dead Node: 255
> Recovery Pid: 21680  Master: 255  State: INACTIVE
> Recovery Map:
> Recovery Node State:
>
>
> root at HXY-CVK110:/sys/kernel/debug/o2dlm/7DA412FEB1374366B0F3C70025EB1437# ls
> dlm_state  locking_state  mle_state  purge_list
> root at HXY-CVK110:/sys/kernel/debug/o2dlm/7DA412FEB1374366B0F3C70025EB1437# cat mle_state
> Dumping MLEs for Domain: 7DA412FEB1374366B0F3C70025EB1437
> P000000000000000000000000000000  BLK  mas=255 new=255 evt=0        use=1       ref=  2
> Maybe=
> Vote=3 4 5 6 7 8 9
> Response=
> Node=3 4 5 6 7 8 9
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
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
