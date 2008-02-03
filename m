From: wengang wang <wen.gang.wang@oracle.com>
Date: Sun Feb  3 19:04:00 2008
Subject: [Ocfs2-devel] [patch 1/1] offline de-fragmentation tool
Message-ID: <47A67D89.2030403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I wrote a user space tool to de-fragmentate global bitmap, hope this 
tool is helpful.

for the case of storing non-DB data on ocfs2,  there are not several 
very large file, but lots of relative small files.
after a long time of using, --especially creating and deleting, the 
global bitmap is split into fragments. so that even there is enough free 
space(but not contiguous), creating a file may fail.

there is a relative bug 6730723(on bugdb) though closed with "not 
supported". and I have made a scenario that "df" show the partition 
usage 51%, but on other nodes creating a file fails with "no space" error.

this offline tool, o2defrag, can make larger contiguous free bits on 
global bitmap by moving data clusters of regular file and directories.
it does:
1)  for each group, move data clusters on the group to the front of the 
same group to make bigger free space at the end.
2)  for groups that has more free space, move data clusters to other 
group(s) to make much more free space.
     a)   firstly, it try to move data clusters to the group on which 
there are data clusters of the same file. if no such group or no space 
on these groups, goto b).
     b)   move data clusters to a group on which there is no data 
clusters of the same file.
3) does step 1) again.

stuff changed by this tool is
I)   moving of data clusters.
II)  moving of corresponding bits in global bitmap.
III) extent record in ocfs2_dinode block or extension block

this tool doesn't merge or split extent records for now. and it's nearly 
help nothing to fs performance.
the feature to be added is trying to move all data clusters of a file 
together as possible. so that accessing to file on ocfs2 can get better 
performance.

the patch is based on ocfs2-tool 1.2.6.  for compiling, needs to add a 
symbolic link named "include" in o2defrag directory of 
../debugfs.ocfs2/include.
usage is  "o2defrag <ocfs2 partition>"


thanks,
wengang.

-------------- next part --------------
A non-text attachment was scrubbed...
Name: o2defrag.patch
Type: text/x-patch
Size: 54374 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080204/48954ff1/o2defrag-0001.bin
