From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jul  1 20:18:25 2004
Subject: [Ocfs2-devel] [Patch] We resolve the throughput drop problem when
	r eading filesin OCFS2 volume in the patch "ocfs2-truncate-pages-1.patch" aga
	instsvn 1226.
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E04903A2D@pdsmsx403>
References: <37FBBA5F3A361C41AB7CE44558C3448E04903A2D@pdsmsx403>
Message-ID: <20040702011755.GA14805@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Alright, this looks pretty good. It's going to need some more testing, but
that's what the "beta" version number is for :)

I fixed a bug you had where you were skipping the new-file-search we do to
avoid sending messages on inodes which haven't been written to disk yet -- a
bug which I suspect your ilookup stuff worked around :) Unfortunately we
don't have that in 2.4, but I still do ilookup in the 2.6 case because for
this vote request there's no need to hit the disk if we don't already have
an inode.
	--Mark

On Thu, Jul 01, 2004 at 10:39:07AM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	We root caused the problem "The truncate_inode_page call in
> ocfs_file_releasecauses the severethroughput drop of file reading in
> OCFS2", which we put forward in our former mails. And now, we also
> generate a patch to resolve this problem after one week debugging.
> 
> 	This patch is against OCFS2 svn 1226.
> 
> 	The average file reading throughput without our patch is 16
> Mbtye/sec.
> 	The average file reading throughput with our patch is 1600
> Mbtye/sec.
> 	Our patch has 100 times improvement on file reading throughput.
> We will submit the full benchmark data of izone in the other mail soon.
> 
> 	In our patch, we remove ocfs_truncate_pages() and
> ocfs_extent_map_destroy() from routine ocfs_file_open() and
> ocfs_file_release(), which enable file data page reuse between different
> and sequential file access in one node. 
> 
> 	In current OCFS2 design, file data consistency among all nodes
> in the cluster is only ensured if this file is accessed in sequence. Our
> patch keeps the same consistency level by a new vote request
> FLAG_TRUNCATE_PAGES and a new vote action TRUNCATE_PAGES. This request
> is broadcast when a file is asked to be opened for write. Then the
> receivers truncate all in memory pages and extent maps of this file. The
> sender truncates part of the pages and maps only when the file is
> truncated (shortened).
> 
> 	Please refer to the attachment.
> 
> 	The throughput drop problem also occurs when creating, changing
> and deleting directories on OCFS2 volume. But it is not covered in this
> patch. We will work on the other patch to solve this problem.
> 
> 	Any comments are appreciated.
> 	Thank you.
> 
> 
> 
> *********************************************
> Sonic Zhang
> Software Engineer
> Intel China Software Lab
> Tel: (086)021-52574545-1667
> iNet: 752-1667
> *********************************************  


> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
