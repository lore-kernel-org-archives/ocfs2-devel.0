From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 30 Oct 2008 19:31:31 +0800
Subject: [Ocfs2-devel] [PATCH 00/15] ocfs2: add security EA and ACL support
	V4
Message-ID: <49099B13.9030802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hi,
This is the version 4 patches for add security EA and ACL support in 
ocfs2. We have fixed many problems in version 3 and I split the previous 
big patch into some small patches. Them based on joel's xattr_buckets 
branch.

The first five patches from Tao Ma.
1: only extend xattr bucket in need
2: add cluster free in dealloc ctxt
3: move clusters free into dealloc
4: reserve meta data at the begining of ocfs2_xattr_set
5: merge xattr set transactions

The next four patches add security EA support in ocfs2.
6: move new_inode out of transaction
7: add ocfs2_xattr_set_handle
8: add security xattr API
9: add ocfs2_init_security in mknod

The final six patches add ACL support in ocfs2.
10: add xattr_get_nolock
11: add posix acl API
12: add ocfs2_check_acl
13: add ocfs2_acl_chmod
14: add mount and Kconfig option for acl

Best regards,
tiger
