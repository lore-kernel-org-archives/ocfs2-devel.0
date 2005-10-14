From: Shaya Potter <spotter@cs.columbia.edu>
Date: Fri Oct 14 00:33:34 2005
Subject: [Ocfs2-devel] ocfs2's bmap output
Message-ID: <1129268016.8092.28.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I'm writing a stackable file system and one of it's features is that it
can combine many sparse files into a single view.  On ext2/3 I was using
bmap to give me the information needed, so for instance, if I created a
big sparse file and tacked on some information at the end on ext2/3 I'd
get something like

blade12:~# ~/a.out abc
File: abc Size: 30002 Blocks: 8 Blocksize: 4096
  0          0
  1          0
  2          0
  3          0
  4          0
  5          0
  6          0
  7     833699

where my test program basically calls bmap (or in this case as it's from
userspace, it calls the FIBMAP ioctl) on each block of the file.

however, when I run it on OCFS2, I get.

blade12:/san/lc2# ~/a.out abc
File: abc Size: 30002 Blocks: 8 Blocksize: 4096
  0    5700288
  1    5700289
  2    5700290
  3    5700291
  4    5700292
  5    5700293
  6    5700294
  7    5700295

I'm guessing this is because of its use of extents, and probably means
I've screwed myself in trying to use bmap in this way.  Is that a
correct assumption?  Is there any other interface into OCFS2 to tell if
a block is a "blank" sparse area?

thanks,

shaya
