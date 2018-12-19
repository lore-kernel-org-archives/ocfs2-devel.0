From: Gang He <ghe@suse.com>
Date: Tue, 18 Dec 2018 22:47:14 -0700
Subject: [Ocfs2-devel] About ocfs2 inode/extent meta file allocation problem
Message-ID: <5C19DB62020000F90004970B@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys,

When you read ocfs2 kernel code, you can find that ocfs2 uses inode_alloc:N / extent_alloc:N meta files to manage inode block/extent block allocation.
The meta file per node will be increased via getting some blocks from global_bitmap meta file when the user create new files(inodes).
But the meta files ( inode_alloc:N or extent_alloc:N) will not shrink back when these inode/extent blocks are deleted (e.g. these files are removed by the user).
Then, if the user creates lots of files until the file system is full, next, the user deletes all the files.
At this moment, the inode_alloc:N file is very big and occupy the whole file system, since this meta file can not shrink back.
The user can not create a file with some data clusters, since the global_bitmap meta file has not more available cluster bits. 
I did not do this testing in my machine, but from the code logic, I feel my idea should be true.
Do you have any ideas for this problem? 
My suggestion is, 
we should return some blocks to global_bitmap meta file from inode_alloc:N / extent_alloc:N meta files when there are enough free blocks.

Thanks
Gang      
