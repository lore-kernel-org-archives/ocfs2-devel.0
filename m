From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Tue, 3 May 2016 08:17:50 +0000
Subject: [Ocfs2-devel] Reviews: Ocfs2-devel Digest, Vol 142, Issue 3
References: <mailman.932.1449055200.24165.ocfs2-devel@oss.oracle.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB5375E1A7ABE@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi  Joseph

After a repeated test, This patch which may solve some problems, but not all cases, run fsck offline and a separate fix to fsck is needed. Thanks,

in ocfs2_block_group_clear_bits, jbd_lock_bh_state and jbd_unlock_bh_state is not in pair in some case.


Apr 29 18:42:11 cvk53 kernel: [31836.074181] (mount.ocfs2,35204,6):ocfs2_load_local_alloc:353 ERROR: Local alloc hasn't been recovered!
Apr 29 18:42:11 cvk53 kernel: [31836.074181] found = 1011, set = 1011, taken = 2048, off = 387073
Apr 29 18:42:11 cvk53 kernel: [31836.074193] (mount.ocfs2,35204,6):ocfs2_load_local_alloc:373 ERROR: status = -22
Apr 29 18:42:11 cvk53 kernel: [31836.074198] ocfs2: local alloc needs recovery on device (252,0).
Apr 29 18:42:11 cvk53 kernel: [31836.099410] ocfs2: Mounting device (252,0) on (node 1, slot 1) with ordered data mode.
Apr 29 18:42:11 cvk53 kernel: [31836.101379] OCFS2: ERROR (device dm-0): ocfs2_block_group_clear_bits: Group descriptor # 99090432 has bit count 32256 but claims 32281 are freed. num_bits 1037
Apr 29 18:42:11 cvk53 kernel: [31836.101388] File system is now read-only due to the potential of on-disk corruption. Please run fsck.ocfs2 once the file system is unmounted.
Apr 29 18:42:11 cvk53 kernel: [31836.101394] (kworker/u128:0,29935,6):_ocfs2_free_suballoc_bits:2498 ERROR: status = -30
Apr 29 18:42:11 cvk53 kernel: [31836.101399] (kworker/u128:0,29935,6):_ocfs2_free_suballoc_bits:2521 ERROR: status = -30
Apr 29 18:42:11 cvk53 kernel: [31836.101404] (kworker/u128:0,29935,6):_ocfs2_free_clusters:2584 ERROR: status = -30
Apr 29 18:42:11 cvk53 kernel: [31836.101409] (kworker/u128:0,29935,6):_ocfs2_free_clusters:2593 ERROR: status = -30
Apr 29 18:42:11 cvk53 kernel: [31836.101414] (kworker/u128:0,29935,6):ocfs2_sync_local_to_main:1025 ERROR: status = -30
Apr 29 18:42:11 cvk53 kernel: [31836.101419] (kworker/u128:0,29935,6):ocfs2_sync_local_to_main:1037 ERROR: status = -30
Apr 29 18:42:11 cvk53 kernel: [31836.101424] (kworker/u128:0,29935,6):ocfs2_complete_local_alloc_recovery:606 ERROR: status = -30
Apr 29 18:42:12 cvk53 kernel: [31836.247874] chbk: chbk_store_chk_report 2971: store check result: store wlf2-500g is normal
Apr 29 18:42:36 cvk53 kernel: [31861.231311] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 23s! [jbd2/dm-0-617:35472]
Apr 29 18:42:36 cvk53 kernel: [31861.231320] Modules linked in: ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) ebtable_nat(E) ebtables(E) x_tables(E) ocfs2(OE) quota_tree(E) cls_u32(E) sch_sfq(E) sch_htb(E) chbk(OE) drbd(E) lru_cache(E) 8021q(E) mrp(E) garp(E) stp(E) llc(E) ipmi_devintf(E) dm_round_robin(E) vhost_net(E) macvtap(E) macvlan(E) vhost(E) kvm_intel(OE) kvm(OE) ib_iser(E) rdma_cm(E) ib_cm(E) iw_cm(E) ib_sa(E) ib_mad(E) ib_core(E) ib_addr(E) iscsi_tcp(E) libiscsi_tcp(E) ocfs2_dlmfs(OE) ocfs2_stack_o2cb(OE) ocfs2_dlm(OE) ocfs2_nodemanager(OE) ocfs2_stackglue(OE) configfs(E) dm_multipath(E) scsi_dh(E) openvswitch(OE) nf_conntrack(E) nf_defrag_ipv4(E) gre(E) libcrc32c(E) nf_defrag_ipv6(E) nfsd(E) nfs_acl(E) auth_rpcgss(E) nfs(E) fscache(E) lockd(E) sunrpc(E) grace(E) ipmi_ssif(E) psmouse(E) serio_raw(E) sb_edac(E) edac_core(E) lpc_ich(E) hpwdt(E) hpilo(E) ioatdma(E) dca(E) 8250_fintek(E) ipmi_si(E) ipmi_msghandler(E) video(E) wmi(E) mac_hid(E) acpi_power_meter(E) lp(E) parport(E) be2iscs
Apr 29 18:42:36 cvk53 kernel: i(E) iscsi_boot_sysfs(E) libiscsi(E) be2net(E) scsi_transport_iscsi(E) vxlan(E) hpsa(E) udp_tunnel(E) ip6_udp_tunnel(E) nbd(E)
Apr 29 18:42:36 cvk53 kernel: [31861.231367] CPU: 6 PID: 35472 Comm: jbd2/dm-0-617 Tainted: G OE 4.1.0-generic #1
Apr 29 18:42:36 cvk53 kernel: [31861.231369] Hardware name: H3C FlexServer B390, BIOS I31 12/20/2013
Apr 29 18:42:36 cvk53 kernel: [31861.231370] task: ffff8801fd3c8a10 ti: ffff8807cdc4c000 task.ti: ffff8807cdc4c000
Apr 29 18:42:36 cvk53 kernel: [31861.231371] RIP: 0010:[<ffffffff812e06b3>] [<ffffffff812e06b3>] jbd2_journal_commit_transaction+0xc03/0x1aa0
Apr 29 18:42:36 cvk53 kernel: [31861.231379] RSP: 0018:ffff8807cdc4fc58 EFLAGS: 00000206
Apr 29 18:42:36 cvk53 kernel: [31861.231380] RAX: 0000000000a20029 RBX: ffffffff812e7f48 RCX: 3ffffffffffffffe
Apr 29 18:42:36 cvk53 kernel: [31861.231381] RDX: 0000000000000000 RSI: 000000010078349b RDI: ffff88040ec34f60
Apr 29 18:42:36 cvk53 kernel: [31861.231382] RBP: ffff8807cdc4fe28 R08: ffff8807cdc4c000 R09: 0000000000000020
Apr 29 18:42:36 cvk53 kernel: [31861.231383] R10: 0000000000000002 R11: 0000000000000000 R12: ffff8803dec1e9c0
Apr 29 18:42:36 cvk53 kernel: [31861.231384] R13: ffff8807cdc4fbc8 R14: ffffffff81236f36 R15: ffff8807cdc4fbc8
Apr 29 18:42:36 cvk53 kernel: [31861.231385] FS: 0000000000000000(0000) GS:ffff88042f780000(0000) knlGS:0000000000000000
Apr 29 18:42:36 cvk53 kernel: [31861.231386] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 29 18:42:36 cvk53 kernel: [31861.231387] CR2: 0000000000bbd328 CR3: 0000000001c0f000 CR4: 00000000001406e0
Apr 29 18:42:36 cvk53 kernel: [31861.231388] Stack:
Apr 29 18:42:36 cvk53 kernel: [31861.231389] ffff8807cdc4fc68 ffff8801fd3c8a78 ffff88042fa97530 ffff8801fd3c8a78
Apr 29 18:42:36 cvk53 kernel: [31861.231391] ffff88042fa97530 0000000c00000000 ffff8807cdc4fcf8 ffff8802bb749000
Apr 29 18:42:36 cvk53 kernel: [31861.231393] 0000000000000000 ffff8803bb659024 ffff8807cdc4fce8 ffffffff810a85dc
Apr 29 18:42:36 cvk53 kernel: [31861.231395] Call Trace:
Apr 29 18:42:36 cvk53 kernel: [31861.231400] [<ffffffff810a85dc>] ? ttwu_do_wakeup+0x2c/0x110
Apr 29 18:42:36 cvk53 kernel: [31861.231403] [<ffffffff810bb055>] ? pick_next_task_fair+0x115/0x4d0
Apr 29 18:42:36 cvk53 kernel: [31861.231406] [<ffffffff81015686>] ? __switch_to+0x1e6/0x580
Apr 29 18:42:36 cvk53 kernel: [31861.231409] [<ffffffff810a50f5>] ? finish_task_switch+0xf5/0x150
Apr 29 18:42:36 cvk53 kernel: [31861.231413] [<ffffffff810e908f>] ? try_to_del_timer_sync+0x4f/0x70
Apr 29 18:42:36 cvk53 kernel: [31861.231415] [<ffffffff812e4d33>] kjournald2+0xb3/0x230
Apr 29 18:42:36 cvk53 kernel: [31861.231418] [<ffffffff810c10a0>] ? prepare_to_wait_event+0x100/0x100
Apr 29 18:42:36 cvk53 kernel: [31861.231419] [<ffffffff812e4c80>] ? commit_timeout+0x10/0x10
Apr 29 18:42:36 cvk53 kernel: [31861.231421] [<ffffffff8109def9>] kthread+0xc9/0xe0
Apr 29 18:42:36 cvk53 kernel: [31861.231422] [<ffffffff8109de30>] ? flush_kthread_worker+0x90/0x90
Apr 29 18:42:36 cvk53 kernel: [31861.231427] [<ffffffff817f6a22>] ret_from_fork+0x42/0x70
Apr 29 18:42:36 cvk53 kernel: [31861.231428] [<ffffffff8109de30>] ? flush_kthread_worker+0x90/0x90
Apr 29 18:42:36 cvk53 kernel: [31861.231429] Code: ff ff 00 00 00 00 48 89 8d 98 fe ff ff e9 06 fa ff ff 89 c6 4c 89 ef e8 0c 77 00 00 4d 8b 74 24 28 e9 f2 f9 ff ff f3 90 49 8b 06 <a9> 00 00 80 00 75 f4 e9 8b f6 ff ff 90 45 85 ff 0f 85 65 0e 00



