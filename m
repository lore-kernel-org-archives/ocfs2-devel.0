From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 13 Nov 2018 10:22:04 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't clear bh uptodate for sync
 read
In-Reply-To: <20181113045810.8384-1-junxiao.bi@oracle.com>
References: <20181113045810.8384-1-junxiao.bi@oracle.com>
Message-ID: <9d3d6fc1-e1e3-4a89-efbe-35fc0ceeea8c@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,


On 2018/11/12 20:58, Junxiao Bi wrote:
> For sync io read in ocfs2_read_blocks_sync(), first clear bh uptodate flag
> and submit the io, second wait io done, last check whether bh uptodate,
> if not return io error.
>
> If two sync io for the same bh were issued, it could be the first io done
> and set uptodate flag, but just before check that flag, the second io came
> in and cleared uptodate, then ocfs2_read_blocks_sync() for the first io
> will return IO error.
Seems the uptodate flag is set/clear in end_buffer_read_sync() anyway, 
that support your skipping the clearing work before submitting IO.
I wonder about the race that read the same block from different paths.. 
Do you have the detail?

thanks,
wengang

> Indeed it's not necessary to clear uptodate flag, as the io end handler
> end_buffer_read_sync() will set or clear it based on io succeed or failed.
>
> The following message was found from a nfs server but the underlying
> storage returned no error.
>
> [4106438.567376] (nfsd,7146,3):ocfs2_get_suballoc_slot_bit:2780 ERROR: read block 1238823695 failed -5
> [4106438.567569] (nfsd,7146,3):ocfs2_get_suballoc_slot_bit:2812 ERROR: status = -5
> [4106438.567611] (nfsd,7146,3):ocfs2_test_inode_bit:2894 ERROR: get alloc slot and bit failed -5
> [4106438.567643] (nfsd,7146,3):ocfs2_test_inode_bit:2932 ERROR: status = -5
> [4106438.567675] (nfsd,7146,3):ocfs2_get_dentry:94 ERROR: test inode bit failed -5
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/ocfs2/buffer_head_io.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 4ebbd57cbf84..45ee47a3c91b 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -161,7 +161,6 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>   #endif
>   		}
>   
> -		clear_buffer_uptodate(bh);
>   		get_bh(bh); /* for end_buffer_read_sync() */
>   		bh->b_end_io = end_buffer_read_sync;
>   		submit_bh(REQ_OP_READ, 0, bh);
