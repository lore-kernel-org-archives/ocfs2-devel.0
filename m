From: Joseph Qi <jiangqi903@gmail.com>
Date: Thu, 29 Mar 2018 09:33:18 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/o2hb: check len for
 bio_add_page() to avoid getting incorrect bio
In-Reply-To: <5ABC3EBE.5020807@huawei.com>
References: <5ABC3EBE.5020807@huawei.com>
Message-ID: <8a6155f9-9f50-9c48-74f9-9d586b7b8fb2@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 18/3/29 09:17, piaojun wrote:
> We need check len for bio_add_page() to make sure the bio has been set up
> correctly, otherwise we may submit incorrect data to device.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Reviewed-by: Changwei Ge <ge.changwei@h3c.com>

Acked-by: Joseph Qi <jiangqi903@gmail.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index ea8c551..91a8889 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -570,7 +570,16 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
>  		     current_page, vec_len, vec_start);
> 
>  		len = bio_add_page(bio, page, vec_len, vec_start);
> -		if (len != vec_len) break;
> +		if (len != vec_len) {
> +			mlog(ML_ERROR, "Adding page[%d] to bio failed, "
> +			     "page %p, len %d, vec_len %u, vec_start %u, "
> +			     "bi_sector %llu\n", current_page, page, len,
> +			     vec_len, vec_start,
> +			     (unsigned long long)bio->bi_iter.bi_sector);
> +			bio_put(bio);
> +			bio = ERR_PTR(-EIO);
> +			return bio;
> +		}
> 
>  		cs += vec_len / (PAGE_SIZE/spp);
>  		vec_start = 0;
> 