Date: Wed, 2 Dec 2015 15:07:11 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix BUG due to uncleaned
        localalloc during mount
To: xuejiufei at huawei.com, Joseph Qi <joseph.qi@huawei.com>,     Andrew
        Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>,     "ocfs2-devel at oss.oracle.com"
        <ocfs2-devel@oss.oracle.com>
Message-ID: <565E989F.9020302@oracle.com>
Content-Type: text/plain; charset=windows-1252

On 12/02/2015 02:52 PM, Xue jiufei wrote:
> Hi Junxiao,
> On 2015/12/1 16:02, Junxiao Bi wrote:
>> Hi Joseph,
>>
>> On 11/24/2015 09:38 PM, Joseph Qi wrote:
>>> Tariq has reported a BUG before and posted a fix at:
>>> https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010696.html
>>>
>>> This is because during umount, localalloc shutdown relies on journal
>>> shutdown. But during journal shutdown, it just stops commit thread
>>> without checking its result. So it may happen that localalloc shutdown
>>> uncleaned during I/O error and after that, journal then has been marked
>>> clean if I/O restores.
>> The above is a storage issue. In this condition, io error can even
>> happen to journal commit, some transactions may have wrong data. Let fs
>> go without a fsck may cause corruption.
>> I am thinking whether we can fail the mount and mark the journal dirty
>> again. Then we can do fsck to it withoug a fsck patch.
>>
> Can you explain which situation would cause file system corruption. I think
> if IO error happens to journal commit and commit block have not reach the disk,
> the whole transactions is skipped while recovering the journal. So file system
> is still consistent.
At least local alloc inconsistent as this storage error, right? I think
it can't be sure whether this caused some other metadata inconsistent,
so a full fsck deserved.

