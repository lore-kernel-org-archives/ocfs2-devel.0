From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Apr 27 03:47:58 2004
Subject: [Ocfs2-devel] 
	system halt when create a directory in ocfs2 volume (svn 866 kernel
	2.6)
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E86@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	When create a directory, system halts with error information.
This bug is found since svn 866 in kernel 2.6. Because we fail to mount
an ocfs volume under kernel 2.4 with this version of driver, we can't
make sure if it is kernel independent. 

Steps:
1. load ocfs2
2. mount /ocfs
3. create a directory

Results:
System halt.

...
000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 
000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 
000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 
000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 000 

uH oh! invalid type being written to dirnode!
signature: 'fooblydoo flippity floppety floo. sup...
-------------------[ cut here ]-------------------
kernel BUG at ocfs2/src/inc/io.h:342!
invalid operand: 0000 [#1]





*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
