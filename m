From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Apr 15 05:03:48 2004
Subject: [Ocfs2-devel] OCFS basic test 
Message-ID: <3ACA40606221794F80A5670F0AF15F8404041C8F@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi
      Attach is some basic test cases for ocfs2, inluding module load,
remove, mount,remount,umount, read/write, mmap, dir create/remove.
It can be used for regression test.
Currently result on my machine:
on 2.4.20 kernel, rmdir will hang, others are all pass.
on 2.6.3, mmap and remount will oops.

To run the test, just untar and type "make test"
You can also run seprate test cases by
./setuptest.sh
./remount.sh
./basicrw.sh
./basicdir.sh
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfsbasictest.tgz
Type: application/x-compressed
Size: 3566 bytes
Desc: ocfsbasictest.tgz
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040415/10430138/ocfsbasictest.bin
