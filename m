From: Chen, Yukun <yukun.chen@intel.com>
Date: Wed Aug 11 22:34:40 2004
Subject: [Ocfs2-devel] 
	How can I test the function ocfs_allocate_new_data_node?
Message-ID: <B44D37711ED29844BEA67908EAF36F038AD525@pdsmsx401.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All

	Now I want to improve the code coverage of my test case for
ocfs2 but failed to call ocfs_allocate_new_data_node whenever I try. My
approach is as follows:

	1.create 1000 files , each with a size 4k

 	2.then grow the first file to 2G

	Judging from the ocfs2 source code,  the function will be called
only when  we need to add a branch of extent. From my approach, there
will be many 

discontinuous  blocks be allocated for each files after 1000 small files
are created. Then, I grow the first file up to 2G size by doing holes.
So, a branch of  extend will be 

added to hold such big files but why the function is not called? 

	Is any mistake in my approach? Pls point it out freely  if there
is some and give me some suggestions on how to test this function.

	Thanx a log.

bst.,rgds

Aaron

Intel China Software Lab

Tel:  8621-52574545 Ext.1587

E_mail:yukun.chen@intel.com
