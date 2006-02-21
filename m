From: Christoph Hellwig <hch@lst.de>
Date: Tue, 21 Feb 2006 19:37:41 +0100
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: fix -Wformat warnings when
	building UML on x86-64
In-Reply-To: <20060221165730.GA11821@locomotive.unixthugs.org>
References: <20060221165730.GA11821@locomotive.unixthugs.org>
Message-ID: <20060221183740.GA3068@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 21, 2006 at 11:57:30AM -0500, Jeff Mahoney wrote:
> 
>  The check to determine which format string is appopriate for u64 and
>  friends works in most cases, but UML on x86_64 doesn't define CONFIG_X86_64,
>  so it results in screen fulls of compile-time warnings.
> 
>  This patch fixes it to handle that case.
> 
>  fs/ocfs2/cluster/masklog.h |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> diff -ruNpX ../dontdiff linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/masklog.h linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/masklog.h
> --- linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/masklog.h	2006-02-21 11:41:25.000000000 -0500
> +++ linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/masklog.h	2006-02-21 11:44:25.000000000 -0500
> @@ -255,7 +255,7 @@ extern struct mlog_bits mlog_and_bits, m
>  	}								\
>  } while (0)
>  
> -#if (BITS_PER_LONG == 32) || defined(CONFIG_X86_64)
> +#if (BITS_PER_LONG == 32) || defined(CONFIG_X86_64) || (defined(CONFIG_UML_X86) && defined(CONFIG_64BIT))
>  #define MLFi64 "lld"
>  #define MLFu64 "llu"
>  #define MLFx64 "llx"

Please just rip out this crap instead and use the normal
(long long) or (unsigned long long) casts used everywhere else in the
kernel.
