From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 19 Dec 2016 17:55:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix crash caused by stale lvb with
	fsdlm plugin
In-Reply-To: <66edad7f-6c83-a5e0-aab3-d3a034667042@suse.com>
References: <1481275846-6604-1-git-send-email-zren@suse.com>
	<7dbdc1d8-f1c5-c6bf-0614-1d8f03f0e3f0@gmail.com>
	<66edad7f-6c83-a5e0-aab3-d3a034667042@suse.com>
Message-ID: <6ddf36d1-9e2b-f094-77a4-6ec6d6661dc2@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Ren <zren@suse.com>, ocfs2-devel@oss.oracle.com
Cc: akpm@linux-foundation.org, mfasheh@versity.com, jlbec@evilplan.org, teigland@redhat.com, ghe@suse.com, junxiao.bi@oracle.com, linux-kernel@vger.kernel.org


On 16/12/15 10:27, Eric Ren wrote:
> Hi,
>
> On 12/15/2016 09:46 AM, Joseph Qi wrote:
>> In you description, this issue can only happen in case of stack user +
>>
>> fsdlm.
> Yes.
>>
>> So I feel we'd better to make stack user and o2cb behaves the same,
>>
>> other than treat it as a special case.
> Yes, I agree. But, actually, there is nothing wrong with fsdlm. I 
> think o2cb does some tricks
> with  DLM_LKF_VALBLK flag in such a special case where down conversion 
> is PR->NULL.
>
> I'd like to see this quick and small fix to be merged at this moment, 
> because this issue is little emergency for us.
> Anyway, we can supersede this one easily if someone familiar with o2cb 
> works out a patch for o2cb in the future.
>
> Does this sounds good to you?

Fine.
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

