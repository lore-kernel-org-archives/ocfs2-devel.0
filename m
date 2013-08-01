From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 01 Aug 2013 17:26:09 +0800
Subject: [Ocfs2-devel] NULL pointer dereference in __ocfs2_claim_clusters
In-Reply-To: <5077941.ff0Qv5NFt0@o3-3>
References: <2093054.cfueY8DOT0@o3-3> <51F7816A.6050303@tao.ma>
	<51F8E43E.5080303@oracle.com> <5077941.ff0Qv5NFt0@o3-3>
Message-ID: <51FA29B1.9030702@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/31/2013 08:19 PM, David Weber wrote:

> Am Mittwoch, 31. Juli 2013, 18:17:34 schrieb Jeff Liu:
>> Hi Tao,
>>
>> On 07/30/2013 05:03 PM, Tao Ma wrote:
>>> Hi David,
>>>
>>> On 07/30/2013 03:14 PM, David Weber wrote:
>>>> Hi,
>>>>
>>>> we are currently trying to use OCFS2 in Linux 3.11.0-rc3 as a VM storage.
>>>>
>>>> When we try to discard free blocks from inside the guest we get a NULL
>>>> Pointer> 
>>>> dereference on the host:
>>> I thought this is already fixed by Tiger about a year ago.
>>> https://oss.oracle.com/pipermail/ocfs2-devel/2012-September/008734.html
>>> would you mind trying this patch to see if it works?
> 
> The patch works. There are no OOPS any more and according to shared-du the 
> image shrank to the minimum size.

Great! I'll rebase it so. :)

Thanks,
-Jeff

