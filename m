From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Apr 16 02:51:06 2004
Subject: [Ocfs2-devel] A possible bug in kernel 2.6 porting
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E6A@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

When mount an OCFS volume for the first time, the delay before the mount
succeeds is much longer than that under kernel 2.4. Normally, it takes
more than 3 minutes under kernel 2.6, while it is only several seconds
under kernel 2.4.

I think this is a bug in kernel 2.6 porting.



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
