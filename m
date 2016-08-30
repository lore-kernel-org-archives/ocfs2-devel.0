From: Ashish Samant <ashish.samant@oracle.com>
Date: Tue, 30 Aug 2016 16:17:27 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Fix start offset to
 ocfs2_zero_range_for_truncate()
In-Reply-To: <4a9f89d0-6556-0989-3314-9c535ba7763a@suse.com>
References: <1472252646-29618-1-git-send-email-ashish.samant@oracle.com>
	<bdd26542-cbe2-8879-6db0-fe576286b04d@suse.com>
	<57C48BBE.4060500@oracle.com>
	<b972483a-a468-4d02-333d-3e5f105c53c2@suse.com>
	<57C50776.4050808@oracle.com>
	<4a9f89d0-6556-0989-3314-9c535ba7763a@suse.com>
Message-ID: <57C61407.6060509@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

I am able to reproduce this on 4.8.0-rc3 as well. Can you try again and 
issue a sync between fallocate and dd?

On 08/30/2016 12:38 AM, Eric Ren wrote:
> Hi,
>
> I'm on 4.8.0-rc3 kernel. Hope someone else can double-confirm this;-)
>
> On 08/30/2016 12:11 PM, Ashish Samant wrote:
>> Hmm, thats weird. I see this on 4.7 kernel without the patch:
>>
>> # xfs_io -c 'pwrite -b 4k 0 10M' -f 10MBfile
>> wrote 10485760/10485760 bytes at offset 0
>> 10 MiB, 2560 ops; 0.0000 sec (683.995 MiB/sec and 175102.5992 ops/sec)
>> # reflink -f 10MBfile reflnktest
>> # fallocate -p -o 0 -l 1048615 reflnktest
>> # dd if=10MBfile iflag=direct bs=1048576 count=1 | hexdump -C
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
>> |................|
>> *
>> 1+0 records in
>> 1+0 records out
>> 1048576 bytes (1.0 MB) copied, 0.0321517 s, 32.6 MB/s
>> 00100000
>>
>> and with patch
>> ----
>> # dd if=10MBfile iflag=direct bs=1M count=1 | hexdump -C
>> 00000000  cd cd cd cd cd cd cd cd  cd cd cd cd cd cd cd cd 
>> |................|
>
> I'm not familiar with this code.  So why is the output "cd ..."? 
> because we didn't write anything
> into "10MBfile". Is it a magic number when reading from a hole?
No, "cd" is what xfs_io wrote into the file. Those are the original 
contents of the file which are overwritten by 0 in the first cluster 
because of this bug.

