From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Mar 16 03:45:13 2004
Subject: [Ocfs2-devel] [Bug] mmap fail for ocfs2-1.9.9 in 2.4.20
Message-ID: <3ACA40606221794F80A5670F0AF15F8403975495@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

do the follow steps, on ext2, it is ok. but on ocfs2, it fails, 

 Test Steps:
  1. Create a file, while it is open call unlink().
  2. mmap the file to memory, then call close(). If mmap() add
     extra reference to the file, the file descriptor will not be
removed.
  3. Try to open the file, open should success;
  3. munmap the mapped memory;
  4. Try open the file again, should get ENOENT;
The result is in step 4, the file is still existing.


-------------------
Intel China Software Lab.
iNet: 8-752-1806
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