> 
> Cheers,
> David
> 
>>
>> This fix looks good to me.  I'd like to rebase it on behalf of Tiger(as
>> Tiger has left Oracle last year) If you have no objections(i.e, Originally,
>> you also thought it might could be fixed by skipping the call of
>> ocfs2_readahead_for_cow if file = NULL should works), and then it need an
>> Acked-by from you as you're the author of the readahead for CoW.
>>
>> Thanks,
>> -Jeff
>>
>>> Thanks,
>>> Tao
>>>
>>>> [ 3452.936566] BUG: unable to handle kernel NULL pointer dereference at
>>>> 0000000000000020
>>>> [ 3452.937042] IP: [<ffffffffa00eb250>]
>>>> ocfs2_duplicate_clusters_by_page+0x26/0x3cb [ocfs2]
>>>> [ 3452.937535] PGD 0
>>>> [ 3452.937655] Oops: 0000 [#1] SMP
>>>> [ 3452.937853] Modules linked in: vhost_net vhost tun drbd ebtable_nat
>>>> ebtables ocfs2_stack_o2cb bridge stp llc kvm_intel kvm lru_cache dlm sctp
>>>> libcrc32c ocfs2_dlm ocfs2_dlmfs ocfs2 ocfs2_stackglue ocfs2_nodemanager
>>>> configfs igb [last unloaded: drbd]
>>>> [ 3452.939281] CPU: 0 PID: 3247 Comm: qemu-system-x86 Tainted: G         
>>>> I
>>>> 3.11.0-rc3 #1
>>>> [ 3452.939754] Hardware name: Supermicro X8DTU/X8DTU, BIOS 1.0c   
>>>> 07/24/2009 [ 3452.940159] task: ffff88079df02620 ti: ffff88079162a000
>>>> task.ti: ffff88079162a000 [ 3452.940601] RIP: 0010:[<ffffffffa00eb250>] 
>>>> [<ffffffffa00eb250>] ocfs2_duplicate_clusters_by_page+0x26/0x3cb [ocfs2]
>>>> [ 3452.941232] RSP: 0018:ffff88079162b9d8  EFLAGS: 00010296
>>>> [ 3452.941542] RAX: 00000000007e0101 RBX: ffff88079dd735c0 RCX:
>>>> 000000000001f8b7 [ 3452.941965] RDX: 0000000000000026 RSI:
>>>> 0000000000000000 RDI: ffff88079be98030 [ 3452.942389] RBP:
>>>> ffff88079162ba68 R08: 000000000001ad0a R09: 0000000000000001 [
>>>> 3452.942836] R10: f84eb5df22f96c02 R11: 0000000000000000 R12:
>>>> 0000000000000001
>>>> [ 3452.943266] R13: 000000000001f8b7 R14: 0000000000000026 R15:
>>>> 0000000000000001
>>>> [ 3452.943687] FS:  00007f304b7fe700(0000) GS:ffff8807bfc00000(0000)
>>>> knlGS:0000000000000000
>>>> [ 3452.944164] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [ 3452.944500] CR2: 0000000000000020 CR3: 000000079171a000 CR4:
>>>> 00000000000027e0
>>>> [ 3452.944920] Stack:
>>>> [ 3452.945032]  ffff88079162bb80 ffff88079162bb84 ffff88079162ba68
>>>> ffffffffa00fd4bc [ 3452.945485]  0000000000000000 ffff88079d3f6000
>>>> ffff88079be98030 ffff88079bfd1ed8 [ 3452.945936]  000000000001f8b7
>>>> 000000000001ad0a 0000000000000000 0000000000000000
>>>> [ 3452.946388] Call Trace:
>>>> [ 3452.946535]  [<ffffffffa00fd4bc>] ? __ocfs2_claim_clusters+0x1f7/0x325
>>>> [ocfs2] [ 3452.946967]  [<ffffffffa00ee0bf>]
>>>> ocfs2_replace_cow+0x3f0/0xe18 [ocfs2] [ 3452.947364] 
>>>> [<ffffffffa00ef026>] ocfs2_refcount_cow+0x53f/0x668 [ocfs2] [
>>>> 3452.947764]  [<ffffffffa00c921f>] ocfs2_cow_file_pos+0x11c/0x123
>>>> [ocfs2] [ 3452.948164]  [<ffffffffa00c992f>]
>>>> ocfs2_remove_inode_range+0xc6/0xd5b [ocfs2] [ 3452.948593] 
>>>> [<ffffffffa00d30ce>] ? ocfs2_read_inode_block_full+0x36/0x55 [ocfs2]
>>>> [ 3452.949040]  [<ffffffffa00c3c89>] ?
>>>> ocfs2_inode_lock_full_nested+0x515/0xaa8 [ocfs2]
>>>> [ 3452.949503]  [<ffffffffa00d6ada>] ? ocfs2_extend_trans+0x1f9/0x1f9
>>>> [ocfs2] [ 3452.949914]  [<ffffffffa00cbee1>]
>>>> __ocfs2_change_file_space+0x3d0/0xaa3 [ocfs2] [ 3452.950354] 
>>>> [<ffffffffa00cc624>] ocfs2_fallocate+0x70/0x74 [ocfs2] [ 3452.950727] 
>>>> [<ffffffff8113b11b>] do_fallocate+0x106/0x14d
>>>> [ 3452.951050]  [<ffffffff8113b1a9>] SyS_fallocate+0x47/0x6b
>>>> [ 3452.951368]  [<ffffffff81664e12>] system_call_fastpath+0x16/0x1b
>>>> [ 3452.951720] Code: ff 0f 0b 0f 0b 55 48 89 e5 41 57 41 56 41 55 41 54
>>>> 53 48 83 ec 68 48 89 7d a0 48 89 75 90 41 89 d6 89 4d b0 44 89 45 b8 45
>>>> 89 cf <48> 8b 46 20 48 89 45 98 48 89 c7 48 83 ef 48 e8 78 8e 02 00 49
>>>> [ 3452.953241] RIP  [<ffffffffa00eb250>]
>>>> ocfs2_duplicate_clusters_by_page+0x26/0x3cb [ocfs2]
>>>> [ 3452.953729]  RSP <ffff88079162b9d8>
>>>> [ 3452.953931] CR2: 0000000000000020
>>>> [ 3453.019391] ---[ end trace 08f73908d0d596c1 ]---
>>>>
>>>> The filesystem was created with:
>>>> mkfs.ocfs2 -b 4K -C 1M -J block64 -L kvm-images -T vmstore /dev/drbd0
>>>>
>>>> alice ocfs2 # gdb suballoc.o
>>>> GNU gdb (Gentoo 7.5.1 p2) 7.5.1
>>>> Copyright (C) 2012 Free Software Foundation, Inc.
>>>> License GPLv3+: GNU GPL version 3 or later
>>>> <http://gnu.org/licenses/gpl.html> This is free software: you are free
>>>> to change and redistribute it. There is NO WARRANTY, to the extent
>>>> permitted by law.  Type "show copying" and "show warranty" for details.
>>>> This GDB was configured as "x86_64-pc-linux-gnu".
>>>> For bug reporting instructions, please see:
>>>> <http://bugs.gentoo.org/>...
>>>> Reading symbols from /usr/src/linux-3.11-rc3/fs/ocfs2/suballoc.o...done.
>>>> (gdb) list  *(__ocfs2_claim_clusters+0x1f7)
>>>> 0x40bc is in __ocfs2_claim_clusters (fs/ocfs2/suballoc.c:2306).
>>>> 2301                   && ac->ac_which != OCFS2_AC_USE_MAIN);
>>>> 2302
>>>> 2303            if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
>>>> 2304                    WARN_ON(min_clusters > 1);
>>>> 2305
>>>> 2306                    status = ocfs2_claim_local_alloc_bits(osb,
>>>> 2307                                                          handle,
>>>> 2308                                                          ac,
>>>> 2309                                                         
>>>> bits_wanted,
>>>> 2310                                                         
>>>> cluster_start,
>>>>
>>>> Qemu version: 1.5.2
>>>> Guest OS: Ubuntu 13.10 snapshot (Linux 3.10)
>>>> Guest filesystem: ext4
>>>> Command run on the guest: 'fstrim -v /'
>>>>
>>>> The disk configuration in libvirt looks like this:
>>>>     <disk type='file' device='disk'>
>>>>     
>>>>       <driver name='qemu' type='raw' cache='none' discard='unmap'/>
>>>>       <source file='/mnt/kvm-images/ubuntu2.img'/>
>>>>       <target dev='sda' bus='scsi'/>
>>>>       <address type='drive' controller='0' bus='0' target='0' unit='0'/>
>>>>     
>>>>     </disk>
>>>>
>>>> and maps to such a qemu command line
>>>>
>>>> -device virtio-scsi-pci,id=scsi0,bus=pci.0,addr=0x4 -drive file=/mnt/kvm-
>>>> images/ubuntu2.img,if=none,id=drive-
>>>> scsi0-0-0-0,format=raw,cache=none,discard=unmap -device scsi-
>>>> hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,drive=drive-
>>>> scsi0-0-0-0,id=scsi0-0-0-0,bootindex=1
>>>>
>>>> Thanks in advance!
>>>>
>>>> Cheers,
>>>> David
>>>>
>>>>
>>>> _______________________________________________
>>>> Ocfs2-devel mailing list
>>>> Ocfs2-devel at oss.oracle.com
>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
