From: Christoph Hellwig <hch@lst.de>
Date: Tue May 17 16:16:13 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] jlbec commits r2262 -
	branches/alloc_inode/fs/ocfs2
In-Reply-To: <200505172112.j4HLCq0p022101@oss.oracle.com>
References: <200505172112.j4HLCq0p022101@oss.oracle.com>
Message-ID: <20050517211616.GA13743@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 17, 2005 at 04:12:52PM -0500, svn-commits@oss.oracle.com wrote:
> Author: jlbec
> Date: 2005-05-17 16:12:51 -0500 (Tue, 17 May 2005)
> New Revision: 2262
> 
> Modified:
>    branches/alloc_inode/fs/ocfs2/aops.c
>    branches/alloc_inode/fs/ocfs2/file.c
>    branches/alloc_inode/fs/ocfs2/inode.c
>    branches/alloc_inode/fs/ocfs2/ocfs.h
> Log:
> 
> o Move ip_mmu_private to ocfs2_inode_info.

Btw, for many functions it would be a lot cleaner to have a local

struct ocfs2_inode_info *oi = OCFS2_I(inode);

at the beginning and the just use oi->foo.
