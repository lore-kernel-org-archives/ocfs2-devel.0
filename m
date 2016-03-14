From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 14 Mar 2016 20:46:04 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: fix a variable overflow
	problem in dlmdomain.c
In-Reply-To: <56E6B161.1090707@huawei.com>
References: <56E6B161.1090707@huawei.com>
Message-ID: <56E6B28C.9030901@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/3/14 20:41, piaojun wrote:
> In dlm_send_join_cancels(), node is defined with type unsigned int, but
> initialized with -1, this will lead variable overflow. Although this
> won't cause any runtime problem, the code looks a little uncoordinated.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
Thanks, Jun.
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

> ---
>  dlm/dlmdomain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/dlm/dlmdomain.c b/dlm/dlmdomain.c
> index 2ee7fe7..8cbf6e8 100644
> --- a/dlm/dlmdomain.c
> +++ b/dlm/dlmdomain.c
> @@ -1396,7 +1396,7 @@ static int dlm_send_join_cancels(struct dlm_ctxt *dlm,
>  				 unsigned int map_size)
>  {
>  	int status, tmpstat;
> -	unsigned int node;
> +	int node;
> 
>  	if (map_size != (BITS_TO_LONGS(O2NM_MAX_NODES) *
>  			 sizeof(unsigned long))) {
> 
