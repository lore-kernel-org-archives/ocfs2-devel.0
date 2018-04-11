From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 11 Apr 2018 02:14:31 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/o2hb: check len for bio_add_page()
 to avoid submitting incorrect bio
References: <5ABB110A.3050808@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F295F8FE@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

Thanks for your patch.

I just applied your patch into my tree and triggered ocfs2-test.
Unfortunately, the very first case fails in making fs since bio can't accommodate more than 16 vecs.

Of course this is not introduced by your patch. You patch just makes this hidden issue visible.

I just want to remind if this patch is applied. The cluster scale can't exceed 16 nodes.

And I will try to post a patch to fix it.

Attach log:

Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329330] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 0, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329331] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 1, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329332] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 2, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329333] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 3, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329334] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 4, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329335] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 5, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329336] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 6, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329337] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 7, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329338] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 8, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329339] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 9, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329339] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 10, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329340] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 11, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329341] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 12, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329342] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 13, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329343] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 14, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329344] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 15, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329345] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 16, vec_len = 4096, vec_start = 0
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329346] (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:471 ERROR: Adding page[16] to bio failed, page ffffea0002d7ed40, len 0, vec_len 4096, vec_start 0, bi_sector 8192
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329357] (mkfs.ocfs2,27479,2):o2hb_read_slots:500 ERROR: status = -5
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329361] (mkfs.ocfs2,27479,2):o2hb_populate_slot_data:1911 ERROR: status = -5
Apr 11 08:37:02 cvknode-ocfs2test-e0501-1 kernel: [  942.329364] (mkfs.ocfs2,27479,2):o2hb_region_dev_write:2012 ERROR: status = -5


On 2018/3/28 11:52, piaojun wrote:
> We need check len for bio_add_page() to make sure the bio has been set up
> correctly, otherwise we may submit incorrect data to device.
> 
> Signed-off-by: Jun Piao <piaojun@huawei.com>
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
> ---
>   fs/ocfs2/cluster/heartbeat.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index ea8c551..43ad79f 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -570,7 +570,16 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
>   		     current_page, vec_len, vec_start);
> 
>   		len = bio_add_page(bio, page, vec_len, vec_start);
> -		if (len != vec_len) break;
> +		if (len != vec_len) {
> +			mlog(ML_ERROR, "Adding page[%d] to bio failed, "
> +			     "page %p, len %d, vec_len %u, vec_start %u, "
> +			     "bi_sector %llu\n", current_page, page, len,
> +			     vec_len, vec_start,
> +			     (unsigned long long)bio->bi_iter.bi_sector);
> +			bio_put(bio);
> +			bio = ERR_PTR(-EFAULT);
> +			return bio;
> +		}
> 
>   		cs += vec_len / (PAGE_SIZE/spp);
>   		vec_start = 0;
> 
