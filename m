From: yangwenfang <vicky.yangwenfang@huawei.com>
Date: Sat, 31 Jan 2015 12:15:29 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2/dlm: support range lock
In-Reply-To: <54CB7B15.5040702@suse.de>
References: <54C632F4.3070705@huawei.com>
	<54C73985.8060604@oracle.com>	<54C9D63C.9010401@huawei.com>
	<54CA13A6.8070702@illinois.edu> <54CAF389.8090404@huawei.com>
	<54CB7B15.5040702@suse.de>
Message-ID: <54CC56E1.9040708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/1/30 20:37, Goldwyn Rodrigues wrote:
> 
> 
> On 01/29/2015 08:59 PM, Xue jiufei wrote:
>> Hi Goldwyn,
>> On 2015/1/29 19:04, Goldwyn Rodrigues wrote:
>>> Yangwenfang,
>>>
>>> On 01/29/2015 12:42 AM, yangwenfang wrote:
>>>> On 2015/1/27 15:08, Srinivas Eeda wrote:
>>>>> Hi Yangwenfang,
>>>>>
>>>>> thank you very much for initiating this RFC :). This feature is long due for OCFS2 and we are also interested in implementing this feature. Wengang(cc'ed) has been looking into analysing and giving an attempt to implement it. We haven't  looked at splitting and merging the range locking yet, but looked at having lock fairness and range locking. Wengang has done some of the dlm changes to see how it can be done but other changes are still work in progress. We will email more details in coming few days.
>>>>>
>>>>> Since you are also looking into it, it would be great if we can collaborate work on this feature. Can you please share more info on the demo code you mentioned ? Like what it does and how much work has been done on this ?
>>>>>
>>>> Hi,
>>>> About 6k lines of code was modified including dlmglue and dlm in our demo.
>>>>
>>>> code modification:
>>>> 1.read/write IO: get the range(start, end) and call ocfs2_range_lock.
>>>> 2.dlmglue: modify key data struct: each inode has one ocfs2_lock_res including many range locks which have different range.
>>>>            determine the existance of conflicts betwen multiple threads within the node.
>>>>            manage the cache of range lock to support unlock-delay.
>>>> 3.dlm: determine the existance of conflicts betwen multiple nodes.
>>>>        add splitting and merging the range locking.
>>>> 4.lib: interval tree.
>>>>> One of the thing we considered was making the rw lock itself support range locking, which is a different approach from what you mentioned. Is there any reason why rw lock cannot be used and we needa new ip_range_lock_lockres ?
>>>>>
>>>> RW lock can be used, but it is complicated to add the feature to rw_lock because RW lock is also applicated in read/write/truncate.
>>>> Byte range lock is only beneficial for update write, so I just modify write IO to finish the demo to get performance results as soon as possible.
>>>> I think ocfs2_rw_lock(pr)  + ocfs2_range_lock(start, end, ex) are equivalent to ocfs2_rw_lock(ex)?am I rigth?
>>>
>>> Okay, let me ask this question in another way: What is the purpose of
>>> ocfs2_rw_lock(pr) in *this* scenario, where you are using
>>> ocfs2_range_lock in conjunction with ocfs2_rw_lock. What is
>>> ocfs2_rw_lock guarding?
>>>
>> Because RW lock is also used to protect O_DIRECT reads from racing with truncate,
>> buffer read is not protected by RW lock. We do not want to change rw lock in buffer
>> read scenario. So we add another range lock to complete this demo.
>>
> 
> Sorry, I still don't understand this. You are changing the RW lock from EX to PR during writes. This will add races (with respect to reads) rather solving it.
> 
Ok, let me have a try to answer this in another way.

1.ocfs2_rw_lock is called by ocfs2_setattr(EX), __ocfs2_change_file_space(EX),ocfs2_move_extents(EX),
ocfs2_file_splice_write(EX),ocfs2_file_aio_write(EX or PR),ocfs2_file_aio_read(PR).

Changing the RW lock from EX to PR is risky when another node is keeping RW PR lock.
So we add another type of lock in functions which are using RW PR lock including ocfs2_file_aio_write and ocfs2_file_aio_read.
Such implementations do not change the original read/write IO flows.

RW and range lock work together to prevent racing just in ocfs2_file_aio_write and ocfs2_file_aio_read.
For example: buffer read/write
ocfs2_file_aio_write
	mutex_lock(&inode->i_mutex);
	ocfs2_rw_lock(0, Max_LEN, PR)
	ocfs2_range_lock(start, end, EX)
	generic_file_buffered_write
		ocfs2_write_begin
		ocfs2_write_end

ocfs2_file_aio_read
	ocfs2_range_lock(start, end, PR)
	generic_file_aio_read
		
2. Making the rw lock itself support range locking is realizable after finishing the follwing things:
1)modify the interface of ocfs2_rw_lock, add parameters of start and end.
2)get the scope in ocfs2_file_aio_write.
3)add calling ocfs2_rw_lock in ocfs2_file_aio_read.
4)the scope is (0, Max_LEN) in ocfs2_setattr, __ocfs2_change_file_space, ocfs2_move_extents, ocfs2_file_splice_write.

thanks,
yangwenfang
