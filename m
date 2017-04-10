From: Changwei Ge <ge.changwei@h3c.com>
Date: Mon, 10 Apr 2017 08:05:52 +0000
Subject: [Ocfs2-devel] [Bug Report] crash in the path of direct IO
References: <63ADC13FD55D6546B7DECE290D39E37342E82370@H3CMLB12-EX.srv.huawei-3com.com>
	<58EBA9BC020000F90006EFEB@prv-mh.provo.novell.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37342E823DB@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Gang,

More log before crash is pasted.

Also, I gathered some structure's content, which may be useful to
analyze this issue.

Paste them here too.

struct dio_submit {
  bio = 0xffff88035690b800,
  blkbits = 0x9,
  blkfactor = 0x3,
  start_zero_done = 0x1,
  pages_in_io = 0x34,
  block_in_file = 0x8be800,
  blocks_available = 0x0,
  reap_counter = 0x4,
  final_block_in_request = 0x8be988,
  boundary = 0x0,
  get_block = 0xffffffffc06ea3c0 <ocfs2_get_block>,
  submit_io = 0x0,
  logical_offset_in_bio = 0x117cbf600,
  final_block_in_bio = 0x7d92c7fb,
  next_block_for_io = 0x7d92c800,
  cur_page = 0xffffea0014865280,
  cur_page_offset = 0x0,
  cur_page_len = 0xa00,
  cur_page_block = 0x7d92c7fb,
  cur_page_fs_offset = 0x117cff600,
  iter = 0xffff88018038fd40,
  head = 0x1,
  tail = 0x32,
  from = 0x0,
  to = 0xa00
}


crash> struct -x buffer_head FFFF88018038FBA0
struct buffer_head {
  b_state = 0x20,
  b_this_page = 0x0,
  b_page = 0x0,
  b_blocknr = 0xfb25900,
  b_size = 0x0,
  b_data = 0x0,
  b_bdev = 0xffff880626c18d00,
  b_end_io = 0x0,
  b_private = 0x0,
  b_assoc_buffers = {
    next = 0x0,
    prev = 0x0
  },
  b_assoc_map = 0x0,
  b_count = {
    counter = 0x0
  }
}


struct dio {
  flags = 0x0,
  rw = 0x0,
  inode = 0xffff880626c18d00,
  i_size = 0x3000000000002001,
  end_io = 0x0,
  private = 0x7d92c5fb,
  bio_lock = {
    {
      rlock = {
        raw_lock = {
          {
            head_tail = 0x40000,
            tickets = {
              head = 0x0,
              tail = 0x4
            }
          }
        }
      }
    }
  },
  page_errors = 0x0,
  is_async = 0x0,
  defer_completion = 0x0,
  io_error = 0x40,
  refcount = 0x100000000,
  bio_list = 0xffffffff8123dea0 <dio_bio_end_io>,
  waiter = 0x0,
  iocb = 0x0,
  result = 0x0,
  {
    pages = {0x0, 0x100400040, 0xffff8805e5d24000, 0xffff88062362e200,
0xe, 0x2000000000003603, 0x100062, 0xa185d7980000001c, 0x410c90081, 0x0,
0x0, 0x40004e00620008, 0xc000000090, 0xffff880bda883200,
0xffff880bda883240, 0x100000300, 0xffff88035690b8e8, 0xffff88035690b8e8,
0xffff88070c896b40, 0x0, 0x0, 0xffff880036b0cf20, 0xffff8805e0433140,
0xffff8803d18f6e48, 0xffffffff8182f7c0 <ext4_file_operations>, 0x0, 0x1,
0x5801e00008401, 0x1, 0xffff88035690b950, 0xffff88035690b950, 0x0, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0xffff8806216d9800, 0x0, 0x0, 0x20,
0xffffffffffffffff, 0x0, 0xffff8805e5b76d10, 0x0, 0xffff88035690b9d8,
0xffff88035690b9d8, 0xffff88035690b9e8, 0xffff88035690b9e8,
0xffff8803d18f6fa0, 0x0, 0x100000000000, 0x391777000, 0x1000,
0xf000000000000011, 0x11, 0x8899acd0, 0x100000000, 0x0, 0x0, 0x0,
0xffffffff8166bbc0 <end_clone_bio>, 0x0},
    complete_work = {
      data = {
        counter = 0x0
      },
      entry = {
        next = 0x100400040,
        prev = 0xffff8805e5d24000
      },
      func = 0xffff88062362e200
    }
  }
}


