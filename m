From: Chen, Yukun <yukun.chen@intel.com>
Date: Wed Aug 11 04:43:19 2004
Subject: [Ocfs2-devel] data inconsistency when write in a memory map way
Message-ID: <B44D37711ED29844BEA67908EAF36F038AD04A@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all

for beta 4 release, on kernel 2.4.x

steps to duplicate:

1.on node a, write to a file residing on a ocfs2 partition in a way of
memory 

map

2.then on node b , check the writtent data but nothing will be found.

It is ok if I use a normal way to write file and check on another node.

Any ideas on it.

BTW, the issue has been reported as bug#124 to oss.oracle.com

Thanx.


Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com
