From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 14 Nov 2008 11:11:09 +0800
Subject: [Ocfs2-devel] [PATCH 00/15] ocfs2: add security EA and ACL support
	V5
Message-ID: <491CEC4D.1090306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, all

This the 5th version for add security EA and acl support in ocfs2.
In this round I fixed many problem as Mark commented.
Them based on Mark's merge_window branch.

The top 4 patches are for security EA.
1. move new inode allocation from transaction
This patch actually is from Jan's patch
http://oss.oracle.com/pipermail/ocfs2-devel/2008-October/003266.html
2. ocfs2_xattr_set_handle
I remove the extend_trans from this function as we have reserve credits 
with start trans.
3. add security xattr API
4. add ocfs2_init_security in mknod
calculate credits for security xattr before start trans.
add setting security attribute on symlinks.

The next 6 patches are for acl.
5. add ocfs2_xattr_get_nolock
6. add posix acl api
combine ocfs2_acl_set_handle and ocfs2_acl_set into one function.
7. add ocfs2_check_acl
8. add ocfs2_acl_chmod
move acl_chmod out of the transaction in ocfs2_setattr.
9. add ocfs2_init_acl in mknod
calculate credits for acl xattrs before start trans.
10. add mount and Kconfig options for acl
