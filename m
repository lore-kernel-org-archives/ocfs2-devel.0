From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 23 Apr 2010 14:44:18 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: make
	ocfs2_adjust_resv_from_alloc simple.
In-Reply-To: <1270715582-13702-1-git-send-email-tao.ma@oracle.com>
References: <20100407212423.GP11402@wotan.suse.de>
	<1270715582-13702-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100423214418.GR17187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 08, 2010 at 04:33:02PM +0800, Tao Ma wrote:
> When we allocate some bits from the reservation, we always
> allocate from the r_start(see ocfs2_resmap_resv_bits).
> So there should be no sense for checking between r_start
> and start. And I don't think we will change this behaviour
> somehow later by allocating from some bits after r_start.
> Why not make ocfs2_adjust_resv_from_alloc simple now?
> 
> So the only chance we have to adjust the reservation is that
> we haven't reached the end. With this patch, the function is
> more readable.
> 
> Note:
> btw, this patch also fixes an original bug in the function
> which I haven't found before.
> 	if (end < ocfs2_resv_end(resv))
> 		rhs = end - ocfs2_resv_end(resv);
> This code is of course buggy. ;)
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/reservations.c |   32 ++++++++++++--------------------
>  fs/ocfs2/reservations.h |    3 ++-
>  2 files changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
> index 32bad4a..4065002 100644
> --- a/fs/ocfs2/reservations.c
> +++ b/fs/ocfs2/reservations.c
> @@ -406,7 +406,7 @@ ocfs2_find_resv_lhs(struct ocfs2_reservation_map *resmap, unsigned int goal)
>   * The start value of *rstart is insignificant.
>   *
>   * This function searches the bitmap range starting at search_start
> - * with length csearch_len for a set of contiguous free bits. We try
> + * with length search_len for a set of contiguous free bits. We try
>   * to find up to 'wanted' bits, but can sometimes return less.
>   *
>   * Returns the length of allocation, 0 if no free bits are found.

This isn't related to the ocfs2_adjust_resv_from_alloc(), right?  ;) Good
catch on the comment cleanup though.


Otherwise the patch looks great. Joel, I personally don't care about the extra cleanup
 - this *is* a cleanup patch anyway.

Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
