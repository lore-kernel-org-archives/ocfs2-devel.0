From: yangwenfang <vicky.yangwenfang@huawei.com>
Date: Thu, 29 Jan 2015 15:47:52 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2/dlm: support range lock
In-Reply-To: <54C9794B.9000708@suse.de>
References: <54C632F4.3070705@huawei.com> <54C9794B.9000708@suse.de>
Message-ID: <54C9E5A8.8060804@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/1/29 8:05, Goldwyn Rodrigues wrote:
> 
> Hi Yangwenfang,
> 
> I appreciate the effort in this regard.
> 
> On 01/26/2015 06:28 AM, yangwenfang wrote:
>> What:
>> Byte range lock is applied to lock a region of a file to accelerate
>> reading/writing concurrently.

>> Each lock resource deploys an interval tree to manage the range, which
>> supports basic operations like add, delete, insert, find, split and merge.
>> The most important issue is to determine the existance of conflicts
>> among the ranges. Conflict-free ranges of the same file can be accessed
>> concurrently. In the contrary, nodes must wait for the release of a
>> conflicted lock before accessing the range of file.
>>
>> Byte range lock supports split and merge rules: for same level, larger
>> scope; different level, write > read(If a node keeps EX lock with
>> range(start,end), then it has PR range lock(start,end)).
>> For example:
>> (1) merge: N1 keeps range lock (0,9)PR and (5,19)PR, the lock is merged into
>> (0,19) PR;
>> (2) merge: N1 keeps range lock (0,9)PR and (5,19)EX, the merged lock should
>> become(0,19) PR, (5,19)EX;
>> (3) split: N1 keeps range lock (0,9)PR, N2 tries to lock(0,5) PR, N1 should
>> split the lock and keep (6,9)PR.
> 
> What is the purpose of doing this kind of merge/split? I assume this will be required in case of multiple processes from the same node read/write to the file. Would it not be simpler to not merge or split and keep separate instances in lock resources? This way you would have to do relatively lesser book keeping with respect to comparisons.
> 
Hi,
Realization of this kind of merge/split is for cache of range lock to support unlock-delay.
For example(the granularity is block size)
1.Node 1 writes to 0-9, it will keep the range lock(0,9,EX) if no other node write the same range of file.
2.Node 1 writes to 10-19, then the range lock will be merged into (0,19,EX). if not, the number of locks will be more and more.
3.Node 1 writes to 5-10, then no need to dlmlock from master.
3.Node 2 writes to 5-10, conflict with Node 1, so Node 1 will drop (5,10), the range lock is splitted into (0,4) and (11,19).

> Are these numbers in your pseudocode byte ranges? If yes, how do you propose multiple writes which lie within a block_size/cluster_size range?
> 
No, the granularity of these numbers is block size or PAGE_SIZE. The granularity is smaller, the conflict is more. Actually, we use 1M in our test.

thanks,
yangwenfang
