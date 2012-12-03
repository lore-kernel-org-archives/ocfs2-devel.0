From: Xiaowei <xiaowei.hu@oracle.com>
Date: Mon, 03 Dec 2012 16:51:00 +0800
Subject: [Ocfs2-devel] [PATCH] run out of jbd2 credits during discontig
 group alloc.
In-Reply-To: <50BC63CD.8020905@oracle.com>
References: <1352942423-26944-1-git-send-email-xiaowei.hu@oracle.com>
	<50BC376E.3070402@oracle.com> <50BC63CD.8020905@oracle.com>
Message-ID: <50BC67F4.7000907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi ,

Here is the crash info :
------------[ cut here ]------------
kernel BUG at fs/jbd2/transaction.c:1083!
invalid opcode: 0000 [#1] SMP
CPU 5
Modules linked in: ocfs2 jbd2 autofs4 hidp nfs fscache auth_rpcgss nfs_acl
rfcomm bluetooth rfkill ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
ocfs2_nodemanager ocfs2_stackglue configfs lockd sunrpc cpufreq_ondemand
@ acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs ib_iser 
rdma_cm ib_cm
@ iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i
@ libcxgbi cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror
video sbs sbshc acpi_pad acpi_memhotplug acpi_ipmi ipmi_msghandler 
parport_pc
lp parport sg sr_mod cdrom radeon bnx2 ttm drm_kms_helper drm snd_seq_dummy
i2c_algo_bit i2c_core snd_seq_oss serio_raw snd_seq_midi_event snd_seq
snd_seq_device iTCO_wdt snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd
soundcore iTCO_vendor_support snd_page_alloc pata_acpi ata_generic pcspkr
i5k_amb hwmon dcdbas i5000_edac edac_core ghes hed dm_region_hash dm_log
@ dm_mod usb_storage ata_piix shpchp mptsas mptscsih mptbase 
scsi_transport_sas
sd_mod crc_t10dif ext3 jbd mbcache [last unloaded: microcode]

Pid: 9945, comm: dd Not tainted 2.6.39-300.17.1.el5uek #1 Dell Inc. 
PowerEdge
1950/0M788G
RIP: 0010:[<ffffffffa0808b14>]  [<ffffffffa0808b14>]
jbd2_journal_dirty_metadata+0x164/0x170 [jbd2]
RSP: 0018:ffff8801b919b5b8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88022139ddc0 RCX: ffff880159f652d0
RDX: ffff880178aa3000 RSI: ffff880159f652d0 RDI: ffff880087f09bf8
RBP: ffff8801b919b5e8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001e00 R11: 00000000000150b0 R12: ffff880159f652d0
R13: ffff8801a0cae908 R14: ffff880087f09bf8 R15: ffff88018d177800
FS:  00007fc9b0b6b6e0(0000) GS:ffff88022fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000040819c CR3: 0000000184017000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dd (pid: 9945, threadinfo ffff8801b919a000, task ffff880149a264c0)
Stack:
  00000001b919b5c8 ffff880159f652d0 ffff8801f565cc70 ffff880087f09bf8
  000000000010e000 ffff88016da2f000 ffff8801b919b618 ffffffffa0865e4f
  0000000000000000 ffff8801f565cc70 ffff880159f652d0 ffff8801fdc76e40
Call Trace:
  [<ffffffffa0865e4f>] ocfs2_journal_dirty+0x2f/0x70 [ocfs2]
  [<ffffffffa0889441>] ocfs2_relink_block_group+0x111/0x480 [ocfs2]
  [<ffffffffa088cda5>] ocfs2_search_chain+0x455/0x9a0 [ocfs2]
  [<ffffffff81116db3>] ? get_page_from_freelist+0x183/0x450
  [<ffffffffa088d40f>] ocfs2_claim_suballoc_bits+0x11f/0x5a0 [ocfs2]
  [<ffffffffa080921c>] ? do_get_write_access+0x1ec/0x4c0 [jbd2]
  [<ffffffffa088d9b5>] __ocfs2_claim_clusters+0x125/0x370 [ocfs2]
  [<ffffffffa088dc1d>] ocfs2_claim_clusters+0x1d/0x20 [ocfs2]
  [<ffffffffa088dc67>] ocfs2_block_group_claim_bits+0x47/0x60 [ocfs2]
  [<ffffffffa088ddb4>] ocfs2_block_group_grow_discontig+0x134/0x250 [ocfs2]
  [<ffffffffa088e13b>] ocfs2_block_group_alloc_discontig+0x26b/0x4f0 [ocfs2]
  [<ffffffffa088dc1d>] ? ocfs2_claim_clusters+0x1d/0x20 [ocfs2]
  [<ffffffffa088ebde>] ocfs2_block_group_alloc+0x50e/0x5b0 [ocfs2]
  [<ffffffffa088ef23>] ocfs2_reserve_suballoc_bits+0x2a3/0x460 [ocfs2]
  [<ffffffff8115aac9>] ? kmem_cache_alloc_trace+0xc9/0x1a0
  [<ffffffffa088fd6d>] ocfs2_reserve_new_inode+0x10d/0x430 [ocfs2]
  [<ffffffffa0874d69>] ocfs2_mknod+0x419/0x10d0 [ocfs2]
  [<ffffffffa084b55e>] ? ocfs2_find_entry+0x4e/0xb0 [ocfs2]
  [<ffffffffa084b753>] ? ocfs2_find_files_on_disk+0x53/0xc0 [ocfs2]
  [<ffffffffa0875a83>] ocfs2_create+0x63/0x150 [ocfs2]
  [<ffffffff8117b1c1>] vfs_create+0xb1/0x110
  [<ffffffff8117cb83>] do_last+0x513/0x740
  [<ffffffff8117d7cb>] path_openat+0xcb/0x400
  [<ffffffff81507e5e>] ? _raw_spin_lock+0xe/0x20
  [<ffffffff811326b8>] ? __pte_alloc+0xb8/0x160
  [<ffffffff8117dc28>] do_filp_open+0x48/0xa0
  [<ffffffff81260ae3>] ? strncpy_from_user+0x43/0x50
  [<ffffffff8117a9e9>] ? do_getname+0x39/0x170
  [<ffffffff81507e5e>] ? _raw_spin_lock+0xe/0x20
  [<ffffffff8118ab2a>] ? alloc_fd+0x10a/0x150
  [<ffffffff8116e916>] do_sys_open+0x106/0x1d0
  [<ffffffff810cf78b>] ? audit_syscall_entry+0x17b/0x1e0
  [<ffffffff8116ea20>] sys_open+0x20/0x30
  [<ffffffff81510642>] system_call_fastpath+0x16/0x1b
Code: 89 df e8 80 84 83 e0 66 90 e9 49 ff ff ff f3 90 49 8b 04 24 a9 00 
00 10
00 75 f3 e9 e8 fe ff ff 0f 0b eb fe 0f 1f 00 0f 0b eb fe <0f> 0b eb fe 0f 0b
eb fe 0f 1f 40 00 55 48 89 e5 41 57 41 56 41
RIP  [<ffffffffa0808b14>] jbd2_journal_dirty_metadata+0x164/0x170 [jbd2]
  RSP <ffff8801b919b5b8>
     crash>

Thanks,
Xiaowei


On 12/03/2012 04:33 PM, Jeff Liu wrote:
> Hi Xiaowei,
>
> Could you supply the crash info as well as your test scenario?
>
> Thanks,
> -Jeff
> On 12/03/2012 01:23 PM, Xiaowei wrote:
>> Could someone review this patch please? it's verified one testing box ,
>> fixed the run out of credits crash.
>>
>> Thanks,
>> Xiaowei
>>
>>
>> On 11/15/2012 09:20 AM, xiaowei.hu at oracle.com wrote:
>>> From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
>>>
>>> ocfs2_block_group_alloc_discontig doesn't keep credits for chain relink,
>>> and mean to disable chain relink setting ac->ac_allow_chain_relink = 0,
>>> but this value will be set to 1 in function ocfs2_claim_suballoc_bits,
>>> so need to make it's default allow relink, and disable it with one
>>> switch could be passed in.
>>>
>>> Signed-off-by: Xiaowei.Hu <xiaowei.hu@oracle.com>
>>> ---
>>>    fs/ocfs2/suballoc.c |    7 +++----
>>>    fs/ocfs2/suballoc.h |    2 +-
>>>    2 files changed, 4 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index 4b5e568..033bfc6 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -642,7 +642,7 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
>>>    	 * cluster groups will be staying in cache for the duration of
>>>    	 * this operation.
>>>    	 */
>>> -	ac->ac_allow_chain_relink = 0;
>>> +	ac->ac_disable_chain_relink = 1;
>>>    
>>>    	/* Claim the first region */
>>>    	status = ocfs2_block_group_claim_bits(osb, handle, ac, min_bits,
>>> @@ -1823,7 +1823,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>>>    	 * Do this *after* figuring out how many bits we're taking out
>>>    	 * of our target group.
>>>    	 */
>>> -	if (ac->ac_allow_chain_relink &&
>>> +	if (!ac->ac_disable_chain_relink &&
>>>    	    (prev_group_bh) &&
>>>    	    (ocfs2_block_group_reasonably_empty(bg, res->sr_bits))) {
>>>    		status = ocfs2_relink_block_group(handle, alloc_inode,
>>> @@ -1928,7 +1928,6 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>>    
>>>    	victim = ocfs2_find_victim_chain(cl);
>>>    	ac->ac_chain = victim;
>>> -	ac->ac_allow_chain_relink = 1;
>>>    
>>>    	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
>>>    				    res, &bits_left);
>>> @@ -1947,7 +1946,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>>    	 * searching each chain in order. Don't allow chain relinking
>>>    	 * because we only calculate enough journal credits for one
>>>    	 * relink per alloc. */
>>> -	ac->ac_allow_chain_relink = 0;
>>> +	ac->ac_disable_chain_relink = 1;
>>>    	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
>>>    		if (i == victim)
>>>    			continue;
>>> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
>>> index b8afabf..a36d0aa 100644
>>> --- a/fs/ocfs2/suballoc.h
>>> +++ b/fs/ocfs2/suballoc.h
>>> @@ -49,7 +49,7 @@ struct ocfs2_alloc_context {
>>>    
>>>    	/* these are used by the chain search */
>>>    	u16    ac_chain;
>>> -	int    ac_allow_chain_relink;
>>> +	int    ac_disable_chain_relink;
>>>    	group_search_t *ac_group_search;
>>>    
>>>    	u64    ac_last_group;
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
