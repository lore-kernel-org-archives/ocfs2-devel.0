From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 30 Sep 2014 15:21:17 +0800
Subject: [Ocfs2-devel] One node hangs up issue requiring goog idea,
	thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA42EC73D64@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA42EC73D64@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <542A59ED.5010508@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I don't think this is right.
There are two scenario when returns -ENOTCONN or -EHOSTDOWN:
1) Connection down when sending the message;
2) Connection down when responding the messages;
So just resend the message may lead to remote handles twice.

On 2014/9/26 20:06, Guozhonghua wrote:
> Hi, all,
> 
> As we use OCFS2, the network is not good.
> When the converting request message can?t send to the another node, there will be a node hangs up which will still waiting for the dlm.
> 
> CAS2/logdir/var/log/syslog.1-6778-Sep 16 20:57:16 CAS2 kernel: [516366.623623] o2net: Connection to node CAS1 (num 1) at 10.172.254.1:7100 has been idle for 30.87 secs, shutting it down.
> CAS2/logdir/var/log/syslog.1-6779-Sep 16 20:57:16 CAS2 kernel: [516366.623631] o2net_idle_timer 1621: Local and remote node is heartbeating, and try connect
> CAS2/logdir/var/log/syslog.1-6780-Sep 16 20:57:16 CAS2 kernel: [516366.623792] o2net: No longer connected to node CAS1 (num 1) at 10.172.254.1:7100
> CAS2/logdir/var/log/syslog.1:6781:Sep 16 20:57:16 CAS2 kernel: [516366.623881] (dlm_thread,5140,4):dlm_send_proxy_ast_msg:482 ERROR: B258FD07DDD64710B68EB9683FD7D1B9: res M00000000000000046e011700000000, error -112 send AST to node 1
> CAS2/logdir/var/log/syslog.1-6782-Sep 16 20:57:16 CAS2 kernel: [516366.623900] (dlm_thread,5140,4):dlm_flush_asts:596 ERROR: status = -112
> CAS2/logdir/var/log/syslog.1-6783-Sep 16 20:57:16 CAS2 kernel: [516366.623937] (dlm_thread,5140,4):dlm_send_proxy_ast_msg:482 ERROR: B258FD07DDD64710B68EB9683FD7D1B9: res M000000000000001626011000000000, error -107 send AST to node 1
> CAS2/logdir/var/log/syslog.1-6784-Sep 16 20:57:16 CAS2 kernel: [516366.623946] (dlm_thread,5140,4):dlm_flush_asts:596 ERROR: status = -107
> CAS2/logdir/var/log/syslog.1-6785-Sep 16 20:57:16 CAS2 kernel: [516366.623997] Connect node 1 OK, and set timeout 0
> CAS2/logdir/var/log/syslog.1-6786-Sep 16 20:57:17 CAS2 kernel: [516367.623592] o2net: Connected to node CAS1 (num 1) at 10.172.254.1:7100
> 
> debugfs: fs_locks -B
> Lockres: M00000000000000046e011700000000  Mode: Protected Read
> Flags: Initialized Attached Busy
> RO Holders: 0  EX Holders: 0
> Pending Action: Convert  Pending Unlock Action: None
> Requested Mode: Exclusive  Blocking Mode: No Lock
> PR > Gets: 318317  Fails: 0    Waits (usec) Total: 128622  Max: 3
> EX > Gets: 706878  Fails: 0    Waits (usec) Total: 284967  Max: 2
> Disk Refreshes: 0
> 
> debugfs: dlm_locks M00000000000000046e011700000000
> Lockres: M00000000000000046e011700000000   Owner: 2    State: 0x0
> Last Used: 0      ASTs Reserved: 0    Inflight: 0    Migration Pending: No
> Refs: 4    Locks: 2    On Lists: None
> Reference Map: 1
>  Lock-Queue  Node  Level  Conv  Cookie           Refs  AST  BAST  Pending-Action
>  Granted     1     PR     -1    1:195            2     No   No    None
>  Converting  2     PR     EX    2:196            2     No   No    None
> 
> We reviews the code, and want to resend the dlm message to avoid it.
> 
> The patch is required reviewing.
> The patch has been test when the network interface is shut down and up manually to recreate the issue.
> If the TCP channel between two node set up within 5 seconds, resend msg works well.
> 
> We are forward to appreciate another better way to avoid it.
> Thanks.
> 
> 
> --- ocfs2/dlm/dlmthread.c 2014-06-07 10:40:09.000000000 +0800
> +++ ocfs2/dlm/dlmthread.c 2014-09-26 16:42:36.000000000 +0800
> @@ -517,6 +517,9 @@ static void dlm_flush_asts(struct dlm_ct
>         struct dlm_lock_resource *res;
>         u8 hi;
> 
> +    /* resend the msg again */
> +    int send_times = 0;
> +
>         spin_lock(&dlm->ast_lock);
>         while (!list_empty(&dlm->pending_asts)) {
>                 lock = list_entry(dlm->pending_asts.next,
> @@ -539,9 +542,16 @@ static void dlm_flush_asts(struct dlm_ct
>                 spin_unlock(&dlm->ast_lock);
> 
>                 if (lock->ml.node != dlm->node_num) {
> -                       ret = dlm_do_remote_ast(dlm, res, lock);
> -                       if (ret < 0)
> +                       ret = dlm_do_remote_ast(dlm, res, lock);
> +                       if (ret < 0) {
>                                 mlog_errno(ret);
> +                           while ((ret == -112 || ret == -107) && send_times++ < 5 ) {
> +                               msleep(1000);
> +                               ret = dlm_do_remote_ast(dlm, res, lock);
> +                               mlog(ML_NOTICE, "AST message retry send again, %d code, send_time = %d\n", ret, send_times);
> +                           }
> +                           send_times = 0;
> +                   }
>                 } else
>                         dlm_do_local_ast(dlm, res, lock);
> 
> @@ -592,8 +602,15 @@ static void dlm_flush_asts(struct dlm_ct
> 
>                 if (lock->ml.node != dlm->node_num) {
>                         ret = dlm_send_proxy_bast(dlm, res, lock, hi);
> -                       if (ret < 0)
> +                       if (ret < 0) {
>                             mlog_errno(ret);
> +                           while ((ret == -112 || ret == -107) && send_times++ < 5 ) {
> +                               msleep(1000);
> +                               ret = dlm_send_proxy_bast(dlm, res, lock, hi);;
> +                               mlog(ML_NOTICE, "BAST message retry send again, %d code, send_time = %d\n", ret, send_times);
> +                           }
> +                           send_times = 0;
> +                   }
>                 } else
>                         dlm_do_local_bast(dlm, res, lock, hi);
> 
> 
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
> 
