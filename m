From: Guozhonghua <guozhonghua@h3c.com>
Date: Sat, 25 Oct 2014 07:06:07 +0000
Subject: [Ocfs2-devel] DLM_IVLOCKID result in file removed failed,
	issue calls for talks.
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC7BC04@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All,

We test the OCFS2 and there is one issue report.
We remove one file or move it with another name in the path mounted with OCFS2 device, one node request the EX type node of inode 531, orphan_dir:0011 file.
But the owner cannot find the lock from its local lock list, so it return DLM_IVLOCKID and the file remove operation failed.

We remove the file on node cvk12, and its debug log recorded in syslog.

Oct 24 19:09:07 cvk12 kernel: [259621.224260] (rm,17362,4):ocfs2_should_refresh_lock_res:2155 status 0
Oct 24 19:09:07 cvk12 kernel: [259621.224280] (rm,17362,4):ocfs2_inode_lock_full_nested:2298 inode 1740044, take EXMODE META lock
Oct 24 19:09:07 cvk12 kernel: [259621.224283] (rm,17362,4):ocfs2_should_refresh_lock_res:2155 status 0
Oct 24 19:09:07 cvk12 kernel: [259621.224290] (rm,17362,4):ocfs2_inode_lock_full_nested:2298 inode 531, take EXMODE META lock
Oct 24 19:09:07 cvk12 kernel: [259621.224293] (rm,17362,4):__ocfs2_cluster_lock:1465 lockres M000000000000000000021320c6ec4e, convert from 3 to 5
Oct 24 19:09:07 cvk12 kernel: [259621.224297] (rm,17362,4):dlmconvert_remote:267 type=3, convert_type=-1, busy=0
Oct 24 19:09:07 cvk12 kernel: [259621.224301] (rm,17362,4):dlm_send_remote_convert_request:353 M000000000000000000021320c6ec4e
Oct 24 19:09:07 cvk12 kernel: [259621.224337] (rm,17362,4):o2net_send_message_vec:1179 [mag 64085 len 80 typ 504 stat 0 sys_stat 0 key eec5710a num 0] sending returned 0
Oct 24 19:09:07 cvk12 kernel: [259621.224834] (swapper/0,0,0):o2net_data_ready:626 [sc ffff88061bc34c00 refs 4 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] data_ready hit
Oct 24 19:09:07 cvk12 kernel: [259621.224842] (swapper/0,0,0):sc_get:427 [sc ffff88061bc34c00 refs 4 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] get
Oct 24 19:09:07 cvk12 kernel: [259621.224877] (kworker/u129:0,43499,1):o2net_advance_rx:1422 [sc ffff88061bc34c00 refs 5 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] receiving
Oct 24 19:09:07 cvk12 kernel: [259621.224895] (kworker/u129:0,43499,1):o2net_advance_rx:1471 [mag 64086 len 0 typ 504 stat 11 sys_stat 0 key eec5710a num 0] at page_off 24
Oct 24 19:09:07 cvk12 kernel: [259621.224898] (kworker/u129:0,43499,1):o2net_process_message:1258 [mag 64086 len 0 typ 504 stat 11 sys_stat 0 key eec5710a num 0] processing message
Oct 24 19:09:07 cvk12 kernel: [259621.224901] (kworker/u129:0,43499,1):sc_put:421 [sc ffff88061bc34c00 refs 5 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 24] put
Oct 24 19:09:07 cvk12 kernel: [259621.224910] (kworker/u129:0,43499,1):sc_get:427 [sc ffff88061bc34c00 refs 4 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 24] get
Oct 24 19:09:07 cvk12 kernel: [259621.224919] (kworker/u129:0,43499,1):o2net_advance_rx:1497 [sc ffff88061bc34c00 refs 5 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] ret = 1
Oct 24 19:09:07 cvk12 kernel: [259621.224923] (kworker/u129:0,43499,1):o2net_advance_rx:1422 [sc ffff88061bc34c00 refs 5 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] receiving
Oct 24 19:09:07 cvk12 kernel: [259621.224926] (kworker/u129:0,43499,1):o2net_advance_rx:1497 [sc ffff88061bc34c00 refs 5 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] ret = -11
Oct 24 19:09:07 cvk12 kernel: [259621.224929] (kworker/u129:0,43499,1):sc_put:421 [sc ffff88061bc34c00 refs 5 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] put
Oct 24 19:09:07 cvk12 kernel: [259621.224949] (rm,17362,4):o2net_send_message_vec:1199 woken, returning system status 0, user status 11
Oct 24 19:09:07 cvk12 kernel: [259621.224954] (rm,17362,4):sc_put:421 [sc ffff88061bc34c00 refs 4 sock ffff880619128a00 node 1 page ffffea0017a4ee00 pg_off 0] put
Oct 24 19:09:07 cvk12 kernel: [259621.224957] (rm,17362,4):dlm_send_remote_convert_request:388 ERROR: dlm status = DLM_IVLOCKID
Oct 24 19:09:07 cvk12 kernel: [259621.224965] (rm,17362,4):dlmconvert_remote:322 ERROR: dlm status = DLM_IVLOCKID
Oct 24 19:09:07 cvk12 kernel: [259621.224970] (rm,17362,4):__ocfs2_cluster_lock:1479 ERROR: DLM error -22 while calling ocfs2_dlm_lock on resource M000000000000000000021320c6ec4e
Oct 24 19:09:07 cvk12 kernel: [259621.224975] (rm,17362,4):ocfs2_inode_lock_full_nested:2326 ERROR: status = -22
Oct 24 19:09:07 cvk12 kernel: [259621.224980] (rm,17362,4):ocfs2_lookup_lock_orphan_dir:1890 ERROR: status = -22
Oct 24 19:09:07 cvk12 kernel: [259621.224984] (rm,17362,4):ocfs2_prepare_orphan_dir:1953 ERROR: status = -22
Oct 24 19:09:07 cvk12 kernel: [259621.224996] (rm,17362,4):ocfs2_unlink:870 ERROR: status = -22
Oct 24 19:09:07 cvk12 kernel: [259621.225001] (rm,17362,4):ocfs2_inode_unlock:2475 inode 1740044 drop EXMODE META lock
Oct 24 19:09:07 cvk12 kernel: [259621.225003] (rm,17362,4):ocfs2_inode_unlock:2475 inode 513 drop EXMODE META lock
Oct 24 19:09:07 cvk12 kernel: [259621.225006] (rm,17362,4):ocfs2_unlink:948 ERROR: status = -22

