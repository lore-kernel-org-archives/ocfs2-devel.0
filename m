From: Jan-Benedict Glaw <jbglaw@telefonica.de>
Date: Tue Nov 21 13:31:22 2006
Subject: [Ocfs2-devel] Memory leak in ocfs2/dlm?
In-Reply-To: <45636CC7.4000600@telefonica.de>
References: <45636CC7.4000600@telefonica.de>
Message-ID: <4563700D.8060707@telefonica.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan-Benedict Glaw wrote:
> Seems we're facing some memory leak here. This is vanilla 2.6.19-rc6
> on a x86_64 box, 4GB RAM.
> 
> A simple `ls -Rn' on a filesystem with lots of files makes the box
> leak so much RAM that the OOM killer starts to kick in. With slab
> alloc debugging turned on, we see this:
> 
> # mount; ls -Rn; wait some seconds; Ctrl-C
> 
> [root@lnxp-1038:/backend1]$ cat /proc/slab_allocators | egrep '(size.512|ocfs2_inode_cache)' | grep ocfs | sort -k 2 -n
> size-512: 1 o2hb_heartbeat_group_make_item+0x1b/0x79 [ocfs2_nodemanager]
> size-512: 1 o2hb_map_slot_data+0x22/0x2fa [ocfs2_nodemanager]
> size-512: 1 ocfs2_initialize_super+0x55e/0xd7f [ocfs2]
> size-512: 26439 ocfs2_dentry_attach_lock+0x2d1/0x423 [ocfs2]
> ocfs2_inode_cache: 26450 ocfs2_alloc_inode+0x13/0x29 [ocfs2]
> size-512: 52879 dlm_new_lockres+0x22/0x189 [ocfs2_dlm]
> 
> # Clear caches
> 
> [root@lnxp-1038:/mail/store/backend1]$ echo 3 > /proc/sys/vm/drop_caches 
> [root@lnxp-1038:/mail/store/backend1]$ echo 0 > /proc/sys/vm/drop_caches 
> 
> [root@lnxp-1038:/backend1]$ cat /proc/slab_allocators | egrep '(size.512|ocfs2_inode_cache)' | grep ocfs | sort -k 2 -n
> size-512: 1 o2hb_heartbeat_group_make_item+0x1b/0x79 [ocfs2_nodemanager]
> size-512: 1 o2hb_map_slot_data+0x22/0x2fa [ocfs2_nodemanager]
> size-512: 1 ocfs2_initialize_super+0x55e/0xd7f [ocfs2]
> size-512: 9 ocfs2_dentry_attach_lock+0x2d1/0x423 [ocfs2]
> ocfs2_inode_cache: 20 ocfs2_alloc_inode+0x13/0x29 [ocfs2]
> size-512: 52379 dlm_new_lockres+0x22/0x189 [ocfs2_dlm]

Just to add, there's another one in the size-32 slab:

[root@lnxp-1038:~]$ echo fs_locks | debugfs.ocfs2 /dev/sdb1 | grep Lockres | wc -l
debugfs.ocfs2 1.2.2
77868

[root@lnxp-1038:~]$ grep dlm /proc/slab_allocators | sort -k2 -n
dlmfs_inode_cache: 1 dlmfs_alloc_inode+0x12/0x27 [ocfs2_dlmfs]
size-1024: 1 dlm_alloc_ctxt+0x26/0x4a0 [ocfs2_dlm]
size-32: 1 dlm_alloc_ctxt+0x134/0x4a0 [ocfs2_dlm]
size-32: 1 ocfs2_new_dlm_debug+0x12/0x95 [ocfs2]
size-64: 1 dlm_alloc_ctxt+0xb2/0x4a0 [ocfs2_dlm]
size-256: 42166 dlm_new_lock+0x2c/0x11a [ocfs2_dlm]
size-32: 42166 dlm_new_lockres+0x40/0x189 [ocfs2_dlm]
size-512: 42166 dlm_new_lockres+0x22/0x189 [ocfs2_dlm]

[root@lnxp-1038:~]$ echo 3 > /proc/sys/vm/drop_caches 
[root@lnxp-1038:~]$ echo 0 > /proc/sys/vm/drop_caches 

[root@lnxp-1038:~]$ grep dlm /proc/slab_allocators | sort -k2 -n
dlmfs_inode_cache: 1 dlmfs_alloc_inode+0x12/0x27 [ocfs2_dlmfs]
size-1024: 1 dlm_alloc_ctxt+0x26/0x4a0 [ocfs2_dlm]
size-32: 1 dlm_alloc_ctxt+0x134/0x4a0 [ocfs2_dlm]
size-32: 1 ocfs2_new_dlm_debug+0x12/0x95 [ocfs2]
size-64: 1 dlm_alloc_ctxt+0xb2/0x4a0 [ocfs2_dlm]
size-256: 78 dlm_new_lock+0x2c/0x11a [ocfs2_dlm]
size-32: 41796 dlm_new_lockres+0x40/0x189 [ocfs2_dlm]
size-512: 41796 dlm_new_lockres+0x22/0x189 [ocfs2_dlm]

[root@lnxp-1038:~]$ echo fs_locks | debugfs.ocfs2 /dev/sdb1 | grep Lockres | wc -l
debugfs.ocfs2 1.2.2
169

MfG, JBG

-- 
Telef?nica Deutschland GmbH     | Jan-Benedict Glaw
H?lshorstweg 30                 | Configuration Management
33415 Verl                      | Email: <jbglaw@telefonica.de>
http://www.telefonica.de/       | Tel.: +49-5246-80-1869

-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 189 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20061121/4c25c14a/signature.bin
