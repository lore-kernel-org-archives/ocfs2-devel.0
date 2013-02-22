From: xiaowei.hu <xiaowei.hu@oracle.com>
Date: Fri, 22 Feb 2013 08:42:51 +0800
Subject: [Ocfs2-devel] [PATCH] the ac->ac_allow_chain_relink=0 won't
 disable group relink
In-Reply-To: <20130221141507.c91be59d.akpm@linux-foundation.org>
References: <1361433259-15336-1-git-send-email-xiaowei.hu@oracle.com>
	<20130221141507.c91be59d.akpm@linux-foundation.org>
Message-ID: <5126BF0B.1070205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

End-users will run into a crash due to run out of credits, backtrace 
like this:

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


On 02/22/2013 06:15 AM, Andrew Morton wrote:
> On Thu, 21 Feb 2013 15:54:19 +0800
> xiaowei.hu at oracle.com wrote:
>
>> ocfs2_block_group_alloc_discontig() disables chain relink by setting
>> ac->ac_allow_chain_relink = 0 because it grabs clusters from multiple
>> cluster groups. It doesn't keep the credits for all chain relink,but
>> ocfs2_claim_suballoc_bits overrides this in this call trace:
>> ocfs2_block_group_claim_bits()->ocfs2_claim_clusters()->
>> __ocfs2_claim_clusters()->ocfs2_claim_suballoc_bits()
>> ocfs2_claim_suballoc_bits set ac->ac_allow_chain_relink = 1; then call
>> ocfs2_search_chain() one time and disable it again, and then we run
>> out of credits.
>>
>> Fix is to allow relink by default and disable it in
>> ocfs2_block_group_alloc_discontig.
> What is the end-user impact of this bug?
>
> Please always include this info in changelogs to help other to decide
> which kernel version(s) need the patch, thanks.
