From: Chen, Yukun <yukun.chen@intel.com>
Date: Mon Jun 14 01:17:21 2004
Subject: [Ocfs2-devel] File missing on another node
Message-ID: <B44D37711ED29844BEA67908EAF36F0315E080@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all

   I meet a consistency issue. Steps to duplicate:

 

on Node A

   1.load_ocfs2

   2.mkfs.ocfs2 -b 4 -L ocfs2 -F -m /ocfs /dev/sdc2

   3.mount /dev/sdc2 /ocfs -t ocfs2

   4.create /ocfs/testdir

   5.create 1000 files in /ocfs/testdir

 

in the meanwhile on Node B:

   6.load_ocfs2

   7.mount /dev/sdc2 /ocfs -t ocfs2

   5.create another 1000 files in /ocfs/testdir

 

after all creating finihsed, I can see 2000 files on /ocfs/testdir from
node B but can only see 1002(all the files created in node A and 2 files
created in node B) files from node A 

 

Any ideas for it?

 

Thanx.

 

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com

 

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040614/67bcab8c/attachment.htm
