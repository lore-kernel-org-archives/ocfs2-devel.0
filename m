From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:09:52 2007
Subject: [Ocfs2-devel] [PATCH 00/15] ocfs2: Support for inline-data
Message-ID: <20070919200948.GK21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patches give ocfs2 the ability to put inode data inside free
space in an inode block. This makes sense since ocfs2 inodes are so large
(between 512 bytes and 4k). Aside from space considerations, this should
provide a speedup on workloads which read lots of small files and
directories. I hope to have some benchmark data soon.

A design document describing this feature in detail can be found at:

http://oss.oracle.com/osswiki/OCFS2/DesignDocs/DataInInode

The patches are split up into several sections. The 1st 10 patches simply
clean up some Ocfs2 code, especially in the area of directory manipulation.
Doing this up front helped to keep the inline-data patches cleaner and more
obvious.

The inline-data patches comprise the final five patches of the series and
are split up into seperate read and write support patches for files
and directories.

Alternatively, this series is also available via git in the 'inline-data'
branch of ocfs2.git.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
