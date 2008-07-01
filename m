From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon, 30 Jun 2008 20:24:15 -0700
Subject: [Ocfs2-devel] [BUGFIX][OCFS2 1/1] inode truncating
In-Reply-To: <48689FEF.6040504@oracle.com>
References: <48689FEF.6040504@oracle.com>
Message-ID: <4869A35F.9080502@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang,

I needed some clarification. Is the fix proposed in kernel or in ocfs2,
or in kernel and in ocfs2?

Is the bug in 1.2/el4 only? Has 1.2/el5 or current mainline tested?
Just want to know what has been tested.

Also, please could you a file a bugzilla with the details. Especially
the testcase. Will be useful as we will be able to test it in
multiple envs.

Thanks
Sunil

wengang wang wrote:
> /an ocfs2 bug:
> a truncate races with ocfs2_get_block(...,0).
>
> 1) 'dd' is doing a truncate, clearing the page cache and reset inode 
> size./
> /2) between clearing page cache and resizing inode, a read comes and 
> create a /
> /new page and insert it to page cache./
> /3) the read(from `cat`) set buffer head in the new page as mapped but 
> doesn't increase /   /ip_mmu_private in ocfs2_get_block() because it's 
> a read./
> /4) a write from 'dd' matches the page that the read created. because 
> the buffer /
>  /heads are already mapped, it doesn't call ocfs2_get_block. the 
> ip_mmu_private /
>  /keeps unchanged since last write./
> /5) in cont_prepare_write() it dead loops since bytes(ip_mmu_private) 
> is not /
>  /increased in last prepare write./
>
> BUG is described in 
> s://bug.oraclecorp.com/pls/bug/webbug_print.show?c_rptno=7183894.
>
> solution:
> /1) moves the clearing of page cache truncate_inode_pages() from 
> ocfs2_truncate_file() to/
>  /ocfs2_set_inode_size() after resizing inode size and i_blocks./
> /2) in ocfs2_get_block(), add checks on iblock >= inode->i_blocks. if 
> true, return -EIO.
> 3) //a kernel bug fix is needed for 2.6.9 kernel.
> //see https://bugzilla.redhat.com/show_bug.cgi?id=453359/
>
> aops.c |    6 ++++++
> file.c |    4 ++--
> 2 files changed, 8 insertions(+), 2 deletions(-)
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
