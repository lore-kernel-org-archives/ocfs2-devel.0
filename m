From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 4 Nov 2010 14:24:36 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <4CD26A8A.6080307@oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
	<20101104011839.GA14640@mail.oracle.com>
	<4CD219F5.8020006@oracle.com>
	<20101104062836.GB22663@mail.oracle.com>
	<4CD26A8A.6080307@oracle.com>
Message-ID: <20101104212436.GE22663@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 04, 2010 at 04:10:50PM +0800, tristan wrote:
>     Yep, you're correct, other than the operation we read inode block, 
> the lookup
> of blkno/inode should also be treated differently according to coherency 
> flag, I
> guess following logic could help:
> 
> if (cluster_coherent) {
>     alloc_inode = ocfs2_get_system_file_inode();
>     ocfs2_inode_lock(alloc_inode, &bh);
> } else {
>     ocfs2_lookup_ino_from_name("global_bitmap", &blkno);
>     ocfs2_read_blocks(blkno, 1, &bh);
> }
> ...
> 
> Above logic guarantee the performance for none-coherency case.

	You got it.  But don't hardcode file names.  Use the sprintf
function for type+slot as in the top of _ocfs2_get_system_file_inode().
or write a lookup_ino_by_type.  Or something like that.

Joel

-- 

Life's Little Instruction Book #80

	"Slow dance"

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
