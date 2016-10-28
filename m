From: Eric Ren <zren@suse.com>
Date: Fri, 28 Oct 2016 13:04:29 +0800
Subject: [Ocfs2-devel] BUG_ON(le64_to_cpu(fe->i_size) != i_size_read(inode))
 is triggered in ocfs2_truncate_file()
Message-ID: <5d30a27d-876e-062c-e9d2-a37724df889a@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Any one ever see this BUG_ON() assertion (https://github.com/torvalds/linux/blob/master/fs/ocfs2/file.c#L460)
triggered? (paste log message at the end). I cannot reproduced it so far.

fallocate with FALLOC_FL_KEEP_SIZE flag (man 2 fallocate) can result in  "le64_to_cpu(fe->i_size) != i_size_read(inode)"
as explained in this commit message:

```
commit d62e74be1270c89fbaf7aada8218bfdf62d00a58
Author: Younger Liu <younger.liu at huawei.com <mailto:younger.liu@huawei.com>>
Date:   Mon Feb 10 14:25:51 2014 -0800

     ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size

The issue scenario is as following:

- Create a small file and fallocate a large disk space for a file with
   FALLOC_FL_KEEP_SIZE option.

- ftruncate the file back to the original size again.  but the disk free
   space is not changed back.  This is a real bug that be fixed in this
   patch.

In order to solve the issue above, we modified ocfs2_setattr(), if
attr->ia_size != i_size_read(inode), It calls ocfs2_truncate_file(), and
truncate disk space to attr->ia_size.
```

I was thinking to remove this BUG_ON() assertion. But, the following steps cannot
trigger it:

$dd if=/dev/zero of=/mnt/ocfs2/test2 bs=512 count=1
$fallocate --keep-size --length 1024000000 /mnt/ocfs2/test2
$truncate --size=512 /mnt/ocfs2/test2

I'm wondering why the testing result goes against what I expect? Finally, I find that:

ocfs2_inode_lock(inode, bh, 1) in ocfs2_setattr() will update the inode->i_size filed from LVB value
or ocfs2_dinode from disk.
---
vfs_truncate
  do_truncate
    inode_lock()
    notify_change
     ocfs2_setattr
      ocfs2_rw_lock()
      ocfs2_inode_lock()
       ocfs2_truncate_file
      ocfs2_rw_lock()
      ocfs2_inode_unlock
    inode_unlock()

---
ocfs2_inode_lock()
  ocfs2_inode_lock_full_nested() ocfs2_inode_lock_update() ==> 
https://github.com/torvalds/linux/blob/master/fs/ocfs2/dlmglue.c#L2204 if 
(ocfs2_meta_lvb_is_trustable()) ocfs2_refresh_inode_from_lvb() else { 
ocfs2_read_inode_block() ocfs2_refresh_inode() } Since we update inode->i_size under the protection of thus locks, how was the assertion triggered?
As always, any comments and suggestion will be appreciated!

Thanks,
Eric

Log message:
```
kernel-default-3.0.101-80
ocfs2-kmp-default-1.6_3.0.101_68-0.25.6

[239098.534619] (dsmc,8244,6):ocfs2_truncate_file:466 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
[239098.534633] (dsmc,8244,6):ocfs2_truncate_file:466 ERROR: Inode 10812, inode i_size = 677 != di i_size = 738, i_flags = 0x1

...

[239098.534724] kernel BUG at /usr/src/packages/BUILD/ocfs2-1.6/default/ocfs2/file.c:466!

PID: 8244   TASK: ffff8801dfb862c0  CPU: 6   COMMAND: "dsmc"
  #0 [ffff8801f59618d0] machine_kexec at ffffffff8102c54e
  #1 [ffff8801f5961920] crash_kexec at ffffffff810ae858
  #2 [ffff8801f59619f0] oops_end at ffffffff8146b558
  #3 [ffff8801f5961a10] do_invalid_op at ffffffff810036c4
  #4 [ffff8801f5961ab0] invalid_op at ffffffff81472d5b
     [exception RIP: ocfs2_truncate_file+165]
     RIP: ffffffffa0929ba5  RSP: ffff8801f5961b68  RFLAGS: 00010296
     RAX: 0000000000000085  RBX: ffff8801dfb862c0  RCX: 0000000000007335
     RDX: 0000000000000000  RSI: 0000000000000007  RDI: 0000000000000246
     RBP: 1000000000000000   R8: ffffffff81da3ac0   R9: 0000000000000000
     R10: 0000000000000003  R11: 00000000ffffffff  R12: ffff8801cbb864f8
     R13: ffff8801dfb86930  R14: ffff8801bf5ad000  R15: 00000000000002a5
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #5 [ffff8801f5961bd0] ocfs2_setattr at ffffffffa092c43e [ocfs2]
  #6 [ffff8801f5961c90] notify_change at ffffffff8117a0cf
  #7 [ffff8801f5961cf0] do_truncate at ffffffff8115e177
  #8 [ffff8801f5961d60] do_last at ffffffff8116d0c3
  #9 [ffff8801f5961dc0] path_openat at ffffffff8116df29
#10 [ffff8801f5961e50] do_filp_open at ffffffff8116e39c
#11 [ffff8801f5961f20] do_sys_open at ffffffff8115eabf
#12 [ffff8801f5961f80] system_call_fastpath at ffffffff81471d72
     RIP: 00007f7da23f67b0  RSP: 00007fffae4a3470  RFLAGS: 00010246
     RAX: 0000000000000002  RBX: ffffffff81471d72  RCX: 0000000000000000
     RDX: 00000000000001b6  RSI: 0000000000000241  RDI: 0000000000cff3df
     RBP: 00007fffae4a4ab0   R8: 0000000000000004   R9: 0000000000000001
     R10: 0000000000000241  R11: 0000000000000246  R12: 0000000000000000
     R13: 0000000000d1d2f0  R14: 0000000000930a68  R15: 0000000000000004
     ORIG_RAX: 0000000000000002  CS: 0033  SS: 002b

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161028/0bc20abc/attachment.html 
