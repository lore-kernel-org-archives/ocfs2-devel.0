From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Mar  9 15:18:20 2004
Subject: [Ocfs2-devel] Bug in error handling
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A569E1@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
To: ocfs2-devel@oss.oracle.com

> At what point did you first see the error? Was it a 1st mount 
> of a fresh
> file system or just a normal mount? I assume the file system 
> failed to mount
> because of this error... Can you be more specific as to what 
> Bad Things (TM)
> were happening?  :) Did it crash or what?

It was NOT a 1st mount.  It was a disk that had been previously used.

It appears that the mount fails but then some globals are probably in a
partially set state.

Here is what I saw after it happened:

# mount -t ocfs2 /dev/sda1 /ocfs2
JBD: no valid journal superblock found
(1856) ERROR: status = -22, /root/ocfs/ocfs2/src/osb.c, 424
(1856) ERROR: status = -22, /root/ocfs/ocfs2/src/super.c, 1047
mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       or too many mounted file systems
[root@linuxjohn2 load_ocfs]# Unable to handle kernel NULL pointer
dereference at virtual address 00000000
 printing eip:
d10bb369
*pde = 0e9b5067
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<d10bb369>]    Tainted: GF
EFLAGS: 00010286
EIP is at ocfs_bh_sem_lookup+0x29/0x650 [ocfs2]
eax: 00000000   ebx: cbc57984   ecx: 000000f9   edx: 000007f9
esi: cbc57984   edi: cbc57984   ebp: 00000800   esp: cc1d5eac
ds: 007b   es: 007b   ss: 0068
Process ocfs2nm-0 (pid: 1857, threadinfo=cc1d4000 task=ccfbd660)
Stack: cbc6a374 cc1d5ed0 0000001f cba16e90 00000010 00000010 ce654a00
cfa0a200
[6~Stack: cbc6a374 cc1d5ed0 0000001f cba16e90 00000010 00000010
ce654a00 cfa0a200
       cfa0a200 00000000 00000000 00000000 00000000 ccfbea40 00000000
cbc57984
       00000000 cc1d5f3c c035cd80 ccdc87b4 00000010 ce6549f0 00011c00
cfa0a200
Call Trace:
 [<d10bb9a1>] ocfs_bh_sem_lock+0x11/0x60 [ocfs2]
 [<d10c6267>] ocfs_read_bhs+0x227/0x930 [ocfs2]
 [<d10bbd6a>] ocfs_bh_sem_hash_prune+0x19a/0x390 [ocfs2]
 [<d10d5d6e>] ocfs_volume_thread+0x29e/0x930 [ocfs2]
 [<d10d5ad0>] ocfs_volume_thread+0x0/0x930 [ocfs2]
 [<c0109295>] kernel_thread_helper+0x5/0x10

Code: 8b 00 89 c3 d3 e3 8d 4d f6 d3 e0 31 c3 88 d1 89 5c 24 34 8b



After this point I couldn't unload OCFS2 anymore.

John
