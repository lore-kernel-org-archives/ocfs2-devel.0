From: Manish Singh <manish.singh@oracle.com>
Date: Tue Jun 22 17:54:34 2004
Subject: [Ocfs2-devel] [PATCH] provide strsep for ancient kernels
In-Reply-To: <20040622122254.GA14879@lst.de>
References: <20040622122254.GA14879@lst.de>
Message-ID: <20040622224759.GA18658@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2004 at 02:22:54PM +0200, Christoph Hellwig wrote:
> Index: src/ocfs_compat.h
> ===================================================================
> --- src/ocfs_compat.h	(revision 1182)
> +++ src/ocfs_compat.h	(working copy)
> @@ -87,6 +87,19 @@
>  	sb->s_blocksize_bits = bits;
>  	return sb->s_blocksize;
>  }
> +
> +static inline char *strsep(char **s, const char *ct)
> +{
> +	char *sbegin = *s, *end;
> +
> +	if (sbegin == NULL)
> +		return NULL;
> +	end = strpbrk(sbegin, ct);
> +	if (end)
> +		*end++ = '\0';
> +	*s = end;
> +	return sbegin;
> +}
>  #endif

strsep actually is in AS 2.1's 2.4.9, so I didn't stick it in the compat
header. This was probably a holdover from years ago, when we were look
at a pretty ancient kernel tree.

-Manish
