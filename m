From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed Aug 11 23:16:30 2004
Subject: [Ocfs2-devel] How can I test the function
	ocfs_allocate_new_data_node?
In-Reply-To: <B44D37711ED29844BEA67908EAF36F038AD525@pdsmsx401.ccr.corp.intel.com>
References: <B44D37711ED29844BEA67908EAF36F038AD525@pdsmsx401.ccr.corp.intel.com>
Message-ID: <20040812041439.GA21480@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

A much better way to approach this would be with just two files "file1" 
and "file2".  Just extend both file1 and file2 in parallel in small chunks.
This should guarantee that each time a file is extended, the allocation
will be discontiguous with the previous extent.  Try something like this:
  dd if=/dev/zero of=file1 bs=1024 count=100000 &
  dd if=/dev/zero of=file2 bs=1024 count=100000 &
then check both files with debugfs.ocfs2 and you should see a tree of
extents has been created.

Thanks!
-kurt

On Thu, Aug 12, 2004 at 11:34:28AM +0800, Chen, Yukun wrote:
> Hi All
> 
> 	Now I want to improve the code coverage of my test case for
> ocfs2 but failed to call ocfs_allocate_new_data_node whenever I try. My
> approach is as follows:
> 
> 	1.create 1000 files , each with a size 4k
> 
>  	2.then grow the first file to 2G
> 
> 	Judging from the ocfs2 source code,  the function will be called
> only when  we need to add a branch of extent. From my approach, there
> will be many 
> 
> discontinuous  blocks be allocated for each files after 1000 small files
> are created. Then, I grow the first file up to 2G size by doing holes.
> So, a branch of  extend will be 
> 
> added to hold such big files but why the function is not called? 
> 
> 	Is any mistake in my approach? Pls point it out freely  if there
> is some and give me some suggestions on how to test this function.
> 
> 	Thanx a log.
> 
> bst.,rgds
> 
> Aaron
> 
> Intel China Software Lab
> 
> Tel:  8621-52574545 Ext.1587
> 
> E_mail:yukun.chen@intel.com
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
