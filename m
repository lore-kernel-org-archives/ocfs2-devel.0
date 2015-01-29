From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 29 Jan 2015 05:07:00 -0600
Subject: [Ocfs2-devel] [RFC] ocfs2/dlm: support range lock
In-Reply-To: <54C9D63C.9010401@huawei.com>
References: <54C632F4.3070705@huawei.com> <54C73985.8060604@oracle.com>
	<54C9D63C.9010401@huawei.com>
Message-ID: <54CA1454.5040702@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yangwenfang,

On 01/29/2015 12:42 AM, yangwenfang wrote:
> On 2015/1/27 15:08, Srinivas Eeda wrote:
>> Hi Yangwenfang,
>>
>> thank you very much for initiating this RFC :). This feature is long due for OCFS2 and we are also interested in implementing this feature. Wengang(cc'ed) has been looking into analysing and giving an attempt to implement it. We haven't  looked at splitting and merging the range locking yet, but looked at having lock fairness and range locking. Wengang has done some of the dlm changes to see how it can be done but other changes are still work in progress. We will email more details in coming few days.
>>
>> Since you are also looking into it, it would be great if we can collaborate work on this feature. Can you please share more info on the demo code you mentioned ? Like what it does and how much work has been done on this ?
>>
> Hi,
> About 6k lines of code was modified including dlmglue and dlm in our demo.
>
> code modification:
> 1.read/write IO: get the range(start, end) and call ocfs2_range_lock.
> 2.dlmglue: modify key data struct: each inode has one ocfs2_lock_res including many range locks which have different range.
> 		   determine the existance of conflicts betwen multiple threads within the node.
> 		   manage the cache of range lock to support unlock-delay.
> 3.dlm: determine the existance of conflicts betwen multiple nodes.
> 	   add splitting and merging the range locking.
> 4.lib: interval tree.
>> One of the thing we considered was making the rw lock itself support range locking, which is a different approach from what you mentioned. Is there any reason why rw lock cannot be used and we needa new ip_range_lock_lockres ?
>>
> RW lock can be used, but it is complicated to add the feature to rw_lock because RW lock is also applicated in read/write/truncate.
> Byte range lock is only beneficial for update write, so I just modify write IO to finish the demo to get performance results as soon as possible.
> I think ocfs2_rw_lock(pr)  + ocfs2_range_lock(start, end, ex) are equivalent to ocfs2_rw_lock(ex)?am I rigth?


Okay, let me ask this question in another way: What is the purpose of 
ocfs2_rw_lock(pr) in *this* scenario, where you are using 
ocfs2_range_lock in conjunction with ocfs2_rw_lock. What is 
ocfs2_rw_lock guarding?

-- 
Goldwyn