Thanks,
Joseph
>
> Thanks,
> Eric
>>
>>
>> Thanks,
>>
>> Joseph
>>
>> On 16/12/9 17:30, Eric Ren wrote:
>>> The crash happens rather often when we reset some cluster
>>> nodes while nodes contend fiercely to do truncate and append.
>>>
>>> The crash backtrace is below:
>>> "
>>> [  245.197849] dlm: C21CBDA5E0774F4BA5A9D4F317717495: 
>>> dlm_recover_grant 1 locks on 971 resources
>>> [  245.197859] dlm: C21CBDA5E0774F4BA5A9D4F317717495: dlm_recover 9 
>>> generation 5 done: 4 ms
>>> [  245.198379] ocfs2: Begin replay journal (node 318952601, slot 2) 
>>> on device (253,18)
>>> [  247.272338] ocfs2: End replay journal (node 318952601, slot 2) on 
>>> device (253,18)
>>> [  247.547084] ocfs2: Beginning quota recovery on device (253,18) 
>>> for slot 2
>>> [  247.683263] ocfs2: Finishing quota recovery on device (253,18) 
>>> for slot 2
>>> [  247.833022] (truncate,30154,1):ocfs2_truncate_file:470 ERROR: bug 
>>> expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
>>> [  247.833029] (truncate,30154,1):ocfs2_truncate_file:470 ERROR: 
>>> Inode 290321, inode i_size = 732 != di i_size = 937, i_flags = 0x1
>>> [  247.833074] ------------[ cut here ]------------
>>> [  247.833077] kernel BUG at /usr/src/linux/fs/ocfs2/file.c:470!
>>> [  247.833079] invalid opcode: 0000 [#1] SMP
>>> [  247.833081] Modules linked in: ocfs2_stack_user(OEN) ocfs2(OEN) 
>>> ocfs2_nodemanager ocfs2_stackglue(OEN) quota_tree dlm(OEN) configfs 
>>> fuse sd_mod    iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi 
>>> af_packet iscsi_ibft iscsi_boot_sysfs softdog xfs libcrc32c ppdev 
>>> parport_pc pcspkr parport joydev virtio_balloon virtio_net i2c_piix4 
>>> acpi_cpufreq button processor ext4 crc16 jbd2 mbcache ata_generic 
>>> cirrus virtio_blk ata_piix drm_kms_helper ahci syscopyarea libahci 
>>> sysfillrect sysimgblt fb_sys_fops ttm floppy libata drm virtio_pci 
>>> virtio_ring uhci_hcd virtio ehci_hcd       usbcore serio_raw 
>>> usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc 
>>> scsi_dh_alua scsi_mod autofs4
>>> [  247.833107] Supported: No, Unsupported modules are loaded
>>> [  247.833110] CPU: 1 PID: 30154 Comm: truncate Tainted: G           
>>> OE   N  4.4.21-69-default #1
>>> [  247.833111] Hardware name: QEMU Standard PC (i440FX + PIIX, 
>>> 1996), BIOS rel-1.8.1-0-g4adadbd-20151112_172657-sheep25 04/01/2014
>>> [  247.833112] task: ffff88004ff6d240 ti: ffff880074e68000 task.ti: 
>>> ffff880074e68000
>>> [  247.833113] RIP: 0010:[<ffffffffa05c8c30>] [<ffffffffa05c8c30>] 
>>> ocfs2_truncate_file+0x640/0x6c0 [ocfs2]
>>> [  247.833151] RSP: 0018:ffff880074e6bd50  EFLAGS: 00010282
>>> [  247.833152] RAX: 0000000000000074 RBX: 000000000000029e RCX: 
>>> 0000000000000000
>>> [  247.833153] RDX: 0000000000000001 RSI: 0000000000000246 RDI: 
>>> 0000000000000246
>>> [  247.833154] RBP: ffff880074e6bda8 R08: 000000003675dc7a R09: 
>>> ffffffff82013414
>>> [  247.833155] R10: 0000000000034c50 R11: 0000000000000000 R12: 
>>> ffff88003aab3448
>>> [  247.833156] R13: 00000000000002dc R14: 0000000000046e11 R15: 
>>> 0000000000000020
>>> [  247.833157] FS:  00007f839f965700(0000) GS:ffff88007fc80000(0000) 
>>> knlGS:0000000000000000
>>> [  247.833158] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [  247.833159] CR2: 00007f839f97e000 CR3: 0000000036723000 CR4: 
>>> 00000000000006e0
>>> [  247.833164] Stack:
>>> [  247.833165]  00000000000003a9 0000000000000001 ffff880060554000 
>>> ffff88004fcaf000
>>> [  247.833167]  ffff88003aa7b090 1000000000000000 ffff88003aab3448 
>>> ffff880074e6beb0
>>> [  247.833169]  0000000000000001 0000000000002068 0000000000000020 
>>> 0000000000000000
>>> [  247.833171] Call Trace:
>>> [  247.833208]  [<ffffffffa05cb1a8>] ocfs2_setattr+0x698/0xa90 [ocfs2]
>>> [  247.833225]  [<ffffffff8121587e>] notify_change+0x1ae/0x380
>>> [  247.833242]  [<ffffffff811f8bfe>] do_truncate+0x5e/0x90
>>> [  247.833246]  [<ffffffff811f8f58>] 
>>> do_sys_ftruncate.constprop.11+0x108/0x160
>>> [  247.833257]  [<ffffffff815e142e>] 
>>> entry_SYSCALL_64_fastpath+0x12/0x6d
>>> [  247.834724] DWARF2 unwinder stuck at 
>>> entry_SYSCALL_64_fastpath+0x12/0x6d
>>> [  247.834725]
>>> [  247.834726] Leftover inexact backtrace:
>>>
>>> [  247.834728] Code: 24 28 ba d6 01 00 00 48 c7 c6 30 43 62 a0 8b 41 
>>> 2c 89 44 24 08 48 8b 41 20 48 c7 c1 78 a3 62 a0 48 89 04 24 31 c0 e8 
>>> a0 97 f9 ff <0f> 0b 3d 00 fe ff ff 0f 84 ab fd ff ff 83 f8 fc 0f 84 
>>> a2 fd ff
>>> [  247.834748] RIP  [<ffffffffa05c8c30>] 
>>> ocfs2_truncate_file+0x640/0x6c0 [ocfs2]
>>> [  247.834774]  RSP <ffff880074e6bd50>
>>> "
>>>
>>> It's because ocfs2_inode_lock() get us stale LVB in which the i_size 
>>> is not
>>> equal to the disk i_size. We mistakenly trust the LVB because the 
>>> underlaying
>>> fsdlm dlm_lock() doesn't set lkb_sbflags with DLM_SBF_VALNOTVALID 
>>> properly for
>>> us. But, why?
>>>
>>> The current code tries to downconvert lock without DLM_LKF_VALBLK
>>> flag to tell o2cb don't update RSB's LVB if it's a PR->NULL conversion,
>>> even if the lock resource type needs LVB. This is not the right way 
>>> for fsdlm.
>>>
>>> The fsdlm plugin behaves different on DLM_LKF_VALBLK, it depends on
>>> DLM_LKF_VALBLK to decide if we care about the LVB in the LKB. If 
>>> DLM_LKF_VALBLK
>>> is not set, fsdlm will skip recovering RSB's LVB from this lkb and 
>>> set the right
>>> DLM_SBF_VALNOTVALID appropriately when node failure happens.
>>>
>>> The following diagram briefly illustrates how this crash happens:
>>>
>>> RSB1 is inode metadata lock resource with LOCK_TYPE_USES_LVB;
>>>
>>> The 1st round:
>>>
>>>               Node1                                    Node2
>>> RSB1: PR
>>> RSB1(master): NULL->EX
>>> ocfs2_downconvert_lock(PR->NULL, set_lvb==0)
>>>    ocfs2_dlm_lock(no DLM_LKF_VALBLK)
>>>
>>> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
>>>
>>> dlm_lock(no DLM_LKF_VALBLK)
>>>    convert_lock(overwrite lkb->lkb_exflags
>>>                 with no DLM_LKF_VALBLK)
>>>
>>> RSB1: NULL                                        RSB1: EX
>>>                                                    reset Node2
>>> dlm_recover_rsbs()
>>>    recover_lvb()
>>>
>>> /* The LVB is not trustable if the node with EX fails and
>>>   * no lock >= PR is left. We should set RSB_VALNOTVALID for RSB1.
>>>   */
>>>
>>>   if(!(kb_exflags & DLM_LKF_VALBLK)) /* This means we miss the 
>>> chance to
>>>             return;                   * to invalid the LVB here.
>>>                                       */
>>>
>>> The 2nd round:
>>>
>>>           Node 1                                Node2
>>> RSB1(become master from recovery)
>>>
>>> ocfs2_setattr()
>>>    ocfs2_inode_lock(NULL->EX)
>>>      /* dlm_lock() return the stale lvb without setting 
>>> DLM_SBF_VALNOTVALID */
>>>      ocfs2_meta_lvb_is_trustable() return 1 /* so we don't refresh 
>>> inode from disk */
>>>    ocfs2_truncate_file()
>>>        mlog_bug_on_msg(disk isize != i_size_read(inode))  /* crash! */
>>>
>>> The fix is quite straightforward. We keep to set DLM_LKF_VALBLK flag 
>>> for dlm_lock()
>>> if the lock resource type needs LVB and the fsdlm plugin is uesed.
>>>
>>> Signed-off-by: Eric Ren <zren@suse.com>
>>> ---
>>>   fs/ocfs2/dlmglue.c   | 10 ++++++++++
>>>   fs/ocfs2/stackglue.c |  6 ++++++
>>>   fs/ocfs2/stackglue.h |  3 +++
>>>   3 files changed, 19 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>>> index 83d576f..77d1632 100644
>>> --- a/fs/ocfs2/dlmglue.c
>>> +++ b/fs/ocfs2/dlmglue.c
>>> @@ -3303,6 +3303,16 @@ static int ocfs2_downconvert_lock(struct 
>>> ocfs2_super *osb,
>>>       mlog(ML_BASTS, "lockres %s, level %d => %d\n", lockres->l_name,
>>>            lockres->l_level, new_level);
>>>   +    /*
>>> +     * On DLM_LKF_VALBLK, fsdlm behaves differently with o2cb. It 
>>> always
>>> +     * expects DLM_LKF_VALBLK being set if the LKB has LVB, so that
>>> +     * we can recover correctly from node failure. Otherwise, we 
>>> may get
>>> +     * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
>>> +     */
>>> +    if (!ocfs2_is_o2cb_active() &&
>>> +        lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
>>> +        lvb = 1;
>>> +
>>>       if (lvb)
>>>           dlm_flags |= DLM_LKF_VALBLK;
>>>   diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
>>> index 52c07346b..8203590 100644
>>> --- a/fs/ocfs2/stackglue.c
>>> +++ b/fs/ocfs2/stackglue.c
>>> @@ -48,6 +48,12 @@ static char 
>>> ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
>>>    */
>>>   static struct ocfs2_stack_plugin *active_stack;
>>>   +inline int ocfs2_is_o2cb_active(void)
>>> +{
>>> +    return !strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_O2CB);
>>> +}
>>> +EXPORT_SYMBOL_GPL(ocfs2_is_o2cb_active);
>>> +
>>>   static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char 
>>> *name)
>>>   {
>>>       struct ocfs2_stack_plugin *p;
>>> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
>>> index f2dce10..e3036e1 100644
>>> --- a/fs/ocfs2/stackglue.h
>>> +++ b/fs/ocfs2/stackglue.h
>>> @@ -298,6 +298,9 @@ void 
>>> ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version 
>>> *max_p
>>>   int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
>>>   void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
>>>   +/* In ocfs2_downconvert_lock(), we need to know which stack we 
>>> are using */
>>> +int ocfs2_is_o2cb_active(void);
>>> +
>>>   extern struct kset *ocfs2_kset;
>>>     #endif  /* STACKGLUE_H */
>>
>>
>