Thanks,
Ashish
>
> Eric
>
>> *
>> 1+0 records in
>> 1+0 records out
>> 00100000
>
>
>
>>
>> Thanks,
>> Ashish
>>
>>
>> On 08/29/2016 08:33 PM, Eric Ren wrote:
>>> Hello,
>>>
>>> On 08/30/2016 03:23 AM, Ashish Samant wrote:
>>>> Hi Eric,
>>>>
>>>> The easiest way to reproduce this is :
>>>>
>>>> 1. Create a random file of say 10 MB
>>>>     xfs_io -c 'pwrite -b 4k 0 10M' -f 10MBfile
>>>> 2. Reflink  it
>>>>     reflink -f 10MBfile reflnktest
>>>> 3. Punch a hole at starting at cluster boundary  with range greater 
>>>> that 1MB. You can also use a range that will put the end offset in 
>>>> another extent.
>>>>     fallocate -p -o 0 -l 1048615 reflnktest
>>>> 4. sync
>>>> 5. Check the  first cluster in the source file. (It will be zeroed 
>>>> out).
>>>>    dd if=10MBfile iflag=direct bs=<cluster size> count=1 | hexdump -C
>>>
>>> Thanks! I have a try myself, but I'm not sure what is our expected 
>>> output and if the test result meet
>>> it:
>>>
>>> 1. After applying this patch:
>>> ocfs2dev1:/mnt/ocfs2 # rm 10MBfile reflnktest
>>> ocfs2dev1:/mnt/ocfs2 # xfs_io -c 'pwrite -b 4k 0 10M' -f 10MBfile
>>> wrote 10485760/10485760 bytes at offset 0
>>> 10 MiB, 2560 ops; 0.0000 sec (1.089 GiB/sec and 285427.5839 ops/sec)
>>> ocfs2dev1:/mnt/ocfs2 # reflink -f 10MBfile reflnktest
>>> ocfs2dev1:/mnt/ocfs2 # fallocate -p -o 0 -l 1048615 reflnktest
>>> ocfs2dev1:/mnt/ocfs2 # dd if=10MBfile iflag=direct bs=1048576 
>>> count=1 | hexdump -C
>>> 00000000  cd cd cd cd cd cd cd cd  cd cd cd cd cd cd cd cd 
>>> |................|
>>> *
>>> 1+0 records in
>>> 1+0 records out
>>> 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0952464 s, 11.0 MB/s
>>> 00100000
>>>
>>> 2. Before this patch:
>>> ....
>>> ocfs2dev1:/mnt/ocfs2 # dd if=10MBfile iflag=direct bs=1048576 
>>> count=1 | hexdump -C
>>> 00000000  cd cd cd cd cd cd cd cd  cd cd cd cd cd cd cd cd 
>>> |................|
>>> *
>>> 1+0 records in
>>> 1+0 records out
>>> 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0954648 s, 11.0 MB/s
>>> 00100000
>>>
>>> 3. debugfs.ocfs2 -R stats /dev/sdb
>>> ...
>>> Block Size Bits: 12   Cluster Size Bits: 20
>>> ...
>>>
>>> Eric
>>>>
>>>> Thanks,
>>>> Ashish
>>>>
>>>> On 08/28/2016 10:39 PM, Eric Ren wrote:
>>>>> Hi,
>>>>>
>>>>> Thanks for this fix. I'd like to reproduce this issue locally and 
>>>>> test this patch,
>>>>> could you elaborate the detailed steps of reproduction?
>>>>>
>>>>> Thanks,
>>>>> Eric
>>>>>
>>>>> On 08/27/2016 07:04 AM, Ashish Samant wrote:
>>>>>> If we punch a hole on a reflink such that following conditions 
>>>>>> are met:
>>>>>>
>>>>>> 1. start offset is on a cluster boundary
>>>>>> 2. end offset is not on a cluster boundary
>>>>>> 3. (end offset is somewhere in another extent) or
>>>>>>     (hole range > MAX_CONTIG_BYTES(1MB)),
>>>>>>
>>>>>> we dont COW the first cluster starting at the start offset. But 
>>>>>> in this
>>>>>> case, we were wrongly passing this cluster to
>>>>>> ocfs2_zero_range_for_truncate() to zero out. This will modify the 
>>>>>> cluster
>>>>>> in place and zero it in the source too.
>>>>>>
>>>>>> Fix this by skipping this cluster in such a scenario.
>>>>>>
>>>>>> Reported-by: Saar Maoz <saar.maoz@oracle.com>
>>>>>> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
>>>>>> Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
>>>>>> ---
>>>>>> v1->v2:
>>>>>> -Changed the commit msg to include a better and generic 
>>>>>> description of
>>>>>>   the problem, for all cluster sizes.
>>>>>> -Added Reported-by and Reviewed-by tags.
>>>>>>      fs/ocfs2/file.c | 34 ++++++++++++++++++++++++----------
>>>>>>   1 file changed, 24 insertions(+), 10 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>>>>> index 4e7b0dc..0b055bf 100644
>>>>>> --- a/fs/ocfs2/file.c
>>>>>> +++ b/fs/ocfs2/file.c
>>>>>> @@ -1506,7 +1506,8 @@ static int 
>>>>>> ocfs2_zero_partial_clusters(struct inode *inode,
>>>>>>                          u64 start, u64 len)
>>>>>>   {
>>>>>>       int ret = 0;
>>>>>> -    u64 tmpend, end = start + len;
>>>>>> +    u64 tmpend = 0;
>>>>>> +    u64 end = start + len;
>>>>>>       struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>>>>>       unsigned int csize = osb->s_clustersize;
>>>>>>       handle_t *handle;
>>>>>> @@ -1538,18 +1539,31 @@ static int 
>>>>>> ocfs2_zero_partial_clusters(struct inode *inode,
>>>>>>       }
>>>>>>         /*
>>>>>> -     * We want to get the byte offset of the end of the 1st 
>>>>>> cluster.
>>>>>> +     * If start is on a cluster boundary and end is somewhere in 
>>>>>> another
>>>>>> +     * cluster, we have not COWed the cluster starting at start, 
>>>>>> unless
>>>>>> +     * end is also within the same cluster. So, in this case, we 
>>>>>> skip this
>>>>>> +     * first call to ocfs2_zero_range_for_truncate() truncate 
>>>>>> and move on
>>>>>> +     * to the next one.
>>>>>>        */
>>>>>> -    tmpend = (u64)osb->s_clustersize + (start & 
>>>>>> ~(osb->s_clustersize - 1));
>>>>>> -    if (tmpend > end)
>>>>>> -        tmpend = end;
>>>>>> +    if ((start & (csize - 1)) != 0) {
>>>>>> +        /*
>>>>>> +         * We want to get the byte offset of the end of the 1st
>>>>>> +         * cluster.
>>>>>> +         */
>>>>>> +        tmpend = (u64)osb->s_clustersize +
>>>>>> +            (start & ~(osb->s_clustersize - 1));
>>>>>> +        if (tmpend > end)
>>>>>> +            tmpend = end;
>>>>>>   - trace_ocfs2_zero_partial_clusters_range1((unsigned long 
>>>>>> long)start,
>>>>>> -                         (unsigned long long)tmpend);
>>>>>> +        trace_ocfs2_zero_partial_clusters_range1(
>>>>>> +            (unsigned long long)start,
>>>>>> +            (unsigned long long)tmpend);
>>>>>>   -    ret = ocfs2_zero_range_for_truncate(inode, handle, start, 
>>>>>> tmpend);
>>>>>> -    if (ret)
>>>>>> -        mlog_errno(ret);
>>>>>> +        ret = ocfs2_zero_range_for_truncate(inode, handle, start,
>>>>>> +                            tmpend);
>>>>>> +        if (ret)
>>>>>> +            mlog_errno(ret);
>>>>>> +    }
>>>>>>         if (tmpend < end) {
>>>>>>           /*
>>>>>
>>>>>
>>>>
>>>
>>
>>
>
