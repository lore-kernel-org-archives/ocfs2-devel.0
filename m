From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri May 28 03:27:57 2004
Subject: [Ocfs2-devel] bug for the new revision
Message-ID: <3ACA40606221794F80A5670F0AF15F84047B22BA@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


I tried the new ocfs2 [SVN 957] with new format, I use the new
ocfs-tools
svn
http://oss.oracle.com/projects/ocfs-tools/src/branches/new-dir-format/ 
My step
1.mkfs.ocfs2 -m /ocfs -L ocfs -b 4 /dev/hda3
2.load_ocfs2
3.mount /dev/hda3 /ocfs 
The mount went into uninterruptable sleep.


call trace by magic-sysrq

mount         D 00000000     0  1268    740                     (NOTLB)
Call Trace:    [<d08697d8>] [<c0105f8a>] [<c01060e4>] [<d086adba>]
[<d0869add>]
  [<c010b458>] [<d0873dd5>] [<d0873585>] [<d08a1505>] [<d08a1f19>]
[<d08902fb>]
  [<d08692a1>] [<d0897365>] [<d0895086>] [<d089530d>] [<c013c57b>]
[<c013bcbc>]
  [<d08b4804>] [<c013c8d1>] [<d08b4804>] [<c014f173>] [<c014f4a0>]
[<c014f2e9>]
  [<c014f921>] [<c010742f>]

output by ksymsoops
Trace; d08697d8 <[ocfs2]ocfs_bh_sem_lookup+1f8/4c0>
Trace; c0105f8a <__down+6a/b0>
Trace; c01060e4 <__down_failed+8/c>
Trace; d086adba <[ocfs2].text.lock.KBUILD_BASENAME+5/17>
Trace; d0869add <[ocfs2]ocfs_bh_sem_lock+3d/d8>
Trace; c010b458 <call_do_IRQ+5/d>
Trace; d0873dd5 <[ocfs2]OCFS_BH_GET_DATA_READ+31/174>
Trace; d0873585 <[ocfs2]ocfs_read_bhs+6b5/ed4>
Trace; d08a1505 <[ocfs2]ocfs_chk_update_config+185/ae8>
Trace; d08a1f19 <[ocfs2]ocfs_get_config+b1/460>
Trace; d08902fb <[ocfs2]ocfs_initialize_osb+9a3/151c>
Trace; d08692a1 <[ocfs2]ocfs_bh_sem_alloc+21/34>
Trace; d0897365 <[ocfs2]ocfs_mount_volume+3d9/120c>
Trace; d0895086 <[ocfs2]__ocfs_read_super+29e/4f4>
Trace; d089530d <[ocfs2]ocfs_read_super+31/70>
Trace; c013c57b <get_sb_bdev+18b/250>
Trace; c013bcbc <get_fs_type+2c/80>
Trace; d08b4804 <[ocfs2]ocfs_fs_type+0/7c>
Trace; c013c8d1 <do_kern_mount+121/140>
Trace; d08b4804 <[ocfs2]ocfs_fs_type+0/7c>
Trace; c014f173 <do_add_mount+93/190>
Trace; c014f4a0 <do_mount+160/1b0>
Trace; c014f2e9 <copy_mount_options+79/d0>
Trace; c014f921 <sys_mount+b1/e0>
Trace; c010742f <system_call+33/38> 

see bug 77