[ 6462.384112] perf interrupt took too long (5001 > 5000), lowering
kernel.perf_event_max_sample_rate to 25000
[ 6897.148074] (bash,40563,4):o2hb_dead_threshold_set:179 change
o2hb_dead_threshold from 31 to 61.
[843206.293370] device vnet14 left promiscuous mode
[2189607.253719] traps: pool[3849] general protection ip:7fed0568e9b5
sp:7fec5cff8ca0 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[2337506.018214] pool[23946]: segfault at 131 ip 00007fed0568e9b5 sp
00007fecc17f9a20 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[2551921.601923] traps: pool[6161] general protection ip:7fed0568e9b5
sp:7fecc27fbb00 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[2924777.380720] traps: pool[47824] general protection ip:7fed0568e9b5
sp:7fec82ffc990 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[2975452.510978]  rport-4:0-7: blocked FC remote port time out: removing
rport
[2975452.575035]  rport-2:0-7: blocked FC remote port time out: removing
rport
[2975503.249953] o2net: Connection to node WXDC-YW-CVK01 (num 15) at
10.4.200.11:7100 has been idle for 90.129 secs.
[2975503.249959] o2net_idle_timer 1596: Local and remote node is
heartbeating, and try connect
[2975543.542740] o2net: No longer connected to node WXDC-YW-CVK01 (num
15) at 10.4.200.11:7100
[2975543.542763] (dlm_thrd-35FC48,24978,4):dlm_send_proxy_ast_msg:486
ERROR: 35FC4886438A4514A38E9B32BC3D7A9A: res
P000000000000000000000000000000, error -112 send AST to node 15
[2975543.542766] (libvirtd,27698,7):dlm_send_remote_convert_request:420
ERROR: Error -112 when sending message 504 (key 0x4c54277c) to node 15
[2975543.542769] o2dlm: Waiting on the death of node 15 in domain
35FC4886438A4514A38E9B32BC3D7A9A
[2975543.542780] (dlm_thrd-35FC48,24978,4):dlm_flush_asts:609 ERROR:
status = -112
[2975543.542830] o2cb: o2dlm has evicted node 15 from domain
2348CB47501C4968B748AA4465A5CE65
[2975543.543039] o2cb: o2dlm has evicted node 15 from domain
AB049B6C3B0B4B9598B6E7643F31BC7D
[2975543.543206] o2cb: o2dlm has evicted node 15 from domain
35FC4886438A4514A38E9B32BC3D7A9A
[2975544.014924] o2dlm: Begin recovery on domain
2348CB47501C4968B748AA4465A5CE65 for node 15
[2975544.014950] o2dlm: Node 12 (me) is the Recovery Master for the dead
node 15 in domain 2348CB47501C4968B748AA4465A5CE65
[2975544.015024] o2dlm: End recovery on domain
2348CB47501C4968B748AA4465A5CE65
[2975544.315225] o2dlm: Begin recovery on domain
AB049B6C3B0B4B9598B6E7643F31BC7D for node 15
[2975544.315250] o2dlm: Node 12 (me) is the Recovery Master for the dead
node 15 in domain AB049B6C3B0B4B9598B6E7643F31BC7D
[2975544.315301] o2dlm: End recovery on domain
AB049B6C3B0B4B9598B6E7643F31BC7D
[2975544.555825] ocfs2: Begin replay journal (node 15, slot 0) on device
(252,0)
[2975544.559471] (ocfs2rec-35FC48,44421,1):is_dlm_recoverying:718
35FC4886438A4514A38E9B32BC3D7A9A: At least one node (15) to recover
before lock mastery can begin
[2975544.559478] o2dlm: Waiting on the recovery of node 15 in domain
35FC4886438A4514A38E9B32BC3D7A9A
[2975544.571764] ocfs2: Begin replay journal (node 15, slot 0) on device
(252,1)
[2975546.433356] o2dlm: Begin recovery on domain
35FC4886438A4514A38E9B32BC3D7A9A for node 15
[2975546.433389] o2dlm: Node 12 (me) is the Recovery Master for the dead
node 15 in domain 35FC4886438A4514A38E9B32BC3D7A9A
[2975546.433451] o2dlm: End recovery on domain
35FC4886438A4514A38E9B32BC3D7A9A
[2975547.321517] ocfs2: End replay journal (node 15, slot 0) on device
(252,1)
[2975547.534921] ocfs2: End replay journal (node 15, slot 0) on device
(252,0)
[2975547.821254] ocfs2: Beginning quota recovery on device (252,1) for
slot 0
[2975547.858268] ocfs2: Finishing quota recovery on device (252,1) for
slot 0
[2975547.910114] ocfs2: Beginning quota recovery on device (252,0) for
slot 0
[2975547.913662] ocfs2: Finishing quota recovery on device (252,0) for
slot 0
[2975554.569889] ocfs2: Begin replay journal (node 15, slot 0) on device
(252,2)
[2975555.813500] ocfs2: End replay journal (node 15, slot 0) on device
(252,2)
[2975556.176522] ocfs2: Beginning quota recovery on device (252,2) for
slot 0
[2975556.187862] ocfs2: Finishing quota recovery on device (252,2) for
slot 0
[2975592.202207] lpfc 0000:07:00.1: 1:(0):2753 PLOGI failure DID:011400
Status:x9/xb0000
[2975604.932014] lpfc 0000:07:00.1: 1:(0):2753 PLOGI failure DID:011400
Status:x9/xb0000
[2975719.332062] o2net: Accepted connection from node WXDC-YW-CVK01 (num
15) at 10.4.200.11:7100
[2975728.677528] o2dlm: Node 15 joins domain
2348CB47501C4968B748AA4465A5CE65 ( 12 15 ) 2 nodes
[2975763.432760] o2dlm: Node 15 joins domain
35FC4886438A4514A38E9B32BC3D7A9A ( 12 15 ) 2 nodes
[2975780.577939] o2dlm: Node 15 joins domain
AB049B6C3B0B4B9598B6E7643F31BC7D ( 12 15 ) 2 nodes
[3031443.553332] cas_mon[20610]: segfault at 73 ip 00007fed0568e9b5 sp
00007ffdc8ebe980 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[3269102.217205] pool[35388]: segfault at 73 ip 00007fed0568e9b5 sp
00007fec9fffeb00 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[3515379.499604] pool[349]: segfault at 131 ip 00007fed0568e9b5 sp
00007fec9e7fba20 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[4031388.232467] traps: pool[43628] general protection ip:7fed0568e9b5
sp:7fec5fffe990 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[4134241.525228] cas_mon[54719]: segfault at 73 ip 00007fed0568e9b5 sp
00007ffdc8ebe7d0 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[4473741.407847] device vnet13 left promiscuous mode
[4473791.557907] device vnet9 left promiscuous mode
[4473820.702989] device vnet9 entered promiscuous mode
[4473821.255486] pmtmr configuration result is 0, addr is 45064
[4473821.524332] kvm: zapping shadow pages for mmio generation wraparound
[4533982.324343] device vnet9 left promiscuous mode
[4534063.416804] device vnet9 entered promiscuous mode
[4534063.967029] pmtmr configuration result is 0, addr is 45064
[4534064.276827] kvm: zapping shadow pages for mmio generation wraparound
[4559018.565505] cas_mon[46625]: segfault at 73 ip 00007fed0568e9b5 sp
00007ffdc8ebe980 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[4600670.235432] traps: cas_mon[55506] general protection
ip:7fed0568e9b5 sp:7ffdc8ebe7d0 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[4775655.779944] pool[49649]: segfault at 131 ip 00007fed0568e9b5 sp
00007fec9d7f9a90 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[5034756.129492] pool[19083]: segfault at 131 ip 00007fed0568e9b5 sp
00007fec837fda20 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[5337040.276865] traps: pool[57321] general protection ip:7fed0568e9b5
sp:7fecdfffe990 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[5383136.502408] traps: pool[47266] general protection ip:7fed0568e9b5
sp:7fecffcf5990 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[5658633.052415] pool[17443]: segfault at 131 ip 00007fed0568e9b5 sp
00007fec82ffca20 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[5711215.901738] pool[7137]: segfault at 131 ip 00007fed0568e9b5 sp
00007fec80ff8a20 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[5812297.419015] pool[17377]: segfault at 131 ip 00007fed0568e9b5 sp
00007fecfecf3a20 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[5845825.744536] device vnet5 left promiscuous mode
[6021266.603485] (o2hb-35FC488643,24939,6):o2hb_thread:1139
o2hb_do_disk_heartbeat used 2084 msecs on device(dm-2), ret = 0.
[6735692.029925] nfs: server 10.1.232.13 not responding, still trying
[6736391.012967] nfs: server 10.1.232.13 OK
[7284403.619409] nfs: server 10.1.232.13 not responding, still trying
[7284948.168319] nfs: server 10.1.232.13 OK
[7285905.288247] nfs: server 10.1.232.13 not responding, still trying
[7287495.342509] nfs: server 10.1.232.13 OK
[7780445.410991] cas_mon[40418]: segfault at 73 ip 00007fed0568e9b5 sp
00007ffdc8ebe980 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[8933694.262566] pool[3989]: segfault at 73 ip 00007fed0568e9b5 sp
00007fec9cff8990 error 4 in libc-2.15.so[7fed0561f000+1b4000]
[9548862.359393] traps: cas_mon[16213] general protection
ip:7fed0568e9b5 sp:7ffdc8ebe7d0 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[9845860.580574] traps: cas_mon[59940] general protection
ip:7fed0568e9b5 sp:7ffdc8ebe7d0 error:0 in libc-2.15.so[7fed0561f000+1b4000]
[10628085.052113] ------------[ cut here ]------------
[10628085.052122] kernel BUG at fs/direct-io.c:1018!
[10628085.052125] invalid opcode: 0000 [#1] SMP
[10628085.052128] Modules linked in: ocfs2(OE) quota_tree(E) cls_u32(E)
sch_sfq(E) sch_htb(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E)
ip_tables(E) ebtable_nat(E) ebtables(E) x_tables(E) chbk(OE) bnx2fc(E)
cnic(E) uio(E) fcoe(E) libfcoe(E) libfc(E) nfsv3(E) rpcsec_gss_krb5(E)
nfsv4(E) drbd(E) lru_cache(E) 8021q(E) mrp(E) garp(E) stp(E) llc(E)
ipmi_devintf(E) vhost_net(E) macvtap(E) macvlan(E) vhost(E) kvm_intel(E)
kvm(E) ib_iser(E) rdma_cm(E) ib_cm(E) iw_cm(E) ib_sa(E) ib_mad(E)
ib_core(E) ib_addr(E) iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E)
scsi_transport_iscsi(E) ocfs2_dlmfs(OE) ocfs2_stack_o2cb(OE)
ocfs2_dlm(OE) ocfs2_nodemanager(OE) ocfs2_stackglue(OE) configfs(E)
dm_round_robin(E) dm_multipath(E) scsi_dh(E) openvswitch(OE)
nf_conntrack(E) nf_defrag_ipv4(E) gre(E) libcrc32c(E) nf_defrag_ipv6(E)
[10628085.052182]  nfsd(E) nfs_acl(E) auth_rpcgss(E) nfs(E) fscache(E)
lockd(E) sunrpc(E) grace(E) ipmi_ssif(E) 8250_fintek(E) psmouse(E)
ioatdma(E) sb_edac(E) edac_core(E) hpwdt(E) hpilo(E) ipmi_si(E) wmi(E)
serio_raw(E) dca(E) ipmi_msghandler(E) mac_hid(E) lpc_ich(E)
acpi_power_meter(E) lp(E) parport(E) hpsa(E) scsi_transport_sas(E)
tg3(E) lpfc(E) ptp(E) pps_core(E) scsi_transport_fc(E) nbd(E)
[10628085.052218] CPU: 3 PID: 52230 Comm: kvm Tainted: G           OE  
4.1.0-generic #1
[10628085.052225] Hardware name: H3C FlexServer R390, BIOS P70 08/02/2014
[10628085.052229] task: ffff8805ecc40000 ti: ffff88018038c000 task.ti:
ffff88018038c000
[10628085.052236] RIP: 0010:[<ffffffff81240ba0>]  [<ffffffff81240ba0>]
do_blockdev_direct_IO+0x1e10/0x1eb0
[10628085.052248] RSP: 0018:ffff88018038fa38  EFLAGS: 00010246
[10628085.052252] RAX: 0000000000000000 RBX: ffff8800ae579680 RCX:
0000000000000009
[10628085.052258] RDX: 0000000000000000 RSI: 000000000fb25900 RDI:
000000007d92c800
[10628085.052265] RBP: ffff88018038fc68 R08: ffff8805e042a298 R09:
0000000000000001
[10628085.052271] R10: 0000000000000003 R11: 0000000000000000 R12:
0000000000000000
[10628085.052277] R13: 0000000000000a00 R14: ffff8800ae5796a8 R15:
ffffea0014865280
[10628085.052284] FS:  00007f7f517fa700(0000) GS:ffff8806276c0000(0000)
knlGS:0000000000000000
[10628085.052290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10628085.052294] CR2: 000000001fbc0000 CR3: 0000000bdb8f7000 CR4:
00000000001426e0
[10628085.052300] Stack:
[10628085.052304]  ffff88018038fc60 ffff880626c18d00 0000000000117c00
ffff8800ae5796e8
[10628085.052311]  ffff88018038fb90 ffff8800ae5796b4 0000000000000200
0000000000131000
[10628085.052318]  000000007d92c5fb ffff88052194a000 0000000117c00000
fffffffffffffe00
[10628085.052326] Call Trace:
[10628085.052371]  [<ffffffffc06ea3c0>] ?
ocfs2_zero_new_buffers+0x130/0x130 [ocfs2]
[10628085.052379]  [<ffffffff81240c83>] __blockdev_direct_IO+0x43/0x50
[10628085.052395]  [<ffffffffc06e9af0>] ? ocfs2_zero_tail+0x50/0x50 [ocfs2]
[10628085.052411]  [<ffffffffc06e933f>] ocfs2_direct_IO+0x8f/0xa0 [ocfs2]
[10628085.052426]  [<ffffffffc06e9af0>] ? ocfs2_zero_tail+0x50/0x50 [ocfs2]
[10628085.052432]  [<ffffffff8118ba1a>] generic_file_read_iter+0x56a/0x610
[10628085.052449]  [<ffffffffc070004b>] ?
__ocfs2_cluster_unlock.isra.36+0xab/0xf0 [ocfs2]
[10628085.052469]  [<ffffffffc070a2da>] ocfs2_file_read_iter+0xca/0x410
[ocfs2]
[10628085.052476]  [<ffffffff810ffe44>] ? do_futex+0x304/0xbc0
[10628085.052481]  [<ffffffff8120263b>] __vfs_read+0xab/0xf0
[10628085.052487]  [<ffffffff812039d5>] vfs_read+0x95/0x130
[10628085.052491]  [<ffffffff81203c62>] SyS_pread64+0x92/0xa0
[10628085.052498]  [<ffffffff817f81b2>] system_call_fastpath+0x16/0x75
[10628085.052502] Code: 15 e8 ff ff 48 8d 8d 38 ff ff ff 48 8d b5 98 fe
ff ff 31 d2 48 89 df e8 3f d7 ff ff e9 f8 e7 ff ff 66 2e 0f 1f 84 00 00
00 00 00 <0f> 0b 4c 89 ff e8 26 85 f5 ff 84 c0 0f 85 ed ed ff ff e9 e3 ed
[10628085.052534] RIP  [<ffffffff81240ba0>]
do_blockdev_direct_IO+0x1e10/0x1eb0
[10628085.052539]  RSP <ffff88018038fa38>

