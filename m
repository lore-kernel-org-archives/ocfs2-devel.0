From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Jan  2 15:10:54 2008
Subject: [Ocfs2-devel] Re: [PATCH 06/30] ocfs2: Include
	do_sync_mapping_range() from mainline
In-Reply-To: <1199139862-31452-5-git-send-email-sunil.mushran@oracle.com>
References: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
	<1199139862-31452-5-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080102231003.GC8779@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 31, 2007 at 02:23:58PM -0800, Sunil Mushran wrote:
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 4791433..fc7ee22 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -23,11 +23,13 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> +#ifndef NO_SYNC_MAPPING_RANGE
>  #include <linux/fs.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
>  #include <linux/swap.h>
> +#endif

	Why are you adding these #ifdefs?  The headers can be included
twice safely, they prevent re-inclusion - or at least they should.

Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
