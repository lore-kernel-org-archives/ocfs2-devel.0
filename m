From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 30 Jul 2012 00:53:34 -0700
Subject: [Ocfs2-devel] kernel BUG at fs/buffer.c:2886! Linux 3.5.0
In-Reply-To: <50163B8A.7060509@aprogsys.com>
References: <501313B6.70801@aprogsys.com>
	<20120730063000.GA4025@dhcp-172-17-9-228.mtv.corp.google.com>
	<50163B8A.7060509@aprogsys.com>
Message-ID: <20120730075333.GC4025@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent ETIENNE <vetienne@aprogsys.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com

On Mon, Jul 30, 2012 at 09:45:14AM +0200, Vincent ETIENNE wrote:
> 
> HI,
> 
> Le 30/07/2012 08:30, Joel Becker a ?crit :
> > On Sat, Jul 28, 2012 at 12:18:30AM +0200, Vincent ETIENNE wrote:
> >> Hello
> >>
> >> Get this on first write made ( by deliver sending mail to inform of the
> >> restart of services  )
> >> Home partition (the one receiving the mail) is based on ocfs2 created
> >> from drbd block device in primary/primary mode
> >> These drbd devices are based on lvm.
> >>
> >> system is running linux-3.5.0, identical symptom with linux 3.3 and 3.2
> >> but working with linux 3.0 kernel
> >>
> >> reproduced on two machines ( so different hardware involved on this one
> >> software md raid on SATA, on second one areca hardware raid card )
> >> but the 2 machines are the one sharing this partition ( so share the
> >> same data )
> > 	Hmm.  Any chance you can bisect this further?
> 
> Will try to. Will take a few days as the server is in production ( but
> used as backup so...)
> 
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.169213] ------------[ cut here
> >> ]------------
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.169261] kernel BUG at
> >> fs/buffer.c:2886!
> > 	This is:
> >
> > 	BUG_ON(!buffer_mapped(bh));
> >
> > in submit_bh().
> >
> >
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003] Call Trace:
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81327546>] ?
> >> ocfs2_read_blocks+0x176/0x6c0
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8114e541>] ?
> >> T.1552+0x91/0x2b0
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81346ad0>] ?
> >> ocfs2_find_actor+0x120/0x120
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813464f7>] ?
> >> ocfs2_read_inode_block_full+0x37/0x60
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813964ff>] ?
> >> ocfs2_fast_symlink_readpage+0x2f/0x160
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81111585>] ?
> >> do_read_cache_page+0x85/0x180
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813964d0>] ?
> >> ocfs2_fill_super+0x2500/0x2500
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff811116d9>] ?
> >> read_cache_page+0x9/0x20
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115c705>] ?
> >> page_getlink+0x25/0x80
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115c77b>] ?
> >> page_follow_link_light+0x1b/0x30
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8116099b>] ?
> >> path_lookupat+0x38b/0x720
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81160d5c>] ?
> >> do_path_lookup+0x2c/0xd0
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81346f31>] ?
> >> ocfs2_inode_revalidate+0x71/0x160
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81161c0c>] ?
> >> user_path_at_empty+0x5c/0xb0
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8106714a>] ?
> >> do_page_fault+0x1aa/0x3c0
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81156f2d>] ?
> >> cp_new_stat+0x10d/0x120
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81157021>] ?
> >> vfs_fstatat+0x41/0x80
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115715f>] ?
> >> sys_newstat+0x1f/0x50
> >> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff817ecee2>] ?
> >> system_call_fastpath+0x16/0x1b
> > 	This stack trace is from 3.5, because of the location of the
> > BUG.  The call path in the trace suggests the code added by Al's ea022d,
> > but you say it breaks in 3.2 and 3.3 as well.  Can you give me a trace
> > from 3.2?
> 
> For a 3.2 kernel i get this stack trace. Different trace form 3.5 but
> exactly at the same moment. and for the same reasons.
> Seems to be less immmediate than with 3.5 but more a subjective
> imrpession than something based on fact. ( it takes a few seconds after
> deliver is started to have the bug )

Totally different stack trace.  Not in symlink code, but instead in
fallocate.  Weird.  I wonder if you are hitting two things.  Bisection
will definitely help.

Joel

