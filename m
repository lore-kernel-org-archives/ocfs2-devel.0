From: Gang He <ghe@suse.com>
Date: Mon, 10 Apr 2017 01:50:20 -0600
Subject: [Ocfs2-devel] [Bug Report] crash in the path of direct IO
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37342E82370@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E37342E82370@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <58EBA9BC020000F90006EFEB@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ge.changwei@h3c.com, ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Changwei,

Did you get this kernel crash file? 
Could you paste longer syslog before crash (e.g. 100 ~ 200 lines) via crash tool?
e.g. 
crash vmlinux-4.4.21-69-default.gz vmcore
crash> log



Thanks
Gang


>>> 
> Hi,
> 
> We encountered a crash issue days ago.
> 
> The call trace follows as below:
> 
> From the call trace, we can see that a direct read request caused this
> crash issue, which triggered a BUG_ON check point.
> 
> With the help of debugfs.ocfs2 tool, I can see that clusters owned by
> the target file are extremely scattered . Most of them are not
> 
> continuous.
> 
> Does anyone have ideas about this issue?
> 
> [10628085.052236] RIP: 0010:[<ffffffff81240ba0>]  [<ffffffff81240ba0>]
> do_blockdev_direct_IO+0x1e10/0x1eb0
> [10628085.052248] RSP: 0018:ffff88018038fa38  EFLAGS: 00010246
> [10628085.052252] RAX: 0000000000000000 RBX: ffff8800ae579680 RCX:
> 0000000000000009
> [10628085.052258] RDX: 0000000000000000 RSI: 000000000fb25900 RDI:
> 000000007d92c800
> [10628085.052265] RBP: ffff88018038fc68 R08: ffff8805e042a298 R09:
> 0000000000000001
> [10628085.052271] R10: 0000000000000003 R11: 0000000000000000 R12:
> 0000000000000000
> [10628085.052277] R13: 0000000000000a00 R14: ffff8800ae5796a8 R15:
> ffffea0014865280
> [10628085.052284] FS:  00007f7f517fa700(0000) GS:ffff8806276c0000(0000)
> knlGS:0000000000000000
> [10628085.052290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [10628085.052294] CR2: 000000001fbc0000 CR3: 0000000bdb8f7000 CR4:
> 00000000001426e0
> [10628085.052300] Stack:
> [10628085.052304]  ffff88018038fc60 ffff880626c18d00 0000000000117c00
> ffff8800ae5796e8
> [10628085.052311]  ffff88018038fb90 ffff8800ae5796b4 0000000000000200
> 0000000000131000
> [10628085.052318]  000000007d92c5fb ffff88052194a000 0000000117c00000
> fffffffffffffe00
> [10628085.052326] Call Trace:
> [10628085.052371]  [<ffffffffc06ea3c0>] ?
> ocfs2_zero_new_buffers+0x130/0x130 [ocfs2]
> [10628085.052379]  [<ffffffff81240c83>] __blockdev_direct_IO+0x43/0x50
> [10628085.052395]  [<ffffffffc06e9af0>] ? ocfs2_zero_tail+0x50/0x50 [ocfs2]
> [10628085.052411]  [<ffffffffc06e933f>] ocfs2_direct_IO+0x8f/0xa0 [ocfs2]
> [10628085.052426]  [<ffffffffc06e9af0>] ? ocfs2_zero_tail+0x50/0x50 [ocfs2]
> [10628085.052432]  [<ffffffff8118ba1a>] generic_file_read_iter+0x56a/0x610
> [10628085.052449]  [<ffffffffc070004b>] ?
> __ocfs2_cluster_unlock.isra.36+0xab/0xf0 [ocfs2]
> [10628085.052469]  [<ffffffffc070a2da>] ocfs2_file_read_iter+0xca/0x410
> [ocfs2]
> [10628085.052476]  [<ffffffff810ffe44>] ? do_futex+0x304/0xbc0
> [10628085.052481]  [<ffffffff8120263b>] __vfs_read+0xab/0xf0
> [10628085.052487]  [<ffffffff812039d5>] vfs_read+0x95/0x130
> [10628085.052491]  [<ffffffff81203c62>] SyS_pread64+0x92/0xa0
> [10628085.052498]  [<ffffffff817f81b2>] system_call_fastpath+0x16/0x75
> 
> 
> Br.
> 
> Thanks.
> 
> Changwei.
