From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 14 Nov 2018 01:42:49 +0000
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: don't clear bh uptodate for
 block read
References: <20181114000040.8154-1-junxiao.bi@oracle.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37301277E5267@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

Actually, I think we still have another race around reading blocks methods.
Consider below scenario:

Two parallel reading IO towards the same block.
The first succeeds while the second fails.
The second will clear _UPTODATE_ state in end_buffer_read_sync() thus making the first one failed as well.

So better for us to not use generic end_buffer_read_sync() but ocfs2 own ones.
But it has nothing to do with this patch.
I am adding my Reviewed-by.

Thanks,
Changwei

On 2018/11/14 8:04, Junxiao Bi wrote:
> For sync io read in ocfs2_read_blocks_sync(), first clear bh uptodate flag
> and submit the io, second wait io done, last check whether bh uptodate,
> if not return io error.
> 
> If two sync io for the same bh were issued, it could be the first io done
> and set uptodate flag, but just before check that flag, the second io came
> in and cleared uptodate, then ocfs2_read_blocks_sync() for the first io
> will return IO error.
> 
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
> Same issue in non sync read ocfs2_read_blocks(), fixed it as well.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <ge.changwei@h3c.com>

Reviewed-by: Changwei Ge <ge.changwei@h3c.com>

> ---
> 
> v1 -> v2:
> 
>    - fixed non sync read ocfs2_read_blocks() as well.
> 
> ---
>   fs/ocfs2/buffer_head_io.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 4ebbd57cbf84..f9b84f7a3e4b 100644
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
> @@ -341,7 +340,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   				continue;
>   			}
>   
> -			clear_buffer_uptodate(bh);
>   			get_bh(bh); /* for end_buffer_read_sync() */
>   			if (validate)
>   				set_buffer_needs_validate(bh);
> 
