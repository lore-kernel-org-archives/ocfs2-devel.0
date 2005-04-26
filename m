From: Christoph Hellwig <hch@lst.de>
Date: Tue Apr 26 02:18:26 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r2175 - in
	trunk/fs/ocfs2: . cluster dlm
In-Reply-To: <200504260323.j3Q3NC9V013089@oss.oracle.com>
References: <200504260323.j3Q3NC9V013089@oss.oracle.com>
Message-ID: <20050426071825.GA17901@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Apr 25, 2005 at 10:23:12PM -0500, svn-commits@oss.oracle.com wrote:
> Author: manish
> Signed-off-by: mfasheh
> Date: 2005-04-25 22:23:11 -0500 (Mon, 25 Apr 2005)
> New Revision: 2175
> 
> Modified:
>    trunk/fs/ocfs2/alloc.c
>    trunk/fs/ocfs2/aops.c
>    trunk/fs/ocfs2/buffer_head_io.c
>    trunk/fs/ocfs2/cluster/masklog.h
>    trunk/fs/ocfs2/dcache.c
>    trunk/fs/ocfs2/dir.c
>    trunk/fs/ocfs2/dlm/dlmast.c
>    trunk/fs/ocfs2/dlm/dlmconvert.c
>    trunk/fs/ocfs2/dlm/dlmdebug.c
>    trunk/fs/ocfs2/dlm/dlmrecovery.c
>    trunk/fs/ocfs2/dlm/dlmunlock.c
>    trunk/fs/ocfs2/dlmglue.c
>    trunk/fs/ocfs2/file.c
>    trunk/fs/ocfs2/inode.c
>    trunk/fs/ocfs2/journal.c
>    trunk/fs/ocfs2/localalloc.c
>    trunk/fs/ocfs2/mmap.c
>    trunk/fs/ocfs2/namei.c
>    trunk/fs/ocfs2/ocfs.h
>    trunk/fs/ocfs2/proc.c
>    trunk/fs/ocfs2/suballoc.c
>    trunk/fs/ocfs2/super.c
>    trunk/fs/ocfs2/vote.c
> Log:
> Define MLFu64 and friends, for portable format strings for sized 64-bit types.
> This gets rid of the tons on warnings on ia64 and ppc64.

Standard kernel practice is to cast a u64 to unsigned long (and a s64 to
long), and not using such obsfucation.  I'd strongly suggest to follow
that lead in ocfs.
