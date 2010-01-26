From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 25 Jan 2010 19:19:56 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix memory overflow in cow_by_page.
In-Reply-To: <1264057166-21316-1-git-send-email-tao.ma@oracle.com>
References: <1264057166-21316-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100126031956.GC15982@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 21, 2010 at 02:59:26PM +0800, Tao Ma wrote:
> In ocfs2_duplicate_clusters_by_page, we calculate map_end
> by shifting page_index. But actually in case we meet with
> a large offset(say in a i686 box, poff_t is only 32 bits
> and page_index=2056240), we will overflow. So change it
> by adding PAGE_CACHE_SIZE to offset.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/refcounttree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 74db2be..6db863d 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2945,7 +2945,7 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  
>  	while (offset < end) {
>  		page_index = offset >> PAGE_CACHE_SHIFT;
> -		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
> +		map_end = offset + PAGE_CACHE_SIZE;

	First, we can't be computing by offset, because map_end is
supposed to be page bounded, right?  Also, what if we have an offset
that is the last page possible?  Won't that wrap as well, setting
map_end to 0?
	Why aren't we computing map_end like we compute end, as a loff_t
value?

  		page_index = offset >> PAGE_CACHE_SHIFT;
- 		map_end = (page_index + 1) << PAGE_CACHE_SHIFT;
+ 		map_end = ((loff_t)page_index + 1) << PAGE_CACHE_SHIFT;

  		if (map_end > end)
  			map_end = end;

The map_end>end check will catch anything too big.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
