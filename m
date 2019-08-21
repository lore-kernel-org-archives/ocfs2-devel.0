From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 21 Aug 2019 09:29:04 +0800
Subject: [Ocfs2-devel] [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to
 bitops.h for wider use
In-Reply-To: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
References: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
Message-ID: <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Ariel Elior <aelior@marvell.com>, Sudarsana Kalluru <skalluru@marvell.com>, GR-everest-linux-l2@marvell.com, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Colin Ian King <colin.king@canonical.com>



On 19/8/21 00:31, Andy Shevchenko wrote:
> There are users already and will be more of BITS_TO_BYTES() macro.
> Move it to bitops.h for wider use.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
>  fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
>  include/linux/bitops.h                           | 1 +
>  3 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> index 066765fbef06..0a59a09ef82f 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> @@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x *bp, enum cos_mode mode,
>   *    possible, the driver should only write the valid vnics into the internal
>   *    ram according to the appropriate port mode.
>   */
> -#define BITS_TO_BYTES(x) ((x)/8)>
I don't think this is a equivalent replace, or it is in fact
wrong before?

  
>  /* CMNG constants, as derived from system spec calculations */
>  
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index aaf24548b02a..0463dce65bb2 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -688,10 +688,6 @@ struct dlm_begin_reco
>  	__be32 pad2;
>  };
>  
> -
> -#define BITS_PER_BYTE 8
> -#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
> -
For ocfs2 part, it looks good to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

>  struct dlm_query_join_request
>  {
>  	u8 node_idx;
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index cf074bce3eb3..79d80f5ddf7b 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -5,6 +5,7 @@
>  #include <linux/bits.h>
>  
>  #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
> +#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
>  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
>  
>  extern unsigned int __sw_hweight8(unsigned int w);
> 
