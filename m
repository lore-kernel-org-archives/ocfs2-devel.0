From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 18 Nov 2010 13:40:25 +0800
Subject: [Ocfs2-devel] ocfs2: char is not always signed
In-Reply-To: <1290054011_17741@mail4.comsite.net>
References: <1290054011_17741@mail4.comsite.net>
Message-ID: <4CE4BC49.10105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Milton Miller <miltonm@bga.com>
Cc: Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.de>



2010-11-18 12:20, Milton Miller wrote:
> Commit 1c66b360fe262 (Change some lock status member in ocfs2_lock_res
> to char.)  states that these fields need to be signed due to comparision
> to -1, but only changed the type from unsigned char to char.   However, it
> is a compiler option if char is a signed or unsigned type.  Change these
> fields to signed char so the code will work with all compilers.
>
> Signed-off-by: Milton Miller<miltonm@bga.com>
oh, sorry I don't know this. Thanks.
Acked-by: Tao Ma <tao.ma@oracle.com>
> ---
> I did not look for other fields that might be char.  PowerPC compilers
> default to unsigned char, and aparently arm does as well from a quick
> google search, to name two examples.
>
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 1efea36..70dd3b1 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -159,9 +159,9 @@ struct ocfs2_lock_res {
>   	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
>   	unsigned int             l_ro_holders;
>   	unsigned int             l_ex_holders;
> -	char			 l_level;
> -	char			 l_requested;
> -	char			 l_blocking;
> +	signed char		 l_level;
> +	signed char		 l_requested;
> +	signed char		 l_blocking;
>
>   	/* Data packed - type enum ocfs2_lock_type */
>   	unsigned char            l_type;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
