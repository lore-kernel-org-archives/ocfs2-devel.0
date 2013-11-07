From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 07 Nov 2013 16:02:48 -0600
Subject: [Ocfs2-devel] [patch] ocfs2: remove some impossible checks
In-Reply-To: <20131107074232.GC21844@elgon.mountain>
References: <20131107074232.GC21844@elgon.mountain>
Message-ID: <527C0E08.1000105@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/07/2013 01:42 AM, Dan Carpenter wrote:
> pv_major and pv_minor are unsigned char type so these checks are just
> noise.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks. I will incorporate these changes alongwith Mark Fasheh's review 
comments

>
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 4599de7..eca3f93 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -808,11 +808,7 @@ static int lvb_to_version(char *lvb, struct ocfs2_protocol_version *ver)
>   		&ocfs2_user_plugin.sp_max_proto;
>
>   	memcpy(&pv, lvb, sizeof(struct ocfs2_protocol_version));
> -	if ((pv.pv_major == LONG_MIN) || (pv.pv_major == LONG_MAX) ||
> -	    (pv.pv_major > (u8)-1) || (pv.pv_major < 1))
> -		return -ERANGE;
> -	if ((pv.pv_minor == LONG_MIN) || (pv.pv_minor == LONG_MAX) ||
> -	    (pv.pv_minor > (u8)-1) || (pv.pv_minor < 0))
> +	if (pv.pv_major < 1)
>   		return -ERANGE;
>   	if ((pv.pv_major != max->pv_major) ||
>   	    (pv.pv_minor > max->pv_minor))
>


-- 
Goldwyn
