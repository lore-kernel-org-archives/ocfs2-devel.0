From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 14 Nov 2018 09:29:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't clear bh uptodate for sync
 read
In-Reply-To: <9d3d6fc1-e1e3-4a89-efbe-35fc0ceeea8c@oracle.com>
References: <20181113045810.8384-1-junxiao.bi@oracle.com>
	<9d3d6fc1-e1e3-4a89-efbe-35fc0ceeea8c@oracle.com>
Message-ID: <aa9260db-08da-5050-371b-75af20d9c6c6@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,

ocfs2_fh_to_dentry may run in parallel for the same handle?

[4182529.044099]? [<ffffffffa0aadd3b>] 
ocfs2_get_suballoc_slot_bit+0x5b/0x350 [ocfs2]
[4182529.044799]? [<ffffffffa0aae3fa>] ocfs2_test_inode_bit+0x6a/0x400 
[ocfs2]
[4182529.045488]? [<ffffffffa0a73c25>] ? ocfs2_get_dentry+0x2b5/0x570 
[ocfs2]
[4182529.046166]? [<ffffffffa0a73c3f>] ocfs2_get_dentry+0x2cf/0x570 [ocfs2]
[4182529.046831]? [<ffffffffa095533d>] ? exp_get_by_name+0x9d/0xc0 [nfsd]
[4182529.047501]? [<ffffffffa0ae6780>] ? 
CSWTCH.2756+0x19/0xffffffffffffe29a [ocfs2]
[4182529.048160]? [<ffffffffa094fdf0>] ? fh_update+0xe0/0xe0 [nfsd]
[4182529.048824]? [<ffffffffa0a73f74>] ocfs2_fh_to_dentry+0x44/0x50 [ocfs2]
[4182529.049481]? [<ffffffff8128e54f>] exportfs_decode_fh+0x6f/0x2a0
[4182529.050126]? [<ffffffffa08bfbda>] ? sunrpc_cache_lookup+0x7a/0x2d0 
[sunrpc]
[4182529.050752]? [<ffffffffa0955922>] ? exp_find+0xe2/0x190 [nfsd]
[4182529.051369]? [<ffffffff810a6226>] ? prepare_creds+0x26/0xe0
[4182529.051973]? [<ffffffffa095019a>] nfsd_set_fh_dentry+0x20a/0x3d0 [nfsd]
[4182529.052560]? [<ffffffff810bc12e>] ? update_rq_runnable_avg+0xee/0x230
[4182529.053132]? [<ffffffffa0950526>] fh_verify+0x1c6/0x200 [nfsd]
[4182529.053692]? [<ffffffffa0951c28>] nfsd_open+0x38/0x200 [nfsd]
[4182529.054239]? [<ffffffffa0952043>] nfsd_write+0xb3/0x100 [nfsd]
[4182529.054771]? [<ffffffff811e7a15>] ? kmem_cache_alloc+0x195/0x210
[4182529.055293]? [<ffffffffa095b2ff>] nfsd3_proc_write+0xaf/0x140 [nfsd]
[4182529.055807]? [<ffffffffa09871a8>] ? 
nfsd_procedures3+0x188/0xffffffffffff7890 [nfsd]
[4182529.056315]? [<ffffffffa09871a8>] ? 
nfsd_procedures3+0x188/0xffffffffffff7890 [nfsd]
[4182529.056808]? [<ffffffffa094c635>] nfsd_dispatch+0xe5/0x230 [nfsd]
[4182529.057299]? [<ffffffffa08b51e2>] ? svc_tcp_adjust_wspace+0x12/0x30 
[sunrpc]
[4182529.057799]? [<ffffffffa09871a8>] ? 
nfsd_procedures3+0x188/0xffffffffffff7890 [nfsd]
[4182529.058305]? [<ffffffffa08b4673>] svc_process_common+0x323/0x640 
[sunrpc]
[4182529.058827]? [<ffffffffa0987000>] ? 
nfsd_acl_procedures2+0x120/0xffffffffffff79d0 [nfsd]
[4182529.059337]? [<ffffffffa094cf70>] ? nfsd_svc+0x130/0x130 [nfsd]
[4182529.059841]? [<ffffffffa08b4dd3>] svc_process+0x123/0x200 [sunrpc]
[4182529.060336]? [<ffffffffa094d067>] nfsd+0xf7/0x170 [nfsd]
[4182529.060828]? [<ffffffff810a46de>] kthread+0xce/0xf0
[4182529.061312]? [<ffffffff810a4610>] ? 
kthread_freezable_should_stop+0x70/0x70
[4182529.061822]? [<ffffffff816cbf22>] ret_from_fork+0x42/0x70
[4182529.062311]? [<ffffffff810a4610>] ? 
kthread_freezable_should_stop+0x70/0x70


Thanks,

Junxiao.

On 11/14/18 2:22 AM, Wengang Wang wrote:
> Hi Junxiao,
>
>
> On 2018/11/12 20:58, Junxiao Bi wrote:
>> For sync io read in ocfs2_read_blocks_sync(), first clear bh uptodate flag
>> and submit the io, second wait io done, last check whether bh uptodate,
>> if not return io error.
>>
>> If two sync io for the same bh were issued, it could be the first io done
>> and set uptodate flag, but just before check that flag, the second io came
>> in and cleared uptodate, then ocfs2_read_blocks_sync() for the first io
>> will return IO error.
> Seems the uptodate flag is set/clear in end_buffer_read_sync() anyway,
> that support your skipping the clearing work before submitting IO.
> I wonder about the race that read the same block from different paths..
> Do you have the detail?
>
> thanks,
> wengang
>
>> Indeed it's not necessary to clear uptodate flag, as the io end handler
>> end_buffer_read_sync() will set or clear it based on io succeed or failed.
>>
>> The following message was found from a nfs server but the underlying
>> storage returned no error.
>>
>> [4106438.567376] (nfsd,7146,3):ocfs2_get_suballoc_slot_bit:2780 ERROR: read block 1238823695 failed -5
>> [4106438.567569] (nfsd,7146,3):ocfs2_get_suballoc_slot_bit:2812 ERROR: status = -5
>> [4106438.567611] (nfsd,7146,3):ocfs2_test_inode_bit:2894 ERROR: get alloc slot and bit failed -5
>> [4106438.567643] (nfsd,7146,3):ocfs2_test_inode_bit:2932 ERROR: status = -5
>> [4106438.567675] (nfsd,7146,3):ocfs2_get_dentry:94 ERROR: test inode bit failed -5
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>    fs/ocfs2/buffer_head_io.c | 1 -
>>    1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>> index 4ebbd57cbf84..45ee47a3c91b 100644
>> --- a/fs/ocfs2/buffer_head_io.c
>> +++ b/fs/ocfs2/buffer_head_io.c
>> @@ -161,7 +161,6 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>>    #endif
>>    		}
>>    
>> -		clear_buffer_uptodate(bh);
>>    		get_bh(bh); /* for end_buffer_read_sync() */
>>    		bh->b_end_io = end_buffer_read_sync;
>>    		submit_bh(REQ_OP_READ, 0, bh);
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
