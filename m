From: Guozhonghua <guozhonghua@h3c.com>
Date: Mon, 25 May 2015 08:22:08 +0000
Subject: [Ocfs2-devel] LVB patch for reviews, thanks
Message-ID: <71604351584F6A4EBAE558C676F37CA4696D3C66@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


As dlm lock LVB different, the dlm lock migration may be failed without the dlm lock.
So the new owner will not have the dlm lock with the node, such as cookie 10:2696 as below.

diff -cp dlmrecovery_org.c dlmrecovery.c
*** dlmrecovery_org.c   2015-05-25 09:53:05.530826236 +0800
--- dlmrecovery.c       2015-05-25 10:01:12.242839116 +0800
*************** static void dlm_prepare_lvb_for_migratio
*** 1194,1199 ****
--- 1194,1203 ----
        if (!lock->lksb)
               return;

+       if (dlm_lvb_is_empty(lock->lksb->lvb)) {
+               return;
+       }
+
        /* Ignore lvb in all locks in the blocked list */
        if (queue == DLM_BLOCKED_LIST)
                return;


May 24 16:45:51 cvk60 kernel: [  868.542596] (umount,20349,2):dlm_prepare_lvb_for_migration:1235 ERROR: Mismatched lvb in lock cookie=10:2696, name=M00000000000000017a012300000000, node=10
May 24 16:45:51 cvk60 kernel: [  868.542603] lockres: M00000000000000017a012300000000, owner=8, state=32
May 24 16:45:51 cvk60 kernel: [  868.542604]   last used: 0, refcnt: 12, on purge list: no
May 24 16:45:51 cvk60 kernel: [  868.542606]   on dirty list: no, on reco list: no, migrating pending: no
May 24 16:45:51 cvk60 kernel: [  868.542607]   inflight locks: 0, asts reserved: 0
May 24 16:45:51 cvk60 kernel: [  868.542608]   refmap nodes: [ 1 2 3 5 6 7 9 10 11 12 ], inflight=0
May 24 16:45:51 cvk60 kernel: [  868.542613]   res lvb: 05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542636]   granted queue:
May 24 16:45:51 cvk60 kernel: [  868.542638]     type=3, conv=-1, node=7, cookie=7:2863, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542639]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542664]     type=3, conv=-1, node=10, cookie=10:2696, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542665]     lock lvb:
May 24 16:45:51 cvk60 kernel: [  868.542668]     type=3, conv=-1, node=12, cookie=12:2528, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542669]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542694]     type=3, conv=-1, node=11, cookie=11:1308, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542695]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542719]     type=3, conv=-1, node=3, cookie=3:6315, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542720]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542745]     type=3, conv=-1, node=6, cookie=6:3745, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542746]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542771]     type=3, conv=-1, node=9, cookie=9:2746, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542772]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542797]     type=3, conv=-1, node=2, cookie=2:7003, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542798]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542822]     type=3, conv=-1, node=1, cookie=1:1921, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542823]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542848]     type=3, conv=-1, node=5, cookie=5:2841, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
May 24 16:45:51 cvk60 kernel: [  868.542849]     lock lvb:05000000000000450000000000000000155863770a7adf68155863764986bbdc155863764986bbdc0000000004600000818000010000000046c6e83500000000
May 24 16:45:51 cvk60 kernel: [  868.542873]   converting queue:
May 24 16:45:51 cvk60 kernel: [  868.542874]   blocked queue:


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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150525/aa63406a/attachment-0001.html 
