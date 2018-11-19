From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 19 Nov 2018 13:46:52 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: don't clear bh uptodate for
 block read
In-Reply-To: <5BF22878.4010607@huawei.com>
References: <20181114000040.8154-1-junxiao.bi@oracle.com>
	<5BF22878.4010607@huawei.com>
Message-ID: <37a47d78-ddda-26da-8a8f-bd38c3ae495f@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 11/19/18 11:05 AM, jiangyiwen wrote:
> On 2018/11/14 8:00, Junxiao Bi wrote:
>> For sync io read in ocfs2_read_blocks_sync(), first clear bh uptodate flag
>> and submit the io, second wait io done, last check whether bh uptodate,
>> if not return io error.
>>
>> If two sync io for the same bh were issued, it could be the first io done
>> and set uptodate flag, but just before check that flag, the second io came
>> in and cleared uptodate, then ocfs2_read_blocks_sync() for the first io
>> will return IO error.
>>
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
>> Same issue in non sync read ocfs2_read_blocks(), fixed it as well.
>>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> Cc: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>
>> v1 -> v2:
>>
>>    - fixed non sync read ocfs2_read_blocks() as well.
>>
>> ---
>>   fs/ocfs2/buffer_head_io.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>> index 4ebbd57cbf84..f9b84f7a3e4b 100644
>> --- a/fs/ocfs2/buffer_head_io.c
>> +++ b/fs/ocfs2/buffer_head_io.c
>> @@ -161,7 +161,6 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>>   #endif
>>   		}
>>   
>> -		clear_buffer_uptodate(bh);
> If we should use mutex_lock to keep sync?
>
> Thanks.
As my last email in this thread mentioned, it will not cause difference. 
Here race is between processes accessing the same block. At last the io 
error will be return for this very block. I don't think we need bother 
using mutex to sync them.
>
>>   		get_bh(bh); /* for end_buffer_read_sync() */
>>   		bh->b_end_io = end_buffer_read_sync;
>>   		submit_bh(REQ_OP_READ, 0, bh);
>> @@ -341,7 +340,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>   				continue;
>>   			}
>>   
>> -			clear_buffer_uptodate(bh);
> Actually, this don't need to change, because we will add ocfs2_metadata_cache_io_lock() and
> ensure only one thread to read buffer.

Not every block has this lock used, only inode and refcount using it.

Thanks,

Junxiao.

>
>>   			get_bh(bh); /* for end_buffer_read_sync() */
>>   			if (validate)
>>   				set_buffer_needs_validate(bh);
>>
>
