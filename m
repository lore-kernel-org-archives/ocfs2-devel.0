From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Jun 22 02:51:26 2004
Subject: [Ocfs2-devel] The truncate_inode_page call in ocfs_file_release
	causes the severethroughput drop of file reading in OCFS2.
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E048028DD@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	We have investigated the possible causes of the severe
throughput drop of file reading in OCFS2 that found in the iozone
benchmark. We find the major cause is the inadequate inode page cache
cleaning when open or close the last reference to an inode. 

	In routine ocfs_file_release(), if the caller is the last
reference to this inode, truncate_inode_page is called to invalidate all
page caches of this inode after the reference is closed. And in routine
ocfs_file_open(), the page caches are also cleaned when this inode is
first opened.

	In this case, the file reading operation always read data from
the disk directly, which throughput is only 16M bytes/sec on our
development machine. But, if we try to bypass the call to
truncate_inode_page(), the file reading throughput in one node can reach
1300M bytes/sec, which is about 75% of that of ext3.

	I think it is not a good idea to clean all page caches of an
inode when its last reference is closed. This inode may be reopened very
soon and its cached pages may be accessed again. 

	I guess your intention to call truncate_inode_page() is to avoid
inconsistency of the metadata if a process on the other node changes the
same inode metadata on disk before it is reopened in this node. Am I
right? Do you have more concern?

	I think in this case we have 2 options. One is to clean all
pages of this inode when receive the file change notification (rename,
delete, move, attributes, etc) in the receiver thread. The other is to
only invalidate pages contain the metadata of this inode.

	What's your opinion?

	Thank you.
