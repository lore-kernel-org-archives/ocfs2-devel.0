From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 28 Dec 2015 14:49:35 +0800
Subject: [Ocfs2-devel] [Ocfs2-users] Ocfs2 clients hang
In-Reply-To: <2015122811584767447052@h3c.com>
References: <151c3ef2961.dae23b7f2509.4964442689232815434@zohocorp.com>,
	<151c8c9150c.d668db3e959.6072928770111775662@zohocorp.com>,
	<56792D64.9020406@huawei.com>,
	<151c9f239f9.10b3762df2413.3120142290527723409@zohocorp.com>
	<2015122811584767447052@h3c.com>
Message-ID: <5680DB7F.3090409@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_deref_lockres_handler may return EINVAL or ENOMEM which will lead
to sender BUG. So simply removing the BUG is not a fair way to resolve
this issue.
And I don't think the log you pasted can actually refer to its node.
Node 3 is indeed the deref handler because it is owner but not node 1.
BTW, if you want others to do the review and give you more suggestions,
you'd better follow the way described in Documentation/SubmittingPatches.

Thanks,
Joseph

On 2015/12/28 12:00, Zhangguanghui wrote:
> A similar problem is described below.
> There is a race window to triger BUG in dlm_drop_lockres_ref.
> all nodes will hang in the futhure. 
> 
> Node 1                                                                                          Node 3
>    mount.ocfs2  vol1 and create node lock,                                     reboot
>        waiting for Node 3                                                                         Node 3 mount.ocfs2 vol1
>             fail to mount vol1, do not get lock on journal                                      fail to mount vol1, Local alloc hasn't been recovered! 
>                dlm_drop_lockres_ref and lockres don't exsit,                             
>                return Error -22 and triger BUG.
> I think the BUG should be removed for the case. 
> But i can't say for sure what will come and remove the BUG?  Thanks for your reply .
> 
> dlm_drop_lockres_ref
> --- dlmmaster.c 2015-10-12 02:09:45.000000000 +0800
> +++ /root/dlmmaster.c 2015-12-28 11:39:14.560429513 +0800
> @@ -2275,7 +2275,6 @@
> mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
> dlm->name, namelen, lockname, res->owner, r);
> dlm_print_one_lock_resource(res);
> - BUG();
> }
> return ret;
> } 
> 
> 
> Node 3
> Dec 26 23:29:40 cvknode55 kernel: [ 7708.864231] (mount.ocfs2,6023,1):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -92 send CREATE LOCK to node 3
> Dec 26 23:29:40 cvknode55 kernel: [ 7708.968289] (mount.ocfs2,6023,1):dlm_send_remote_lock_request:332 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, Error -92 send CREATE LOCK to node
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.066019] o2dlm: Node 3 joins domain E496D3D3799A46E6AC4251B4F7FBFFDF ( 1 3 ) 2 nodes 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.072297] (mount.ocfs2,6023,1):__ocfs2_cluster_lock:1486 ERROR: DLM error -22 while calling ocfs2_dlm_lock on resource M0000000000000000000268e0ecb551 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.072302] (mount.ocfs2,6023,1):ocfs2_inode_lock_full_nested:2333 ERROR: status = -22 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.072305] (mount.ocfs2,6023,1):ocfs2_journal_init:860 ERROR: Could not get lock on journal! 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.072308] (mount.ocfs2,6023,1):ocfs2_check_volume:2433 ERROR: Could not initialize journal! 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.072311] (mount.ocfs2,6023,1):ocfs2_check_volume:2510 ERROR: status = -22 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.072314] (mount.ocfs2,6023,1):ocfs2_mount_volume:1889 ERROR: status = -22 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212472] (dlm_thread,6313,2):dlm_drop_lockres_ref:2316 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF: res M0000000000000000000268e0ecb551, DEREF to node 3 got -22 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212479] lockres: M0000000000000000000268e0ecb551, owner=3, state=64 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212480] last used: 4296818545, refcnt: 3, on purge list: yes 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212481] on dirty list: no, on reco list: no, migrating pending: no 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212482] inflight locks: 0, asts reserved: 0 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212483] refmap nodes: [ ], inflight=0 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212484] res lvb: 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212485] granted queue: 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212486] converting queue: 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212487] blocked queue: 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212509] ------------[ cut here ]------------ 
> Dec 26 23:29:40 cvknode55 kernel: [ 7709.212511] Kernel BUG at ffffffffa02f4471 [verbose debug info unavailable] 
> 
> 
> Node 1
> Dec 26 23:31:07 cvknode21 kernel: [ 153.221008] Sleep 5 seconds for live map build up. 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.225039] o2dlm: Joining domain E496D3D3799A46E6AC4251B4F7FBFFDF ( 1 3 ) 2 nodes 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.231096] (kworker/u65:3,502,8):dlm_create_lock_handler:513 ERROR: dlm status = DLM_IVLOCKID 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.303089] JBD2: Ignoring recovery information on journal 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369080] (mount.ocfs2,6151,2):ocfs2_load_local_alloc:354 ERROR: Local alloc hasn't been recovered! 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369080] found = 70, set = 70, taken = 256, off = 161793 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369080] umount left unclean filesystem. run ocfs2.fsck -f 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369090] (mount.ocfs2,6151,2):ocfs2_load_local_alloc:371 ERROR: status = -22 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369093] (mount.ocfs2,6151,2):ocfs2_check_volume:2481 ERROR: status = -22 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369096] (mount.ocfs2,6151,2):ocfs2_check_volume:2510 ERROR: status = -22 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.369099] (mount.ocfs2,6151,2):ocfs2_mount_volume:1889 ERROR: status = -22 
> Dec 26 23:31:12 cvknode21 kernel: [ 158.371208] (kworker/u65:3,502,8):dlm_deref_lockres_handler:2361 ERROR: E496D3D3799A46E6AC4251B4F7FBFFDF:M0000000000000000000268e0ecb551: bad lockres name 
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------!
---
> zhangguanghui
> 
>      
>     *From:* ocfs2-users-bounces at oss.oracle.com <mailto:ocfs2-users-bounces@oss.oracle.com>
>     *Date:* 2015-12-22 21:47
>     *To:* Joseph Qi <mailto:joseph.qi@huawei.com>
>     *CC:* Siva Sokkumuthu <mailto:sivakumar@zohocorp.com>; ocfs2-users at oss.oracle.com <mailto:ocfs2-users@oss.oracle.com>
>     *Subject:* Re: [Ocfs2-users] Ocfs2 clients hang
>     Hi Joseph,
> 
>               We are facing ocfs2 server hang problem frequently and suddenly 4 nodes going to hang stat expect 1 node. After reboot everything is come to normal, this behavior happend many times. Do we have any debug and fix for this issue.
> 
>     Regards
>     Prabu
> 
> 
>     ---- On Tue, 22 Dec 2015 16:30:52 +0530 *Joseph Qi <joseph.qi@huawei.com>*wrote ----
> 
>         Hi Prabu,
>         From the log you provided, I can only see that node 5 disconnected with
>         node 2, 3, 1 and 4. It seemed that something wrong happened on the four
>         nodes, and node 5 did recovery for them. After that, the four nodes
>         joined again.
> 
>         On 2015/12/22 16:23, gjprabu wrote:
>         > Hi,
>         >
>         > Anybody please help me on this issue.
>         >
>         > Regards
>         > Prabu
>         >
>         > ---- On Mon, 21 Dec 2015 15:16:49 +0530 *gjprabu <gjprabu at zohocorp.com <mailto:gjprabu@zohocorp.com>>*wrote ----
>         >
>         > Dear Team,
>         >
>         > Ocfs2 clients are getting hang often and unusable. Please find the logs. Kindly provide the solution, it will be highly appreciated.
>         >
>         >
>         > [3659684.042530] o2dlm: Node 4 joins domain A895BC216BE641A8A7E20AA89D57E051 ( 1 2 3 4 5 ) 5 nodes
>         >
>         > [3992993.101490] (kworker/u192:1,63211,24):dlm_create_lock_handler:515 ERROR: dlm status = DLM_IVLOCKID
>         > [3993002.193285] (kworker/u192:1,63211,24):dlm_deref_lockres_handler:2267 ERROR: A895BC216BE641A8A7E20AA89D57E051:M0000000000000062d2dcd000000000: bad lockres name
>         > [3993032.457220] (kworker/u192:0,67418,11):dlm_do_assert_master:1680 ERROR: Error -112 when sending message 502 (key 0xc3460ae7) to node 2
>         > [3993062.547989] (kworker/u192:0,67418,11):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 2
>         > [3993064.860776] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 2
>         > [3993064.860804] o2cb: o2dlm has evicted node 2 from domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993073.280062] o2dlm: Begin recovery on domain A895BC216BE641A8A7E20AA89D57E051 for node 2
>         > [3993094.623695] (dlm_thread,46268,8):dlm_send_proxy_ast_msg:484 ERROR: A895BC216BE641A8A7E20AA89D57E051: res S000000000000000000000200000000, error -112 send AST to node 4
>         > [3993094.624281] (dlm_thread,46268,8):dlm_flush_asts:605 ERROR: status = -112
>         > [3993094.687668] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -112 when sending message 502 (key 0xc3460ae7) to node 3
>         > [3993094.815662] (dlm_reco_thread,46269,7):dlm_do_master_requery:1666 ERROR: Error -112 when sending message 514 (key 0xc3460ae7) to node 1
>         > [3993094.816118] (dlm_reco_thread,46269,7):dlm_pre_master_reco_lockres:2166 ERROR: status = -112
>         > [3993124.778525] (dlm_reco_thread,46269,7):dlm_do_master_requery:1666 ERROR: Error -107 when sending message 514 (key 0xc3460ae7) to node 3
>         > [3993124.779032] (dlm_reco_thread,46269,7):dlm_pre_master_reco_lockres:2166 ERROR: status = -107
>         > [3993133.332516] o2cb: o2dlm has evicted node 3 from domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993139.915122] o2cb: o2dlm has evicted node 1 from domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993147.071956] o2cb: o2dlm has evicted node 4 from domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993147.071968] (dlm_reco_thread,46269,7):dlm_do_master_requery:1666 ERROR: Error -107 when sending message 514 (key 0xc3460ae7) to node 4
>         > [3993147.071975] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 4
>         > [3993147.071997] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 4
>         > [3993147.072001] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 4
>         > [3993147.072005] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 4
>         > [3993147.072009] (kworker/u192:0,67418,15):dlm_do_assert_master:1680 ERROR: Error -107 when sending message 502 (key 0xc3460ae7) to node 4
>         > [3993147.075019] (dlm_reco_thread,46269,7):dlm_pre_master_reco_lockres:2166 ERROR: status = -107
>         > [3993147.075353] (dlm_reco_thread,46269,7):dlm_do_master_request:1347 ERROR: link to 1 went down!
>         > [3993147.075701] (dlm_reco_thread,46269,7):dlm_get_lock_resource:932 ERROR: status = -107
>         > [3993147.076001] (dlm_reco_thread,46269,7):dlm_do_master_request:1347 ERROR: link to 3 went down!
>         > [3993147.076329] (dlm_reco_thread,46269,7):dlm_get_lock_resource:932 ERROR: status = -107
>         > [3993147.076634] (dlm_reco_thread,46269,7):dlm_do_master_request:1347 ERROR: link to 4 went down!
>         > [3993147.076968] (dlm_reco_thread,46269,7):dlm_get_lock_resource:932 ERROR: status = -107
>         > [3993147.077275] (dlm_reco_thread,46269,7):dlm_restart_lock_mastery:1236 ERROR: node down! 1
>         > [3993147.077591] (dlm_reco_thread,46269,7):dlm_restart_lock_mastery:1229 node 3 up while restarting
>         > [3993147.077594] (dlm_reco_thread,46269,7):dlm_wait_for_lock_mastery:1053 ERROR: status = -11
>         > [3993155.171570] (dlm_reco_thread,46269,7):dlm_do_master_request:1347 ERROR: link to 3 went down!
>         > [3993155.171874] (dlm_reco_thread,46269,7):dlm_get_lock_resource:932 ERROR: status = -107
>         > [3993155.172150] (dlm_reco_thread,46269,7):dlm_do_master_request:1347 ERROR: link to 4 went down!
>         > [3993155.172446] (dlm_reco_thread,46269,7):dlm_get_lock_resource:932 ERROR: status = -107
>         > [3993155.172719] (dlm_reco_thread,46269,7):dlm_restart_lock_mastery:1236 ERROR: node down! 3
>         > [3993155.173001] (dlm_reco_thread,46269,7):dlm_restart_lock_mastery:1229 node 4 up while restarting
>         > [3993155.173003] (dlm_reco_thread,46269,7):dlm_wait_for_lock_mastery:1053 ERROR: status = -11
>         > [3993155.173283] (dlm_reco_thread,46269,7):dlm_do_master_request:1347 ERROR: link to 4 went down!
>         > [3993155.173581] (dlm_reco_thread,46269,7):dlm_get_lock_resource:932 ERROR: status = -107
>         > [3993155.173858] (dlm_reco_thread,46269,7):dlm_restart_lock_mastery:1236 ERROR: node down! 4
>         > [3993155.174135] (dlm_reco_thread,46269,7):dlm_wait_for_lock_mastery:1053 ERROR: status = -11
>         > [3993155.174458] o2dlm: Node 5 (me) is the Recovery Master for the dead node 2 in domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993158.361220] o2dlm: End recovery on domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993158.361228] o2dlm: Begin recovery on domain A895BC216BE641A8A7E20AA89D57E051 for node 1
>         > [3993158.361305] o2dlm: Node 5 (me) is the Recovery Master for the dead node 1 in domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993161.833543] o2dlm: End recovery on domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993161.833551] o2dlm: Begin recovery on domain A895BC216BE641A8A7E20AA89D57E051 for node 3
>         > [3993161.833620] o2dlm: Node 5 (me) is the Recovery Master for the dead node 3 in domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993165.188817] o2dlm: End recovery on domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993165.188826] o2dlm: Begin recovery on domain A895BC216BE641A8A7E20AA89D57E051 for node 4
>         > [3993165.188907] o2dlm: Node 5 (me) is the Recovery Master for the dead node 4 in domain A895BC216BE641A8A7E20AA89D57E051
>         > [3993168.551610] o2dlm: End recovery on domain A895BC216BE641A8A7E20AA89D57E051
>         >
>         > [3996486.869628] o2dlm: Node 4 joins domain A895BC216BE641A8A7E20AA89D57E051 ( 4 5 ) 2 nodes
>         > [3996778.703664] o2dlm: Node 4 leaves domain A895BC216BE641A8A7E20AA89D57E051 ( 5 ) 1 nodes
>         > [3997012.295536] o2dlm: Node 2 joins domain A895BC216BE641A8A7E20AA89D57E051 ( 2 5 ) 2 nodes
>         > [3997099.498157] o2dlm: Node 4 joins domain A895BC216BE641A8A7E20AA89D57E051 ( 2 4 5 ) 3 nodes
>         > [3997783.633140] o2dlm: Node 1 joins domain A895BC216BE641A8A7E20AA89D57E051 ( 1 2 4 5 ) 4 nodes
>         > [3997864.039868] o2dlm: Node 3 joins domain A895BC216BE641A8A7E20AA89D57E051 ( 1 2 3 4 5 ) 5 nodes
>         >
>         > Regards
>         > Prabu
>         > **
>         >
>         >
>         >
>         >
>         >
>         > _______________________________________________
>         > Ocfs2-users mailing list
>         > Ocfs2-users at oss.oracle.com <mailto:Ocfs2-users@oss.oracle.com>
>         > https://oss.oracle.com/mailman/listinfo/ocfs2-users
>         >
> 
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
