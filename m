From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 21 Aug 2009 13:58:00 -0700
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <20090821183944.GA4330@mail.oracle.com>
References: <20090821070737.GB20755@mail.oracle.com>
	<1250843065-6381-1-git-send-email-tao.ma@oracle.com>
	<20090821183944.GA4330@mail.oracle.com>
Message-ID: <20090821205800.GC4330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 21, 2009 at 11:39:44AM -0700, Joel Becker wrote:
> On Fri, Aug 21, 2009 at 04:24:25PM +0800, Tao Ma wrote:
> > 	As our talk in irc, here is the updated one. Please review.
> 
> 	Perfect.
> 	Here's a version with the math wrapped in shiny readable
> inlines.  Some comments were updated too.  I didn't actually change the
> logic, so please verify I got it right.
> 
> Joel
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index d59860d..8f0d210 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2499,7 +2499,52 @@ out:
>  	return ret;
>  }
>  
> -#define	MAX_COW_BYTES	1048576
> +#define	MAX_CONTIG_BYTES	1048576
> +
> +static inline unsigned int ocfs2_cow_contig_clusters(struct super_block *sb)
> +{
> +	return ocfs2_clusters_for_bytes(sb, MAX_CONTIG_BYTES);
> +}
> +
> +static inline unsigned int ocfs2_cow_contig_mask(struct super_block *sb)
> +{
> +	return ~(ocfs2_cow_contig_clusters(sb) - 1);
> +}
> +
> +/*
> + * Given an extent that starts at 'start and an I/O that starts at
> + * 'cpos, find an offset (start * (n * contig_clusters)) that is closest

	Erg, "(start + (n * contig_clusters))".

Joel

-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
