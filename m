From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 19 Nov 2018 15:12:37 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: don't clear bh uptodate for
 block read
In-Reply-To: <5BF25FD8.8090802@huawei.com>
References: <20181114000040.8154-1-junxiao.bi@oracle.com>
	<5BF22878.4010607@huawei.com>
	<37a47d78-ddda-26da-8a8f-bd38c3ae495f@oracle.com>
	<5BF254B7.4070209@huawei.com>
	<e6e921a6-4500-5cb1-a478-d755e0980f6f@oracle.com>
	<5BF25FD8.8090802@huawei.com>
Message-ID: <6acce5e9-abf4-1025-7ef8-fa78c9f4146a@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/19/18 3:01 PM, jiangyiwen wrote:

> On 2018/11/19 14:34, Junxiao Bi wrote:
>> On 11/19/18 2:14 PM, jiangyiwen wrote:
>>
>>> On 2018/11/19 13:46, Junxiao Bi wrote:
>>>> On 11/19/18 11:05 AM, jiangyiwen wrote:
>>>>> On 2018/11/14 8:00, Junxiao Bi wrote:
>>>>>> For sync io read in ocfs2_read_blocks_sync(), first clear bh uptodate flag
>>>>>> and submit the io, second wait io done, last check whether bh uptodate,
>>>>>> if not return io error.
>>>>>>
>>>>>> If two sync io for the same bh were issued, it could be the first io done
>>>>>> and set uptodate flag, but just before check that flag, the second io came
>>>>>> in and cleared uptodate, then ocfs2_read_blocks_sync() for the first io
>>>>>> will return IO error.
>>>>>>
>>>>>> Indeed it's not necessary to clear uptodate flag, as the io end handler
>>>>>> end_buffer_read_sync() will set or clear it based on io succeed or failed.
>>>>>>
>>>>>> The following message was found from a nfs server but the underlying
>>>>>> storage returned no error.
>>>>>>
>>>>>> [4106438.567376] (nfsd,7146,3):ocfs2_get_suballoc_slot_bit:2780 ERROR: read block 1238823695 failed -5
>>>>>> [4106438.567569] (nfsd,7146,3):ocfs2_get_suballoc_slot_bit:2812 ERROR: status = -5
>>>>>> [4106438.567611] (nfsd,7146,3):ocfs2_test_inode_bit:2894 ERROR: get alloc slot and bit failed -5
>>>>>> [4106438.567643] (nfsd,7146,3):ocfs2_test_inode_bit:2932 ERROR: status = -5
>>>>>> [4106438.567675] (nfsd,7146,3):ocfs2_get_dentry:94 ERROR: test inode bit failed -5
>>>>>>
>>>>>> Same issue in non sync read ocfs2_read_blocks(), fixed it as well.
>>>>>>
>>>>>> Signed-off-by: Junxiao Bi<junxiao.bi@oracle.com>
> Reviewed-by: Yiwen Jiang<jiangyiwen@huawei.com>

Yiwen, many thanks for your review.


>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20181119/bd47b7f6/attachment.html 
