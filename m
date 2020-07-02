From: Gang He <ghe@suse.com>
Date: Thu, 2 Jul 2020 16:48:12 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: fix value of OCFS2_INVALID_SLOT
In-Reply-To: <20200616183829.87211-5-junxiao.bi@oracle.com>
References: <20200616183829.87211-1-junxiao.bi@oracle.com>
	<20200616183829.87211-5-junxiao.bi@oracle.com>
Message-ID: <64dedfcb-e0be-c387-fbca-888549a05bcf@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Junxiao,

Thank for your patches, which looks to fix the nfsd access problem.
But the patches bring a new bug, like below,

[  251.406698] BUG: unable to handle kernel paging request at 
0000565336a6bdf8
[  251.406706] #PF error: [WRITE]
[  251.406710] PGD 0 P4D 0
[  251.406717] Oops: 0002 [#1] SMP PTI
[  251.406724] CPU: 3 PID: 3758 Comm: mkdir Tainted: G           OE 
5.0.6-1-default #1 openSUSE Tumbleweed (unreleased)
[  251.406729] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.8.1-0-g4adadbd-20151112_172657-sheep25 04/01/2014
[  251.406739] RIP: 0010:_raw_spin_lock+0xc/0x20
[  251.406743] Code: 02 00 00 f0 0f c1 03 a9 ff 01 00 00 75 06 48 89 e8 
5b 5d c3 48 89 df e8 a2 4f 87 ff eb f0 0f 1f 44 00 00 31 c0 ba 01 00 00 
00 <f0> 0f b1 17 75 01 c3 89 c6 e8 76 3a 87 ff 66 90 c3 0f 1f 00 0f 1f
[  251.406750] RSP: 0018:ffffb65401087bf0 EFLAGS: 00010246
[  251.406755] RAX: 0000000000000000 RBX: 0000565336a6bd70 RCX: 
00000000ffffffff
[  251.406759] RDX: 0000000000000001 RSI: 0000000000000009 RDI: 
0000565336a6bdf8
[  251.406763] RBP: 0000565336a6bdf8 R08: 0000000000000000 R09: 
0000000000000000
[  251.406767] R10: 0000000000000005 R11: ffff9d7ded1bb000 R12: 
ffff9d7e38c559d0
[  251.406771] R13: ffff9d7e39354be8 R14: ffff9d7e393540c8 R15: 
00000000ffffffff
[  251.406777] FS:  00007f32d9e39c40(0000) GS:ffff9d7e3db80000(0000) 
knlGS:0000000000000000
[  251.406782] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  251.406788] CR2: 0000565336a6bdf8 CR3: 0000000076496000 CR4: 
00000000000006e0
[  251.406801] Call Trace:
[  251.406824]  igrab+0x19/0x50
[  251.406941]  ocfs2_get_system_file_inode+0x65/0x2e0 [ocfs2]
[  251.406980]  ? ocfs2_find_entry+0x354/0x7f0 [ocfs2]
[  251.407025]  ocfs2_reserve_suballoc_bits+0x3b/0x450 [ocfs2]
[  251.407070]  ocfs2_steal_resource+0x8d/0x100 [ocfs2]
[  251.407113]  ocfs2_reserve_new_inode+0x97/0x3d0 [ocfs2]
[  251.407154]  ocfs2_mknod+0x3a7/0xe70 [ocfs2]
[  251.407191]  ? __ocfs2_cluster_unlock.isra.47+0x24/0xd0 [ocfs2]
[  251.407231]  ocfs2_mkdir+0x33/0x120 [ocfs2]
[  251.407239]  ? inode_permission+0xbe/0x180
[  251.407244]  vfs_mkdir+0x102/0x1b0
[  251.407250]  do_mkdirat+0xd9/0x100
[  251.407258]  do_syscall_64+0x60/0x110
[  251.407265]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  251.407271] RIP: 0033:0x7f32d9fbf307
[  251.407276] Code: 1f 40 00 48 8b 05 91 eb 0c 00 64 c7 00 5f 00 00 00 
b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 53 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 eb 0c 00 f7 d8 64 89 01 48
[  251.407283] RSP: 002b:00007fff36999c98 EFLAGS: 00000202 ORIG_RAX: 
0000000000000053
[  251.407289] RAX: ffffffffffffffda RBX: 00007fff3699b618 RCX: 
00007f32d9fbf307
[  251.407294] RDX: 0000000000000000 RSI: 00000000000001ff RDI: 
00007fff3699b618
[  251.407298] RBP: 00007fff3699b618 R08: 00000000000001ff R09: 
000055a9fe8b2c00

I feel the problem looks related to this patch.

Thanks
Gang

On 6/17/2020 2:38 AM, Junxiao Bi wrote:
>>From ocfs2 disk layout, slot number is 16 bits, but in ocfs2 implemtation,
> slot number is 32 bits, usually this will not cause any issue, because
> slot number is converting from u16 to u32, but OCFS2_INVALID_SLOT was
> defined as -1, when an invalid slot number from disk was got, it value
> was (u16)-1, and it was converted to u32, then the following checking
> in get_local_system_inode will be always skipped.
> 
>   static struct inode **get_local_system_inode(struct ocfs2_super *osb,
>                                                 int type,
>                                                 u32 slot)
>   {
>   	BUG_ON(slot == OCFS2_INVALID_SLOT);
> 	...
>   }
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/ocfs2/ocfs2_fs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 3fc99659ed09..19137c6d087b 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -290,7 +290,7 @@
>   #define OCFS2_MAX_SLOTS			255
>   
>   /* Slot map indicator for an empty slot */
> -#define OCFS2_INVALID_SLOT		-1
> +#define OCFS2_INVALID_SLOT		((u16)-1)
>   
>   #define OCFS2_VOL_UUID_LEN		16
>   #define OCFS2_MAX_VOL_LABEL_LEN		64
> 
