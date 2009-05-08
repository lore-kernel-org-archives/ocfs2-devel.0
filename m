From: Coly Li <coly.li@suse.de>
Date: Fri, 08 May 2009 15:28:35 +0800
Subject: [Ocfs2-devel] question of dentry number
Message-ID: <4A03DF23.8090903@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I observer interesting dentry number during the dlm stress testing. The ocfs2
cluster stack is user space "pcmk".

creating a empty directory, ls -al:
total 8
drwxr-xr-x 2 root root 4096 2009-05-08 15:29 .
drwxr-xr-x 4 root root 4096 2009-05-08 15:29 ..


run script make_panic on single node, for 10 seconds, ls -al:
total 12
drwxr-xr-x 2 root root      4096 2009-05-08 15:33 .
drwxr-xr-x 4 root root      4096 2009-05-08 15:29 ..
-rw-r--r-- 1 root root         0 2009-05-08 15:33 file0000000001
-rw-r--r-- 1 root root 459611068 2009-05-08 15:33 file0000000003

then run this script on ocfs2 volume of both nodes for 10 seconds, ls -al:
total 32
drwxr-xr-x 2 root root      4096 2009-05-08 15:34 .
drwxr-xr-x 4 root root      4096 2009-05-08 15:29 ..
-rw-r--r-- 1 root root 939787135 2009-05-08 15:34 file0000000000
-rw-r--r-- 1 root root 922127231 2009-05-08 15:34 file0000000001
-rw-r--r-- 1 root root         0 2009-05-08 15:34 file0000000002
-rw-r--r-- 1 root root 503703844 2009-05-08 15:34 file0000000003

I don't understand how there are 32 dentries in the directory. Can anybody tell
me the magic ? Or it's a bug.

Thanks.
-- 
Coly Li
SuSE Labs
