From: Younger Liu <younger.liu@huawei.com>
Date: Sat, 27 Jul 2013 18:27:29 +0800
Subject: [Ocfs2-devel] Why ocfs2 haven't implemented "steal" for local_alloc
	system files?
Message-ID: <51F3A091.4090605@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
  While analyzing ocfs2 block allocation, I found:
  When claiming space from inode_alloc (or extent_alloc) system files, 
if there is no enough space in inode_alloc (or extent_alloc) and 
global_bitmap, it could steal space from other slots.
  But when claiming space from local_alloc system files, and no 
enough space in local_alloc and global_bitmap, it returns -ENOSPC.

  Why ocfs2 haven't implemented "steal" for local_alloc system files?
  Is there any some reasons?
