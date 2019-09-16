From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 16 Sep 2019 10:39:03 +0800
Subject: [Ocfs2-devel] [refcount] 26d2e0d5df:
 WARNING:at_lib/refcount.c:#refcount_warn_saturate
In-Reply-To: <20190912105640.2l6mtdjmcyyhmyun@willie-the-truck>
References: <20190909015226.GM15734@shao2-debian>
	<20190912105640.2l6mtdjmcyyhmyun@willie-the-truck>
Message-ID: <1330d305-9e78-b226-c3df-61d2469e2009@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Will Deacon <will@kernel.org>, kernel test robot <rong.a.chen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, lkp@01.org, mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com



On 19/9/12 18:56, Will Deacon wrote:
> [Adding the ocfs2 maintainers and mailing list]
> 
> On Mon, Sep 09, 2019 at 09:52:26AM +0800, kernel test robot wrote:
>> FYI, we noticed the following commit (built with gcc-7):
>>
>> commit: 26d2e0d5df5b9aab517d8327743e66fcb38e8136 ("refcount: Consolidate implementations of refcount_t")
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__kernel.googlesource.com_pub_scm_linux_kernel_git_will_linux.git&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=JDgmeBzYQTBYyVXbp15F87JVUbuDMa0KYVEii5Fp8bA&s=moL2p9Qg4UYAAk8kX7-NswEILrVqGyuckmEtyy6CF8M&e=  refcount/full
> 
> This branch effectively enables REFCOUNT_FULL by default, so I think the
> issue being flagged is a latent use-after-free in ocfs2, rather than a bug
> in the refcount implementation.
> 
>> in testcase: ocfs2test
>> with following parameters:
>>
>> 	disk: 1SSD
>> 	test: test-mkfs
>>
>>
>>
>> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 4G
> 
> [...]
> 
>> If you fix the issue, kindly add following tag
>> Reported-by: kernel test robot <rong.a.chen@intel.com>
>>
>>
>> [   72.121725] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1499
>> [   72.126078] in_atomic(): 1, irqs_disabled(): 0, pid: 2466, name: mount.ocfs2
>> [   72.128523] CPU: 1 PID: 2466 Comm: mount.ocfs2 Not tainted 5.3.0-rc3-00008-g26d2e0d5df5b9 #1
>> [   72.130522] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
>> [   72.132522] Call Trace:
>> [   72.134024]  dump_stack+0x5c/0x7b
>> [   72.135106]  ___might_sleep+0xf1/0x110
>> [   72.136280]  down_write+0x1c/0x50
>> [   72.137349]  configfs_depend_item+0x3a/0xb0
>> [   72.138597]  o2hb_region_pin+0xf9/0x180 [ocfs2_nodemanager]
> 
> This looks dodgy because o2hb_region_pin() asserts that the 'o2hb_live_lock'
> is held, but then configfs_depend_item() calls inode_lock(), which can
> sleep on the semaphore.
> 

Yes, the warning exactly blames this.
But this code lives here for a long time. I'm not sure why no blames
before.


>> [   72.140103]  ? inode_init_always+0x120/0x1d0
>> [   72.141368]  o2hb_register_callback+0xc6/0x2a0 [ocfs2_nodemanager]
>> [   72.143016]  dlm_join_domain+0xbd/0x7a0 [ocfs2_dlm]
>> [   72.144441]  ? dlm_alloc_ctxt+0x50a/0x580 [ocfs2_dlm]
>> [   72.145880]  dlm_register_domain+0x31f/0x440 [ocfs2_dlm]
>> [   72.147395]  ? enqueue_entity+0x109/0x6c0
>> [   72.148658]  ? _cond_resched+0x19/0x30
>> [   72.149870]  o2cb_cluster_connect+0x132/0x2c0 [ocfs2_stack_o2cb]
>> [   72.151524]  ocfs2_cluster_connect+0x14b/0x220 [ocfs2_stackglue]
>> [   72.153237]  ocfs2_dlm_init+0x2f1/0x4b0 [ocfs2]
>> [   72.154647]  ? ocfs2_init_node_maps+0x50/0x50 [ocfs2]
>> [   72.156167]  ocfs2_fill_super+0xcfc/0x12b0 [ocfs2]
>> [   72.157640]  ? ocfs2_initialize_super+0x1030/0x1030 [ocfs2]
>> [   72.159395]  mount_bdev+0x173/0x1b0
>> [   72.160627]  legacy_get_tree+0x27/0x40
>> [   72.161900]  vfs_get_tree+0x25/0xf0
>> [   72.163138]  do_mount+0x691/0x9c0
>> [   72.164343]  ksys_mount+0x80/0xd0
>> [   72.165536]  __x64_sys_mount+0x21/0x30
>> [   72.166828]  do_syscall_64+0x5b/0x1f0
>> [   72.168124]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [   72.169649] RIP: 0033:0x7f9aec59148a
>> [   72.170904] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d de f9 2a 00 f7 d8 64 89 01 48
>> [   72.175696] RSP: 002b:00007ffc97973af8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
>> [   72.177764] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9aec59148a
>> [   72.179756] RDX: 00005630f7e3b3ee RSI: 00005630f988a0b0 RDI: 00005630f988a310
>> [   72.181768] RBP: 00007ffc97973ca0 R08: 00005630f988a2b0 R09: 0000000000000020
>> [   72.183776] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffc97973b90
>> [   72.185795] R13: 0000000000000000 R14: 00005630f988b000 R15: 00007ffc97973b10
>> [   72.193593] o2dlm: Joining domain 87608FBB69A6455A927DB6EE644FA256 
>> [   72.193593] ( 
>> [   72.195534] 1 
>> [   72.196744] ) 1 nodes
>> [   72.201889] JBD2: Ignoring recovery information on journal
>> [   72.211850] ocfs2: Mounting device (8,0) on (node 1, slot 0) with ordered data mode.
>> [   72.261789] mount /dev/sda /mnt/ocfs2 /dev/sda          16515072      243712    16271360   2% /mnt/ocfs2
>> [   72.261792] 
>> [   72.268799] OK
>> [   72.268801] 
>> [   72.273936] create testdir /mnt/ocfs2/20190907_114755
>> [   72.273938] 
>> [   72.286732] create 15890 files .
>> [   72.286734] 
>> [   72.290339] 
>> [   76.331476] o2dlm: Leaving domain 87608FBB69A6455A927DB6EE644FA256
>> [   76.402235] blk_update_request: I/O error, dev fd0, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>> [   76.406909] floppy: error 10 while reading block 0
>> [   78.260271] ocfs2: Unmounting device (8,0) on (node 1)
>> [   78.264188] ------------[ cut here ]------------
>> [   78.267624] refcount_t: underflow; use-after-free.
> 
> Here's the use-after-free, but I couldn't follow 'ocfs2_dismount_volume()'
> enough to figure out where the refcount_t actually lives.
> 
> I've preserved the rest of the log below, in the hope that somebody more
> familiar with ocfs2 can take a look. The original report, including the
> .config, is here:
> 
>   https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_20190909015226.GM15734-40shao2-2Ddebian&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=JDgmeBzYQTBYyVXbp15F87JVUbuDMa0KYVEii5Fp8bA&s=NZgaKHH7Kgp-F_jMfjPZlEIBs4p-WwYgJa5jdZ54f3A&e= 
> 
From the dmesg, it has almost finished umount.
And the following step is to clean up ocfs2 super. I also don't
figure out how refcount_t related use-after-free during the flow
of ocfs2_dismount_volume().

Thanks,
Joseph
