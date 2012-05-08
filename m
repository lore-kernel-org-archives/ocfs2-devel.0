From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 7 May 2012 17:28:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: new structure to implment
 discontiguous local alloc bitmap
In-Reply-To: <1336432890-18638-2-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
	<1336432890-18638-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20120508002820.GE4713@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 07, 2012 at 04:21:28PM -0700, Srinivas Eeda wrote:
> Current local alloc handles single contiguous free chunk of clusters. This
> patch enhances local alloc to handle discontigous free chunks. It adds a new
> ocfs2_local_alloc_rec structure which tracks single contiguous free chunk. An
> array of these sit in the bitmap itself and track discontiguous chunks. In
> best case there is only one record and increases as the filesystem gets
> fragmented. Number of records at a time are limited depending on the size
> of the bitmap and the max limit is defined by OCFS2_MAX_LOCAL_ALLOC_RECS.
> 
> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> ---
>  fs/ocfs2/localalloc.c |   10 ++++++++++
>  fs/ocfs2/ocfs2.h      |    8 ++++++++
>  fs/ocfs2/ocfs2_fs.h   |   48 ++++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 210c352..4190e53 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -48,6 +48,16 @@
>  
>  #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
>  
> +#define OCFS2_LOCAL_ALLOC_REC_SZ(la)	(le16_to_cpu(la->la_rec_count) *\
> +					 sizeof(struct ocfs2_local_alloc_rec))
> +#define OCFS2_LOCAL_ALLOC_BITMAP(la)    ((char *)(&(la->la_recs)) +\
> +					 OCFS2_LOCAL_ALLOC_REC_SZ(la))

	Another point.  Not only does this macro not handle
!DISCONTIG_LA filesystems (as described in my other email about this
patch), it should be a static inline function.  See eg: INODE_CACHE() in
fs/ocfs2/inode.h

Joel

-- 

Life's Little Instruction Book #456

	"Send your loved one flowers.  Think of a reason later."

			http://www.jlbec.org/
			jlbec at evilplan.org
