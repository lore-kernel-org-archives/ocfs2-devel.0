From: Chen, Yukun <yukun.chen@intel.com>
Date: Fri Aug  6 04:41:35 2004
Subject: [Ocfs2-devel] Cannot see files created on another node
Message-ID: <B44D37711ED29844BEA67908EAF36F03806DBF@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

I met the bug on kernel 2.4.x, svn 1313

Steps to duplicate:

1. create 1000 files in node1

2. in the same time, create another 1000 files at the same point in
node2

Then, I can see 2000 files in node2 but only 1000 files in node1

(I have submitted a bug#117 to oss.oracle.com bugzillia)

Thanx.

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com
