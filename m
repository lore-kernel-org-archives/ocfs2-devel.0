From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 26 Jan 2010 17:27:05 +0300
Subject: [Ocfs2-devel] 2.6.32.6: OCFS2: NULL pointer dereference
In-Reply-To: <a4423d671001260542j6531f34fl31f9f6543bc83d14@mail.gmail.com>
References: <a4423d671001260542j6531f34fl31f9f6543bc83d14@mail.gmail.com>
Message-ID: <a4423d671001260627t7786690eq289c534ea94feb2a@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

2010/1/26 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> Host is x86_32 SMP.
> Trying to mount AoE exported block device:
>
> (mkfs.ocfs2 -N 30 -T mail /dev/..)
>
> OCFS2 Node Manager 1.5.0
> OCFS2 DLM 1.5.0
> ocfs2: Registered cluster interface o2cb
> OCFS2 DLMFS 1.5.0
> OCFS2 User DLM kernel interface loaded
> OCFS2 1.5.0
> ocfs2_dlm: Nodes in domain (C987785CC2BE4476BBD74BB02A853654): 22
> JBD: Ignoring recovery information on journal
> ocfs2: Mounting device (152,5632) on (node 22, slot 1) with ordered data mode.
> (10881,0):ocfs2_replay_journal:1607 Recovering node 7 from slot 0 on
> device (152,5632)
> BUG: unable to handle kernel NULL pointer dereference at 0000001f
> IP: [<f8f4a168>] ocfs2_update_disk_slot_old+0x11/0x4c [ocfs2]
> *pde = 00000000
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/fs/o2cb/interface_revision
> Modules linked in: ocfs2 jbd2 quota_tree ocfs2_dlmfs ocfs2_stack_o2cb
> ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs aoe dm_mirror
> dm_region_hash dm_log dm_multipath ohci_hcd usbcore nls_base tg3
> libphy [last unloaded: microcode]
> Pid: 10881, comm: ocfs2rec Not tainted (2.6.32.6 #1) eserver xSeries
> 335 -[8676L1X]-
> EIP: 0060:[<f8f4a168>] EFLAGS: 00010297 CPU: 0
> EIP is at ocfs2_update_disk_slot_old+0x11/0x4c [ocfs2]
> EAX: 00000007 EBX: f5be1800 ECX: f6896fd8 EDX: 00000000
> ESI: f5be1800 EDI: f6a95f08 EBP: 00000000 ESP: f6a95edc
> ?DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process ocfs2rec (pid: 10881, ti=f6a94000 task=f5bf06e0 task.ti=f6a94000)
> Stack:
> ?f65bc800 f5be1800 00000000 f8f4a200 e4b5c0c0 f6a95f3c f5ec4b08 f279c800
> <0> 00000007 f5f89080 f5ec4008 f8f4a56a 00000000 00000007 f65bc800 f8f2b3e2
> <0> f65bc9c4 00000000 f8f124c4 00000000 00000000 00000000 00000001 00000016
> Call Trace:
> ?[<f8f4a200>] ? ocfs2_update_disk_slot+0x5d/0x109 [ocfs2]
> ?[<f8f4a56a>] ? ocfs2_clear_slot+0x22/0x3d [ocfs2]
> ?[<f8f2b3e2>] ? ocfs2_recover_node+0x91/0x49e [ocfs2]
> ?[<f8f124c4>] ? ocfs2_super_lock+0x9f/0x481 [ocfs2]
> ?[<f8f29e94>] ? __ocfs2_recovery_thread+0x181/0x87e [ocfs2]
> ?[<c124ea51>] ? schedule+0x1b1/0x4b1
> ?[<c1022a9f>] ? __wake_up_common+0x3a/0x66
> ?[<f8f29d13>] ? __ocfs2_recovery_thread+0x0/0x87e [ocfs2]
> ?[<c1022bf6>] ? complete+0x37/0x46
> ?[<f8f29d13>] ? __ocfs2_recovery_thread+0x0/0x87e [ocfs2]
> ?[<c10377c8>] ? kthread+0x68/0x6d
> ?[<c1037760>] ? kthread+0x0/0x6d
> ?[<c100369f>] ? kernel_thread_helper+0x7/0x18
> Code: 04 89 44 fe 04 8b 43 10 8b 04 88 89 45 00 83 c4 04 5b 5e 5f 5d
> c3 0f 0b eb fe 57 31 d2 89 cf 56 53 89 c3 8b 48 10 3b 53 14 8b 01 <8b>
> 70 18 3e 72 12 eb 2b 8b 44 d0 04 66 89 04 56 83 c2 01 3b 53
> EIP: [<f8f4a168>] ocfs2_update_disk_slot_old+0x11/0x4c [ocfs2] SS:ESP
> 0068:f6a95edc
> CR2: 000000000000001f
>

00000247 <ocfs2_update_disk_slot_old>:
247: 57                push   %edi
248: 31 d2             xor    %edx,%edx
24a: 89 cf             mov    %ecx,%edi
24c: 56                push   %esi
24d: 53                push   %ebx
24e: 89 c3             mov    %eax,%ebx
250: 8b 48 10          mov    0x10(%eax),%ecx
253: 3b 53 14          cmp    0x14(%ebx),%edx
256: 8b 01             mov    (%ecx),%eax
>258: 8b 70 18          mov    0x18(%eax),%esi
25b: 3e 72 12          jb,pt  270 <ocfs2_update_disk_slot_old+0x29>
25e: eb 2b             jmp    28b <ocfs2_update_disk_slot_old+0x44>
260: 8b 44 d0 04       mov    0x4(%eax,%edx,8),%eax
264: 66 89 04 56       mov    %ax,(%esi,%edx,2)
268: 83 c2 01          add    /bin/bashx1,%edx
26b: 3b 53 14          cmp    0x14(%ebx),%edx
26e: 73 18             jae    288 <ocfs2_update_disk_slot_old+0x41>
270: 8b 43 18          mov    0x18(%ebx),%eax
273: 8b 0c d0          mov    (%eax,%edx,8),%ecx
276: 85 c9             test   %ecx,%ecx
278: 75 e6             jne    260 <ocfs2_update_disk_slot_old+0x19>
27a: 66 c7 04 56 ff ff movw   /bin/bashxffff,(%esi,%edx,2)
280: 83 c2 01          add    /bin/bashx1,%edx
283: 3b 53 14          cmp    0x14(%ebx),%edx
286: 72 e8             jb     270 <ocfs2_update_disk_slot_old+0x29>
288: 8b 4b 10          mov    0x10(%ebx),%ecx
28b: 5b                pop    %ebx
28c: 8b 01             mov    (%ecx),%eax
28e: 5e                pop    %esi
28f: 89 07             mov    %eax,(%edi)
291: 5f                pop    %edi
292: c3                ret
