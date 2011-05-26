From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 26 May 2011 17:40:16 +0800
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: bugfix for hard readonly mount
Message-ID: <4DDE2000.3000301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, All,

These four patches are all related to ocfs2 on hard readonly mount.
patch 1 fix oops when umount ocfs2 on hard readonly device.
Because ocfs2_dismount_volume() will call ocfs2_cluster_hangup() and 
then call ocfs2_stack_driver_put(), will hit BUG_ON(active_stack == NULL).

patch 2 fix oops when do ls or cat in ocfs2 on hard readonly device.
Because ocfs2_open_lock() will call ocfs2_cluster_lock() and then call 
ocfs2_dlm_lock(), but active_stack is NULL.

patch 3 fix bug of http://oss.oracle.com/bugzilla/show_bug.cgi?id=1322
ocfs2_statfs, ocfs2_fiemap, ocfs2_get_acl, ocfs2_listxattr and 
ocfs2_xattr_get need ocfs2_inode_lock to get dinode buffer head, but on 
hard readonly mount, they did not get they expected, so lead to oops. 
ocfs2_init_security_and_acl and ocfs2_test_inode_bit also called 
ocfs2_inode_lock(inode, &bh, 0), but they are safe, because  
ocfs2_reflink and ocfs2_get_dentry  check hard read only before them.

patch 4 fix problem of running ls on hard readonly mount  can't get the 
right result.
Because ocfs2_dentry_lock() return -EROFS. It should return 0.

best regards,
Tiger
