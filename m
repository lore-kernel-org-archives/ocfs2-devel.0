From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 31 May 2013 12:58:45 -0700
Subject: [Ocfs2-devel] ocfs2: kernel BUG at fs/ocfs2/buffer_head_io.c
In-Reply-To: <51A57849.8020006@huawei.com>
References: <51A1FE3A.8090001@huawei.com> <51A57849.8020006@huawei.com>
Message-ID: <20130531195845.GD18925@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 29, 2013 at 11:38:49AM +0800, Joseph Qi wrote:
> Anyone can give me some advice?
> 
> On 2013/5/26 20:21, Joseph Qi wrote:
> > I have triggered a BUG at buffer_head_io.c. Belowing is the code where
> > the BUG is triggered:
> > if (buffer_needs_validate(bh)) {
> > 	/* We never set NeedsValidate if the
> > 	 * buffer was held by the journal, so
> > 	 * that better not have changed */
> > 	BUG_ON(buffer_jbd(bh));
> > 	clear_buffer_needs_validate(bh);
> > 	status = validate(sb, bh);
> > 	if (status) {
> > 		put_bh(bh);
> > 		bhs[i] = NULL;
> > 		continue;
> > 	}
> > }
> > 
> > As the comment says, BH_NeedsValidate and buffer_jbd are mutually
> > exclusive. Has anyone else also encountered this issue? My case is
> > iSCSI link down and then restore with system 80% stress.

I haven't seen this before no. The check makes sense and the comment is
correct - if the buffer is in the journal, it should never need to be
re-read as by definition it should be up to date.


> > Here is the stack:
> > [ 2406.046006] kernel BUG at fs/ocfs2/buffer_head_io.c:343!
> > [ 2406.046010] invalid opcode: 0000 [#1] SMP
> > ...
> > [ 2406.046226] Pid: 10743, comm: fio Tainted: G          N  3.0.13-0.27-xen #2 Tecal RH2285          
> > [ 2406.046233] RIP: e030:[<ffffffffa05a7e84>]  [<ffffffffa05a7e84>] ocfs2_read_blocks+0x734/0x8d0 [ocfs2]
> > [ 2406.046254] RSP: e02b:ffff8800e41a9c18  EFLAGS: 00010206
> > [ 2406.046259] RAX: 0000000000000000 RBX: ffff8800f9a27470 RCX: 0000000000000008
> > [ 2406.046265] RDX: 0000000002310029 RSI: ffff8800f9a27470 RDI: ffff8800f9bb7690
> > [ 2406.046270] RBP: 0000000000000000 R08: ffff8800e3684b48 R09: 0000000000000002
> > [ 2406.046276] R10: ffff8800f9bb76d8 R11: ffffffffa05cbc20 R12: ffff8800e41a9cf0
> > [ 2406.046282] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > [ 2406.046292] FS:  00007f871f4a8700(0000) GS:ffff88000401a000(0000) knlGS:0000000000000000
> > [ 2406.046298] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [ 2406.046303] CR2: 00007f871e585820 CR3: 00000000e7870000 CR4: 0000000000002620
> > [ 2406.046309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 2406.046315] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [ 2406.046321] Process fio (pid: 10743, threadinfo ffff8800e41a8000, task ffff8800e41ae5c0)
> > [ 2406.046327] Stack:
> > [ 2406.046330]  ffff8800e41ae5c0 ffff8800f9bb726c 000000003432205b 0000000500000008
> > [ 2406.046338] <0> ffff8800e41aea68 ffff8800e41ae5c0 ffff8800e41aea68 ffff8800e41ae5c0
> > [ 2406.046349] <0> 00000000f9bb726c ffff8800e41aea68 ffff8800e41ae5c0 ffffffffa05cc2f0
> > [ 2406.046360] Call Trace:
> > [ 2406.046393]  [<ffffffffa05cbdd7>] ocfs2_read_inode_block_full+0x37/0x60 [ocfs2]
> > [ 2406.046423]  [<ffffffffa05bee5d>] ocfs2_inode_lock_full_nested+0x5bd/0xdd0 [ocfs2]
> > [ 2406.046451]  [<ffffffffa05c9f9d>] __ocfs2_change_file_space+0x1bd/0x1800 [ocfs2]
> > [ 2406.046480]  [<ffffffffa05cb669>] ocfs2_fallocate+0x89/0x90 [ocfs2]
> > [ 2406.046503]  [<ffffffff800d7264>] do_fallocate+0x104/0x110
> > [ 2406.046512]  [<ffffffff800d72b6>] sys_fallocate+0x46/0x70
> > [ 2406.046521]  [<ffffffff80007378>] system_call_fastpath+0x16/0x1b
> > [ 2406.046530]  [<00007f871e585845>] 0x7f871e585845
> > [ 2406.046534] Code: ea ff ff ff 41 b9 c6 00 00 00 49 c7 c0 40 4b 62 a0 48 c7 c7 28 f8 62 a0 31 c0 e8 1d f3 dc df 48 8b 05 81 58 f8 ff e9 87 fe ff ff <0f> 0b eb fe 48 8b bc 24 80 00 00 00 41 bd 01 00 00 00 e8 95 0c 
> > [ 2406.046611] RIP  [<ffffffffa05a7e84>] ocfs2_read_blocks+0x734/0x8d0 [ocfs2]
> > [ 2406.046625]  RSP <ffff8800e41a9c18>

Ok, the stack doesn't show me a whole lot unfortunately other than we were
in fallocate when the bug hit. Can you replicate this readily? If so then
what we want to do is track down that buffer and figure out how it got into
that state.
	--Mark

--
Mark Fasheh
