From: Gang He <ghe@suse.com>
Date: Tue, 21 Jun 2016 23:53:44 -0600
Subject: [Ocfs2-devel] Can we disable BUG() assert by default in
 ocfs2_read_blocks_sync()c
In-Reply-To: <57694FA3020000F90003D123@prv-mh.provo.novell.com>
References: <57694FA3020000F90003D123@prv-mh.provo.novell.com>
Message-ID: <576A9868020000F90003D342@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys,

The code change is here, 
https://oss.oracle.com/pipermail/ocfs2-devel/2016-June/012291.html 

Please help to review, it is not a serious problem, but it is time to address it.
Since our customer (EMC) is encountering this panic during a high-load (SPECsfs2014) stress testing.


Thanks
Gang


>>> 
> Hello Guys,
> 
> Here is a BUG() assert in ocfs2_read_blocks_sync() function in 
> buffer_head_io.c,
> 101 int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
> 102                            unsigned int nr, struct buffer_head *bhs[])
> 103 {
> 	...
> 
> 140                 lock_buffer(bh);
> 141                 if (buffer_jbd(bh)) {
> 142                         mlog(ML_ERROR,
> 143                              "block %llu had the JBD bit set "
> 144                              "while I was in lock_buffer!",
> 145                              (unsigned long long)bh->b_blocknr);
> 146                         BUG();  <<== here
> 147                 }
> 148
> 149                 clear_buffer_uptodate(bh);
> 
> 	...
> }
> 
> By default, the code is enable, but the customer is encountering this BUG() 
> kernel panic under a high-load NAS server testing case on SLES12SP1.
> the panic back trace is as below,
> [ 2164.268524]  sdwt: unknown partition table
> [ 2164.270279]  sdwj: unknown partition table
> [ 2207.030241] bio: create slab <bio-1> at 1
> [ 2285.378597] OCFS2 Node Manager 1.5.0
> [ 2285.455203] OCFS2 1.5.0
> [ 2285.464157] JBD2: Ignoring recovery information on journal
> [ 2285.468099] ocfs2: Mounting device (254,0) on (node local, slot 0) with 
> ordered data mode.
> [ 4855.333080] (nfsd,15682,5):ocfs2_read_blocks_sync:145 ERROR: block 
> 86441055 had the JBD bit set while I was in lock_buffer!
> [ 4855.333109] ------------[ cut here ]------------
> [ 4855.333240] kernel BUG at 
> /home/abuild/rpmbuild/BUILD/cluster-fs-1.0/default/fs/ocfs2/buffer_head_io.
> c:146!
> [ 4855.333484] invalid opcode: 0000 [#1] SMP
> [ 4855.333591] Modules linked in: ocfs2(O) ocfs2_stackglue(O) 
> ocfs2_nodemanager(O) quota_tree nfsd auth_rpcgss nfs_acl lockd sunrpc dlm(O) 
> sctp configfs tg3 libphy bnx2x mdio libcrc32c af_packet iscsi_ibft 
> iscsi_boot_sysfs softdog msr emcpdm(POEX) emcpgpx(POEX) emcpmpx(POEX) 
> emcp(POEX) scsi_transport_fc scsi_tgt coretemp kvm crct10dif_pclmul 
> crc32_pclmul crc32c_intel ghash_clmulni_intel(X) aesni_intel aes_x86_64 lrw 
> gf128mul glue_helper ablk_helper cryptd pcspkr dm_mod e1000e shpchp ptp 
> pps_core button processor ext4 crc16 mbcache jbd2 sd_mod emcctd(OEN) sg 
> scsi_mod autofs4 [last unloaded: emcpioc]
> [ 4855.335085] Supported: No, Proprietary and Unsupported modules are loaded
> [ 4855.335229] CPU: 5 PID: 15682 Comm: nfsd Tainted: P        W  OE NX 
> 3.12.49-11-default #1
> [ 4855.335412] task: ffff8807bef54e80 ti: ffff8807bef52000 task.ti: 
> ffff8807bef52000
> [ 4855.335581] RIP: 0010:[<ffffffffa07618b0>]  [<ffffffffa07618b0>] 
> ocfs2_read_blocks_sync+0x360/0x370 [ocfs2]
> [ 4855.335818] RSP: 0018:ffff8807bef53a70  EFLAGS: 00010282
> [ 4855.335937] RAX: 000000000000006f RBX: ffff8807bef53b10 RCX: 
> 0000000000003ce2
> [ 4855.336072] RDX: 0000000000003ce2 RSI: 0000000000000206 RDI: 
> 0000000000000206
> [ 4855.336072] RBP: 000000000526fc60 R08: 000000000000006f R09: 
> 0000000000000000
> [ 4855.336072] R10: 0000000000000000 R11: ffff8807bef5380e R12: 
> 0000000000000000
> [ 4855.336072] R13: ffff8807bef53b18 R14: 1000000000000000 R15: 
> 000000000526fc60
> [ 4855.336072] FS:  0000000000000000(0000) GS:ffff88083dd40000(0000) 
> knlGS:0000000000000000
> [ 4855.336072] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 4855.336072] CR2: 00007f3a64014440 CR3: 00000007629d2000 CR4: 
> 00000000001006e0
> [ 4855.336072] Stack:
> [ 4855.336072]  000000000526fc5f ffff8805ebe0ea88 ffff8807c0391000 
> ffff8807bef53b10
> [ 4855.336072]  000000005b964280 ffff8807bef54e80 ffff8807bef55748 
> 000000000526fc5f
> [ 4855.336072]  ffff8807c0391000 ffff8807bef53b98 0000000000000000 
> ffff8807c0391000
> [ 4855.336072] Call Trace:
> [ 4855.336072]  [<ffffffffa07acc3f>] ocfs2_test_inode_bit+0x4f/0x8e0 [ocfs2]
> [ 4855.336072]  [<ffffffffa07748c4>] ocfs2_get_dentry+0x224/0x4a0 [ocfs2]
> [ 4855.336072]  [<ffffffffa0774bc2>] ocfs2_fh_to_dentry+0x32/0x50 [ocfs2]
> [ 4855.336072]  [<ffffffff8121b453>] exportfs_decode_fh+0x63/0x2c0
> [ 4855.336072]  [<ffffffffa0688425>] fh_verify+0x2f5/0x5e0 [nfsd]
> [ 4855.336072]  [<ffffffffa0689b6c>] nfsd_open+0x2c/0x180 [nfsd]
> [ 4855.336072]  [<ffffffffa068c694>] nfsd_write+0xb4/0x110 [nfsd]
> [ 4855.336072]  [<ffffffffa069277c>] nfsd3_proc_write+0xac/0x130 [nfsd]
> [ 4855.336072]  [<ffffffffa0684cc2>] nfsd_dispatch+0xb2/0x200 [nfsd]
> [ 4855.336072]  [<ffffffffa0633cab>] svc_process_common+0x43b/0x680 [sunrpc]
> [ 4855.336072]  [<ffffffffa0633ffc>] svc_process+0x10c/0x160 [sunrpc]
> [ 4855.336072]  [<ffffffffa06846cf>] nfsd+0xaf/0x120 [nfsd]
> [ 4855.336072]  [<ffffffff8107ad94>] kthread+0xb4/0xc0
> [ 4855.336072]  [<ffffffff8152a518>] ret_from_fork+0x58/0x90
> [ 4855.336072] Code: 00 00 48 8d b0 c8 08 00 00 48 89 3c 24 48 63 c9 41 b9 
> 91 00 00 00 49 c7 c0 00 de 7d a0 48 c7 c7 58 66 7e a0 31 c0 e8 79 5b db e0 <0f> 
> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
> [ 4855.336072] RIP  [<ffffffffa07618b0>] ocfs2_read_blocks_sync+0x360/0x370 
> [ocfs2]
> [ 4855.336072]  RSP <ffff8807bef53a70>
> [ 4855.341947] ---[ end trace a7919e7f17c0a727 ]---
> 
> 
>>From the past discussions, I think that this panic is not the first time, 
> someone ever tried to remove this kind of BUG() in ocfs2_read_blocks_sync() 
> and ocfs2_read_blocks(), but the code is still here.
> the previous discussions, you can refer to the links,
> https://oss.oracle.com/pipermail/ocfs2-users/2013-September/006115.html 
> https://oss.oracle.com/bugzilla/show_bug.cgi?id=1235 
> 
> Then, How do we address this problem?
> My suggestion is this bug() line can be wrapped by macro CATCH_BH_JBD_RACES, 
> but this macro should be disable by default in Makefile.
> Any comments is welcome, it is time to finish this problem.
> 
>  
> Thanks
> Gang
> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