> [  716.402833] o2dlm: Joining domain B43153ED20B942E291251F2C138ADA9E (
> 0 1 ) 2 nodes
> [  716.501511] ocfs2: Mounting device (147,2) on (node 1, slot 0) with
> ordered data mode.
> [  716.505744] mount.ocfs2 used greatest stack depth: 2936 bytes left
> [  727.133743] deliver used greatest stack depth: 2632 bytes left
> [  764.167029] deliver used greatest stack depth: 1896 bytes left
> [  764.778872] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000038
> [  764.778897] IP: [<ffffffff8133c51a>]
> __ocfs2_change_file_space+0x75a/0x1690
> [  764.778922] PGD 62697067 PUD 67a81067 PMD 0
> [  764.778939] Oops: 0000 [#1] SMP
> [  764.778953] CPU 0
> [  764.778959] Modules linked in: drbd lru_cache ipv6 [last unloaded: drbd]
> [  764.778986]
> [  764.778993] Pid: 5909, comm: deliver Not tainted 3.2.12-gentoo #2 HP
> ProLiant ML150 G3/ML150 G3
> [  764.779017] RIP: 0010:[<ffffffff8133c51a>]  [<ffffffff8133c51a>]
> __ocfs2_change_file_space+0x75a/0x1690
> [  764.779041] RSP: 0018:ffff880067b2dd98  EFLAGS: 00010246
> [  764.779053] RAX: 0000000000000000 RBX: ffff880067f82000 RCX:
> ffff880063d11000
> [  764.779069] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
> ffff88007ae83288
> [  764.779085] RBP: ffff880055d1f138 R08: 0010000000000000 R09:
> ffff880063d11000
> [  764.779100] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff88007ae83288
> [  764.779115] R13: 0000000000000000 R14: 0000000000000000 R15:
> 00000000000000df
> [  764.779132] FS:  00007f1e40eb5700(0000) GS:ffff88007fc00000(0000)
> knlGS:0000000000000000
> [  764.779149] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  764.779219] CR2: 0000000000000038 CR3: 0000000067ab5000 CR4:
> 00000000000006f0
> [  764.779291] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  764.779364] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  764.779436] Process deliver (pid: 5909, threadinfo ffff880067b2c000,
> task ffff88007bedbc00)
> [  764.779569] Stack:
> [  764.779634]  ffffea0001647840 ffffffff8112983f 0000000000000000
> ffff880000000000
> [  764.779768]  00000000000de000 ffffffff81333f35 ffffffff8133f880
> 0000000000000000
> [  764.779903]  000000017d002240 ffff880055d1f1d8 ffff880000000001
> ffff880067976708
> [  764.780009] Call Trace:
> [  764.780009]  [<ffffffff8112983f>] ? handle_pte_fault+0x7cf/0x9e0
> [  764.780009]  [<ffffffff81333f35>] ?
> ocfs2_inode_lock_full_nested+0x355/0xb40
> [  764.780009]  [<ffffffff8133f880>] ? ocfs2_inode_revalidate+0x70/0x160
> [  764.780009]  [<ffffffff8106337a>] ? do_page_fault+0x1aa/0x3c0
> [  764.780009]  [<ffffffff8114e780>] ? cp_new_stat+0xe0/0x100
> [  764.780009]  [<ffffffff8133d4cd>] ? ocfs2_fallocate+0x7d/0x90
> [  764.780009]  [<ffffffff811489e7>] ? do_fallocate+0x117/0x120
> [  764.780009]  [<ffffffff81148a34>] ? sys_fallocate+0x44/0x70
> [  764.780009]  [<ffffffff81771bbb>] ? system_call_fastpath+0x16/0x1b
> [  764.780009] Code: 89 45 60 48 89 55 68 48 89 45 70 48 89 55 78 4c 89
> e7 48 8b 94 24 00 01 00 00 e8 12 31 00 00 41 89 c2 85 c0 78 2e 48 8b 54
> 24 38 <f7> 42 38 00 10 10 00 74 06 41 80 4c 24 14 01 44 89 54 24 18 4c
> [  764.780785] RIP  [<ffffffff8133c51a>]
> __ocfs2_change_file_space+0x75a/0x1690
> [  764.780785]  RSP <ffff880067b2dd98>
> [  764.780785] CR2: 0000000000000038
> [  764.781561] ---[ end trace 654757aba94c3768 ]---
> 
> Vincent
> 
> > Joel
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

Life's Little Instruction Book #456

	"Send your loved one flowers.  Think of a reason later."

			http://www.jlbec.org/
			jlbec at evilplan.org