Another node cvknode66 response the reqeust.
It cannot find the lock and return DLM_IVLOCKID, so as removing operation failed.

Oct 24 19:09:01 cvknode66 CRON[4228]: (CRON) info (No MTA installed, discarding output)
Oct 24 19:09:04 cvknode66 kernel: [375654.198219] (kworker/u129:2,55238,17):dlm_convert_lock_handler:485 ERROR: did not find lock to convert on grant queue! cookie=2:14
Oct 24 19:09:04 cvknode66 kernel: [375654.198228] lockres: M000000000000000000021320c6ec4e, owner=1, state=0
Oct 24 19:09:04 cvknode66 kernel: [375654.198242]   last used: 0, refcnt: 26, on purge list: no
Oct 24 19:09:04 cvknode66 kernel: [375654.198243]   on dirty list: no, on reco list: no, migrating pending: no
Oct 24 19:09:04 cvknode66 kernel: [375654.198244]   inflight locks: 0, asts reserved: 0
Oct 24 19:09:04 cvknode66 kernel: [375654.198245]   refmap nodes: [ 2 3 8 11 12 13 14 15 16 17 18 20 21 22 23 26 27 72 109 110 112 115 116 117 118 119 120 ], inflight=0
Oct 24 19:09:04 cvknode66 kernel: [375654.198256]   granted queue:
Oct 24 19:09:04 cvknode66 kernel: [375654.198259]     type=3, conv=-1, node=1, cookie=1:833, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198260] 050000010000000000000000000000001511ffffff9409ffffffc00000001511ffffffe5ffffffe9ffffffce483f601511ffffffe5ffffffe9ffffffce483f600000000000000f3841ffffffed00020000000020ffffffc6ffffffec4e00000000
Oct 24 19:09:04 cvknode66 kernel: [375654.198283]     type=3, conv=-1, node=8, cookie=8:8541, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198286]     type=3, conv=-1, node=17, cookie=17:2421, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198288]     type=3, conv=-1, node=23, cookie=23:3170, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198290]     type=3, conv=-1, node=21, cookie=21:2909, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198292]     type=3, conv=-1, node=11, cookie=11:14, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198294]     type=3, conv=-1, node=20, cookie=20:3086, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198296]     type=3, conv=-1, node=13, cookie=13:2911, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198297]     type=3, conv=-1, node=15, cookie=15:2875, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198299]     type=3, conv=-1, node=26, cookie=26:2357, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198301]     type=3, conv=-1, node=72, cookie=72:993, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198303]     type=3, conv=-1, node=27, cookie=27:3056, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198305]     type=3, conv=-1, node=119, cookie=119:67, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198307]     type=3, conv=-1, node=110, cookie=110:3669, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198309]     type=3, conv=-1, node=115, cookie=115:2585, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198311]     type=3, conv=-1, node=118, cookie=118:2393, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198313]     type=3, conv=-1, node=109, cookie=109:2849, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198315]     type=3, conv=-1, node=22, cookie=22:2820, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198316]     type=3, conv=-1, node=12, cookie=12:2636, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198318]     type=3, conv=-1, node=112, cookie=112:600, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198320] 050000010000000000000000000000001511ffffff9409ffffffc00000001511ffffffe5ffffffe9ffffffce483f601511ffffffe5ffffffe9ffffffce483f600000000000000f3841ffffffed00020000000020ffffffc6ffffffec4e00000000
Oct 24 19:09:04 cvknode66 kernel: [375654.198342]     type=3, conv=-1, node=14, cookie=14:2424, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198343] 050000010000000000000000000000001511ffffff9409ffffffc00000001511ffffffe5ffffffe9ffffffce483f601511ffffffe5ffffffe9ffffffce483f600000000000000f3841ffffffed00020000000020ffffffc6ffffffec4e00000000
Oct 24 19:09:04 cvknode66 kernel: [375654.198365]     type=3, conv=-1, node=120, cookie=120:968, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198366] 050000010000000000000000000000001511ffffff9409ffffffc00000001511ffffffe5ffffffe9ffffffce483f601511ffffffe5ffffffe9ffffffce483f600000000000000f3841ffffffed00020000000020ffffffc6ffffffec4e00000000
Oct 24 19:09:04 cvknode66 kernel: [375654.198388]     type=3, conv=-1, node=3, cookie=3:3395, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198389] 050000010000000000000000000000001511ffffff9409ffffffc00000001511ffffffe5ffffffe9ffffffce483f601511ffffffe5ffffffe9ffffffce483f600000000000000f3841ffffffed00020000000020ffffffc6ffffffec4e00000000
Oct 24 19:09:04 cvknode66 kernel: [375654.198411]     type=3, conv=-1, node=16, cookie=16:2256, ref=2, ast=(empty=y,pend=n), bast=(empty=y,pend=n), pending=(conv=n,lock=n,cancel=n,unlock=n)
Oct 24 19:09:04 cvknode66 kernel: [375654.198412] 050000010000000000000000000000001511ffffff9409ffffffc00000001511ffffffe5ffffffe9ffffffce483f601511ffffffe5ffffffe9ffffffce483f600000000000000f3841ffffffed00020000000020ffffffc6ffffffec4e00000000
Oct 24 19:09:04 cvknode66 kernel: [375654.198446]   converting queue:
Oct 24 19:09:04 cvknode66 kernel: [375654.198447]   blocked queue:

We reviewed the code, and think that the DLM message may be lost in the cluster which cause the operation failed.
The reason that lock info lost on the owner, we did not know.
Is there any other way to avoid the issue, or why this scenario created?

Thanks a lot.


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