Thanks,
Junxiao.

> Thanks,
> Xuejiufei
>
>> Thanks,
>> Junxiao.
>>
>>> Then during mount, localalloc won't be recovered because of clean
>>> journal and then trigger BUG when claiming clusters from localalloc.
>>>
>>> In Tariq's fix, we have to run fsck offline and a separate fix to fsck
>>> is needed because it currently does not support clearing out localalloc
>>> inode. And my way to fix this issue is checking localalloc before
>>> actually loading it during mount. And this is somewhat online.
>>>
>>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>>> ---
>>>  fs/ocfs2/localalloc.c | 19 ++++++++++++-------
>>>  fs/ocfs2/localalloc.h |  2 +-
>>>  fs/ocfs2/super.c      | 17 ++++++++++++++---
>>>  3 files changed, 27 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>>> index 0a4457f..ceebaef 100644
>>> --- a/fs/ocfs2/localalloc.c
>>> +++ b/fs/ocfs2/localalloc.c
>>> @@ -281,7 +281,7 @@ bail:
>>>     return ret;
>>>  }
>>>
>>> -int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>>> +int ocfs2_load_local_alloc(struct ocfs2_super *osb, int check, int *recovery)
>>>  {
>>>     int status = 0;
>>>     struct ocfs2_dinode *alloc = NULL;
>>> @@ -345,21 +345,26 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>>>     if (num_used
>>>         || alloc->id1.bitmap1.i_used
>>>         || alloc->id1.bitmap1.i_total
>>> -       || la->la_bm_off)
>>> +       || la->la_bm_off) {
>>>             mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
>>>                  "found = %u, set = %u, taken = %u, off = %u\n",
>>>                  num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
>>>                  le32_to_cpu(alloc->id1.bitmap1.i_total),
>>>                  OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
>>> +           status = -EINVAL;
>>> +           *recovery = 1;
>>> +           goto bail;
>>> +   }
>>>
>>> -   osb->local_alloc_bh = alloc_bh;
>>> -   osb->local_alloc_state = OCFS2_LA_ENABLED;
>>> +   if (!check) {
>>> +           osb->local_alloc_bh = alloc_bh;
>>> +           osb->local_alloc_state = OCFS2_LA_ENABLED;
>>> +   }
>>>
>>>  bail:
>>> -   if (status < 0)
>>> +   if (status < 0 || check)
>>>             brelse(alloc_bh);
>>> -   if (inode)
>>> -           iput(inode);
>>> +   iput(inode);
>>>
>>>     trace_ocfs2_load_local_alloc(osb->local_alloc_bits);
>>>
>>> diff --git a/fs/ocfs2/localalloc.h b/fs/ocfs2/localalloc.h
>>> index 44a7d1f..a913841 100644
>>> --- a/fs/ocfs2/localalloc.h
>>> +++ b/fs/ocfs2/localalloc.h
>>> @@ -26,7 +26,7 @@
>>>  #ifndef OCFS2_LOCALALLOC_H
>>>  #define OCFS2_LOCALALLOC_H
>>>
>>> -int ocfs2_load_local_alloc(struct ocfs2_super *osb);
>>> +int ocfs2_load_local_alloc(struct ocfs2_super *osb, int check, int *recovery);
>>>
>>>  void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb);
>>>
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index 2de4c8a..4004b29 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -2428,6 +2428,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>>     int status;
>>>     int dirty;
>>>     int local;
>>> +   int la_dirty = 0, recovery = 0;
>>>     struct ocfs2_dinode *local_alloc = NULL; /* only used if we
>>>                                               * recover
>>>                                               * ourselves. */
>>> @@ -2449,6 +2450,16 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>>      * recover anything. Otherwise, journal_load will do that
>>>      * dirty work for us :) */
>>>     if (!dirty) {
>>> +           /* It may happen that local alloc is unclean shutdown, but
>>> +            * journal has been marked clean, so check it here and do
>>> +            * recovery if needed */
>>> +           status = ocfs2_load_local_alloc(osb, 1, &recovery);
>>> +           if (recovery) {
>>> +                   printk(KERN_NOTICE "ocfs2: local alloc needs recovery "
>>> +                                   "on device (%s).\n", osb->dev_str);
>>> +                   la_dirty = 1;
>>> +           }
>>> +
>>>             status = ocfs2_journal_wipe(osb->journal, 0);
>>>             if (status < 0) {
>>>                     mlog_errno(status);
>>> @@ -2477,7 +2488,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>>                             JBD2_FEATURE_COMPAT_CHECKSUM, 0,
>>>                             JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
>>>
>>> -   if (dirty) {
>>> +   if (dirty || la_dirty) {
>>>             /* recover my local alloc if we didn't unmount cleanly. */
>>>             status = ocfs2_begin_local_alloc_recovery(osb,
>>>                                                       osb->slot_num,
>>> @@ -2490,13 +2501,13 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>>              * ourselves as mounted. */
>>>     }
>>>
>>> -   status = ocfs2_load_local_alloc(osb);
>>> +   status = ocfs2_load_local_alloc(osb, 0, &recovery);
>>>     if (status < 0) {
>>>             mlog_errno(status);
>>>             goto finally;
>>>     }
>>>
>>> -   if (dirty) {
>>> +   if (dirty || la_dirty) {
>>>             /* Recovery will be completed after we've mounted the
>>>              * rest of the volume. */
>>>             osb->dirty = 1;
>>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>> .
>>
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160503/bc28cf72/attachment-0001.html 
