From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu Apr 22 02:59:15 2004
Subject: [Ocfs2-devel] 
	About 2.6 porting bug 58 "system halt when unmount a volume
	immediately after read/write"
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E78@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	We find this bug since svn version 847, in which a patch against
kernel 2.4 is merged in. 

	This 2.6 porting bug occurs only when unmount a volume
immediately after read/write and before the journal_commit_cache() is
called in journal_commit_thread. 

	Kernel reports:
	VFS: Busy inodes after unmount. Self-destruct in 5 seconds. Have
a nice day...

	It has nothing to do with remod.

	Any suggestion?


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
