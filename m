From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu May  6 16:25:45 2004
Subject: [Ocfs2-devel] upcoming changes
Message-ID: <20040506212542.GD1343@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Anyone tracking svn for the last week or so has probably noticed the large
number of changes happening to the code base.   

We're making some disk format changes, so people tracking ocfs2 will also
have to closely track ocfs-tools trunk. Also, be prepared to have to
reformat your file systems :)

As far as what we're actually doing -- we're (finally!) fixing the
directory layout issues we've been living with for a while. Directories are
going to be alot closer to an ext2/3 style layout where names and offsets
will be allocated in the directory extent pointers much like regular file
data. This allows us to make namespace changes (mknod, delete, rename) in
the directory metadata without having to read the actual file entries off
disk. Further, it should greatly reduce the amount of I/O required to do a
simple readdir style operation. Most importantly, we won't have to lock out
inode blocks for namespace operations any more, and this will open the door
towards dumping the bh hash and using more traditional methods of locking
blocks under change.
        --Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
