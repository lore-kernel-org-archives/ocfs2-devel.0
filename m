From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Aug  6 01:05:58 2004
Subject: [Ocfs2-devel] bug scribe for ocfs2
Message-ID: <3ACA40606221794F80A5670F0AF15F840516778E@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we have a bug scribe for the ocfs2 bugzilla, many bugs are already fixed
or invalid, now there are 17 bugs left unresolve.
some may need re-test on certain environment, some we are unsure.
see below:
========================================================================
===============
43 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=43>
2004-03-10 	nor 	P2 	PC 	mark.fasheh@oracle.com
mark.fasheh@oracle.com 	NEW 		Falling back to disk voting from
net voting can cause a d... 	
53 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=53>
2004-04-05 	nor 	P2 	PC 	sonic.zhang@intel.com
sonic.zhang@intel.com 	NEW 		Disk usage status reported in
"df" is incorrect. 	
55 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=55>
2004-04-13 	nor 	P2 	PC 	kurt.hackel@oracle.com
rusty.lynch@intel.com 	NEW 		Ungracefull handling of mounting
with a bad journal file 	
71 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=71>
2004-05-12 	maj 	P2 	Oth 	kurt.hackel@oracle.com
matt.sheridan@mckesson.com 	NEW 		[2.4] hash.c "Inum is
bound to a different inode" causes ... 	
75 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=75>
2004-05-21 	nor 	P2 	PC 	kurt.hackel@oracle.com
xiaofeng.ling@intel.com 	NEW 		[svn 930] unload module
error with 2.6.6 SMP-preempt kernel 	
84 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=84>
2004-06-03 	nor 	P2 	PC 	kurt.hackel@oracle.com
yukun.chen@intel.com 	NEW 		A defect of latest code [svn
994] on kernel 2.4.22 	
89 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=89>
2004-06-11 	nor 	P2 	PC 	kurt.hackel@oracle.com
Marcos.Matsunaga@oracle.com 	NEW 		ia64 RHAS21:SVN 1047
Crash when trying to create a database. 	
90 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=90>
2004-06-11 	nor 	P2 	PC 	kurt.hackel@oracle.com
Marcos.Matsunaga@oracle.com 	NEW 		ia32 RHAS21:SVN 1047 -
System crashes without any activit... 	
91 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=91>
2004-06-11 	nor 	P2 	PC 	kurt.hackel@oracle.com
Marcos.Matsunaga@oracle.com 	NEW 		ia32 - SLES8/SP3 - SVN
1047 - OCFSV2 BUILD BUT FAIL TO I... 	
98 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=98>
2004-06-22 	nor 	P2 	PC 	kurt.hackel@oracle.com
Marcos.Matsunaga@oracle.com 	REOP 		ia64 - RHEL3 - SVN 1157
- undefined symbol when loading o... 	
99 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=99>
2004-06-22 	nor 	P2 	PC 	kurt.hackel@oracle.com
Marcos.Matsunaga@oracle.com 	NEW 		SVN 1157 - built rpms
don't install properly. Missing sym... 	
101 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=101>
2004-07-01 	nor 	P2 	PC 	kurt.hackel@oracle.com
Marcos.Matsunaga@oracle.com 	NEW 		ia32 - SVN 1226 - RHEL3
- Mount ocfs2 oops. 	
110 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=110>
2004-07-30 	nor 	P2 	PC 	kurt.hackel@oracle.com
yukun.chen@intel.com 	NEW 		fail to write to a file in a way
of direct io(kernel 2.4.24) 	
111 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=111>
2004-07-30 	nor 	P2 	PC 	kurt.hackel@oracle.com
yukun.chen@intel.com 	NEW 		[kernel 2.4.x] System hang issue
when access the same dir... 	
114 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=114>  	Tue
18:30 	nor 	P2 	PC 	kurt.hackel@oracle.com
xiaofeng.ling@intel.com 	REOP 		Error show when mv a
directory to an exist directory 	
115 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=115>  	19:57:30
nor 	P2 	PC 	kurt.hackel@oracle.com 	xiaofeng.ling@intel.com
NEW 		[2.6.6 svn 1303] error message when create and remove
dir... 	
116 <http://oss.oracle.com/bugzilla/show_bug.cgi?id=116>  	01:00:15
maj 	P2 	PC 	kurt.hackel@oracle.com 	xiaofeng.ling@intel.com
NEW 		umount cause crash after some operation 	
17 bugs found. 




-------------------
Intel China Software Lab.
iNet: 8-752-1243
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
