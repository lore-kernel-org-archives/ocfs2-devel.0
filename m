From: ryding <ryan.ding@oracle.com>
Date: Fri, 07 Aug 2015 16:39:06 +0800
Subject: [Ocfs2-devel] fully support O_DIRECT for ocfs2
Message-ID: <55C46EAA.7010104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I want to redesign the direct io code path for ocfs2. Here is some 
analysis and designation. Any suggestion is appreciated.

1. Reason why ocfs2 turn to buffer io.
ocfs2 use cluster inode lock to protect buffer io, although it's acquire 
and release quickly in write_begin and write_end. It will do a check 
point and page flush wait when get a bast. This will make buffer fully 
covered by the lock.
I think that's why direct io can not act like buffer io to allocate 
extent and do append write. Since direct io beyond control of cluster 
inode lock. That is, cluster inode lock can not flush direct io data. 
This will disturb cache coherence.
There is 2 way to resolve it:
* add the user page to page cache, so jbd2 check point can wait that page.
* wait all direct io to return when downconvert inode lock.
The former one will hack a lot of code. The later one is more simple, 
and easy to implement.

2. More things to be considered when doing direct io.

* sparse file support:
we can use __blockdev_direct_IO() to deal with hole inside block. But 
for hole that outside block, we should do it by ourself.

* data consistency:
Means when a crash is happened during write, file system should ensure 
that the file do not have stale data. There are2 methods to ensure data 
consistency:
a) allocate extent with flag UNWRITE before write. After data is written 
to disk, clear UNWRITE flag. This is a 2 phase commit. And these 2 phase 
do not require to be in the same transaction. But file size can not be 
protected by this method.
b) use journal to ensure meta data is committed after data written to 
disk. In ordered journal mode, jbd2 will wait data to be flushed and 
then commit meta data.
Buffer io can use these 2 method together. While direct io can only use 
a), since journal can not monitor direct io pages. So, ext4 invite 
orphan to protect file size when doing direct append.
Unfortunately, ocfs2 direct io can not use a). ocfs2 can not clear 
UNWRITE flag after the io is done. Because ocfs2 needs to acquire 
cluster inode lock to change that flag. And this will cause dead lock 
when the inode lock is downconverting.
So, the data consistency can not be guaranteed in direct io mode. 
Further, we need not to invite ext4 way to add inode to orphan when 
doing direct append.

3. detail design
Use pseudo code to explain:

ocfs2_direct_IO() {
...
     ocfs2_inode_lock()
     increase inode direct_io_count
...
     __blockdev_direct_IO(ocfs2_direct_IO_get_blocks, ocfs2_dio_end_io, 
ocfs2_dio_submit)
...
     ocfs2_inode_unlock()
     fill file hole. add some empty page to bio list
     submit bio list.
...
}

ocfs2_direct_IO_get_blocks() {
...
     create new extent when write to a hole
     increase file size when append.
...
}

ocfs2_dio_submit() {
     add bio to a list. do not actually submit it.
}

ocfs2_dio_end_io(){
...
     decrease inode direct_io_count.
...
}

/* This is the inode lock downconvert callback. */
ocfs2_data_convert_worker() {
...
     wait inode direct_io_count drop to 0.
...
}
