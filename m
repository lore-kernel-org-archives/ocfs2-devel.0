From: David Weber <wb@munzinger.de>
Date: Thu, 25 Jul 2013 12:13:31 +0200
Subject: [Ocfs2-devel] NULL pointer dereference at ocfs2_dir_foreach_blk_id
Message-ID: <1394429.Cu7O6gPXEE@o3-3>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

we reproducibly run into a NULL pointer dereference in OCFS2 on Linux 3.11.0-
rc2
It always happens if we try to copy or delete directories.

The Filesystem was created with:
mkfs.ocfs2 -b 4K -C 1M -J block64 -L kvm-images -T vmstore /dev/drbd0

cat /etc/ocfs2/cluster.conf :
cluster:
heartbeat_mode = global
node_count = 2
name = kvm

node:
number = 0
cluster = kvm
ip_port = 7777
ip_address = 192.168.100.229
name = dinah

node:
number = 1
cluster = kvm
ip_port = 7777
ip_address = 192.168.100.228
name = alice


dmesg:
[ 42.191816] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 42.192753] IP: [< (null)>] (null)
[ 42.193348] PGD 79c1f9067 PUD 79c38a067 PMD 0 
[ 42.193913] Oops: 0010 [#1] SMP 
[ 42.194338] Modules linked in: ebtable_nat ebtables ocfs2_stack_o2cb bridge 
stp llc kvm_intel kvm drbd lru_cache dlm sctp libcrc32c ocfs2_dlm ocfs2_dlmfs 
ocfs2 ocfs2_stackglue ocfs2_nodemanager configfs e1000e
[ 42.196944] CPU: 1 PID: 2392 Comm: rm Not tainted 3.11.0-rc2 #19
[ 42.197617] Hardware name: Supermicro X8DT6/X8DT6, BIOS 2.0a 09/14/2010
[ 42.198389] task: ffff880799d06320 ti: ffff88079c664000 task.ti: ffff88079c664000
[ 42.199251] RIP: 0010:[<0000000000000000>] [< (null)>] (null)
[ 42.200545] RSP: 0018:ffff88079c665c30 EFLAGS: 00010293
[ 42.201394] RAX: 0000000000000002 RBX: 0000000000000010 RCX: 0000000000000000
[ 42.202190] RDX: 0000000000000001 RSI: ffff88079290c0d4 RDI: ffff88079c665ce8
[ 42.202995] RBP: ffff88079c665ca8 R08: 00000000000ea90e R09: 0000000000000004
[ 42.203794] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88079290c0c0
[ 42.204600] R13: ffff88079c665ce8 R14: ffff88079290c0c8 R15: ffff8807960ba598
[ 42.205406] FS: 00007f4b6d259700(0000) GS:ffff8807a1220000(0000) 
knlGS:0000000000000000
[ 42.206115] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 42.206453] CR2: 0000000000000000 CR3: 000000079b02a000 CR4: 00000000000007e0
[ 42.207045] Stack:
[ 42.207266] ffffffffa00d8947 ffff88079c665e18 ffff8807960ba2c0 ffff88079c665c78
[ 42.208184] ffff88079290c0c0 ffff88079290c000 ffff88079c665cc0 ffff8807960ba598
[ 42.209089] ffff8807961269c0 ffff88079c665c88 ffff8807960ba598 00000000ffffffd9
[ 42.210298] Call Trace:
[ 42.210579] [] ? ocfs2_dir_foreach_blk_id+0x169/0x212 [ocfs2]
[ 42.211419] [] ocfs2_dir_foreach+0x3a/0x3e [ocfs2]
[ 42.212145] [] ocfs2_empty_dir+0x148/0x391 [ocfs2]
[ 42.212880] [] ocfs2_unlink+0x567/0xbc3 [ocfs2]
[ 42.213573] [] ? __ocfs2_cluster_unlock.isra.41+0x89/0xbb [ocfs2]
[ 42.214463] [] vfs_rmdir+0xb0/0xfe
[ 42.215039] [] do_rmdir+0x143/0x19b
[ 42.215611] [] ? task_work_run+0x86/0xac
[ 42.216232] [] SyS_unlinkat+0x25/0x27
[ 42.216818] [] system_call_fastpath+0x16/0x1b
[ 42.217487] Code: Bad RIP value.
[ 42.217901] RIP [< (null)>] (null)
[ 42.218509] RSP 
[ 42.218896] CR2: 0000000000000000
[ 42.219352] ---[ end trace 1c32c45da41ce169 ]---


The dereference happens here:
Reading symbols from /usr/src/linux-3.11-rc2/fs/ocfs2/dir.o...done.
(gdb) list *(ocfs2_dir_foreach_blk_id+0x169)
0x4497 is in ocfs2_dir_foreach_blk_id (fs/ocfs2/dir.c:1820).
1815 unsigned char d_type = DT_UNKNOWN;
1816
1817 if (de->file_type < OCFS2_FT_MAX)
1818 d_type = ocfs2_filetype_table[de->file_type];
1819
1820 if (!dir_emit(ctx, de->name, de->name_len,
1821 le64_to_cpu(de->inode), d_type))
1822 goto out;
1823 }
1824 ctx->pos += le16_to_cpu(de->rec_len);

Thanks in advance!

Cheers,
David
