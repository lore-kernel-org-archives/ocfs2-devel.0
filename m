From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 07 Aug 2008 14:23:48 +0800
Subject: [Ocfs2-devel] [PATCH 0/15] ocfs2: Add extended attributes
	for	ocfs2.	V3
Message-ID: <489A94F4.90903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	Extended attributes are used for storing POSIX ACLs, SELinux labels, 
and user accessible metadata. They are essential for deploying file 
systems exported for workgroup use via samba. The following patches
implement extended attributes on the OCFS2 file system. This patch set 
implement extended attributes support for ocfs2.

Modification from V2 to V3:
1. Add ea support for symlink file, add xattr_sem, add ip_alloc_sem 
protect xattr and file data.
2. Remove all kmalloc+kmemcpy issue in set/list/get large numbers of EAs 
, so the efficiency should be improved a lot.
3. Add a thin layer for ocfs2_insert_extent.
4. Limit xattr entry to be only in 1st block of the bucket and limit 
xattr name/value pair within the same block.
5. Limit the xattr tree leaf size to be 64K.

Wish you enjoy it.

Regards,
Tiger and Tao