On 2017/4/10 15:51, Gang He wrote:
> Hi Changwei,
>
> Did you get this kernel crash file? 
> Could you paste longer syslog before crash (e.g. 100 ~ 200 lines) via crash tool?
> e.g. 
> crash vmlinux-4.4.21-69-default.gz vmcore
> crash> log
>
>
>
> Thanks
> Gang
>
>
>> Hi,
>>
>> We encountered a crash issue days ago.
>>
>> The call trace follows as below:
>>
>> From the call trace, we can see that a direct read request caused this
>> crash issue, which triggered a BUG_ON check point.
>>
>> With the help of debugfs.ocfs2 tool, I can see that clusters owned by
>> the target file are extremely scattered . Most of them are not
>>
>> continuous.
>>
>> Does anyone have ideas about this issue?
>>
>> [10628085.052236] RIP: 0010:[<ffffffff81240ba0>]  [<ffffffff81240ba0>]
>> do_blockdev_direct_IO+0x1e10/0x1eb0
>> [10628085.052248] RSP: 0018:ffff88018038fa38  EFLAGS: 00010246
>> [10628085.052252] RAX: 0000000000000000 RBX: ffff8800ae579680 RCX:
>> 0000000000000009
>> [10628085.052258] RDX: 0000000000000000 RSI: 000000000fb25900 RDI:
>> 000000007d92c800
>> [10628085.052265] RBP: ffff88018038fc68 R08: ffff8805e042a298 R09:
>> 0000000000000001
>> [10628085.052271] R10: 0000000000000003 R11: 0000000000000000 R12:
>> 0000000000000000
>> [10628085.052277] R13: 0000000000000a00 R14: ffff8800ae5796a8 R15:
>> ffffea0014865280
>> [10628085.052284] FS:  00007f7f517fa700(0000) GS:ffff8806276c0000(0000)
>> knlGS:0000000000000000
>> [10628085.052290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [10628085.052294] CR2: 000000001fbc0000 CR3: 0000000bdb8f7000 CR4:
>> 00000000001426e0
>> [10628085.052300] Stack:
>> [10628085.052304]  ffff88018038fc60 ffff880626c18d00 0000000000117c00
>> ffff8800ae5796e8
>> [10628085.052311]  ffff88018038fb90 ffff8800ae5796b4 0000000000000200
>> 0000000000131000
>> [10628085.052318]  000000007d92c5fb ffff88052194a000 0000000117c00000
>> fffffffffffffe00
>> [10628085.052326] Call Trace:
>> [10628085.052371]  [<ffffffffc06ea3c0>] ?
>> ocfs2_zero_new_buffers+0x130/0x130 [ocfs2]
>> [10628085.052379]  [<ffffffff81240c83>] __blockdev_direct_IO+0x43/0x50
>> [10628085.052395]  [<ffffffffc06e9af0>] ? ocfs2_zero_tail+0x50/0x50 [ocfs2]
>> [10628085.052411]  [<ffffffffc06e933f>] ocfs2_direct_IO+0x8f/0xa0 [ocfs2]
>> [10628085.052426]  [<ffffffffc06e9af0>] ? ocfs2_zero_tail+0x50/0x50 [ocfs2]
>> [10628085.052432]  [<ffffffff8118ba1a>] generic_file_read_iter+0x56a/0x610
>> [10628085.052449]  [<ffffffffc070004b>] ?
>> __ocfs2_cluster_unlock.isra.36+0xab/0xf0 [ocfs2]
>> [10628085.052469]  [<ffffffffc070a2da>] ocfs2_file_read_iter+0xca/0x410
>> [ocfs2]
>> [10628085.052476]  [<ffffffff810ffe44>] ? do_futex+0x304/0xbc0
>> [10628085.052481]  [<ffffffff8120263b>] __vfs_read+0xab/0xf0
>> [10628085.052487]  [<ffffffff812039d5>] vfs_read+0x95/0x130
>> [10628085.052491]  [<ffffffff81203c62>] SyS_pread64+0x92/0xa0
>> [10628085.052498]  [<ffffffff817f81b2>] system_call_fastpath+0x16/0x75
>>
>>
>> Br.
>>
>> Thanks.
>>
>> Changwei.
>
