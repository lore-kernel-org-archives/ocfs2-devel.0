From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 8 Jan 2014 18:12:20 -0600
Subject: [Ocfs2-devel] What's the need of OCFS2_INODE_MAYBE_ORPHANED?
Message-ID: <CAJtY7HVQue79bLEUPXnN=fSbvcKS_mA8FUQbmaNE0dipSp1XoA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

From the comments in fs/ocfs2/inode.h:90 it seems, this was used in
legacy ocfs2 systems when a node received unlink votes. Since unlink
votes has been done away with and replaced with open locks, is this
flag still required? If yes, why?

From my ongoing investigation of unlink() times, it seems this flag is
causing the delay with releasing the open locks while downconverting
dentry locks. The flag is set  _everytime_ a dentry downconvert is
performed even if the file  is not scheduled to be deleted. If not, we
can be smartly evict the inodes which are *not* to be deleted
(i_nlink>0) by not offloading to ocfs2_wq. This way open lock will
release faster speeding up unlink on the deleting node.

-- 
Goldwyn
