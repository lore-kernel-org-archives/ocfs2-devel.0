From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 02 Jun 2011 11:43:06 -0700
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: bugfix for hard readonly mount
In-Reply-To: <4DE6FED5.6000208@oracle.com>
References: <4DDE2000.3000301@oracle.com> <4DDE79EB.3080006@oracle.com>
	<4DDE7CF5.1020101@oracle.com> <4DDE7E19.6090307@oracle.com>
	<4DE6FED5.6000208@oracle.com>
Message-ID: <4DE7D9BA.5090006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan,

Please can you build a newer ocfs2-test rpm. The last one was built on 2009.

The stat -f discrepancy is probably due to localalloc. We shouldn't be reserving
space for hard-ro mounts. So should be ok as long as the discrepancy can be
accounted for.

# grep "LocalAlloc " /sys/kernel/debug/ocfs2/*/fs_state
The last column * clustersize is the space reserved.

I have no clue what the "total" value comprises off. Can you look into that?

Sunil

On 06/01/2011 08:09 PM, Tristan Ye wrote:
> Sunil Mushran wrote:
>> On 05/26/2011 09:16 AM, Tristan Ye wrote:
>>> On 05/27/2011 12:03 AM, Sunil Mushran wrote:
>>>> Tiger, Thanks. Was this tested with all fs-features enabled? I am
>>>> worried about quotas. If not, please test that.
>>>>
>>>> Tristan, Please can you cross check these patches. Enable all features
>>>> in a volume, make it readonly and do mount, ls -lR, umount, read, stat,
>>>> stat -f. This calls for a test script. We should be able to use
>>>> loopback.
>>>> losetup -rf.
>>> Sure,
>>>
>>> I'm going to write a dedicated script for sanity check, including these
>>> generic fs syscalls.
>> Thanks Tristan.
>>
>> Tiger, I would suggest you roll up the patch into one. I see no reason
>> for the breakup considering it fixes just one bug and is small enough.
>
> After running tests on block/loopback device, it shows that:
>
> 1. 'ls -lR /kernel/tree' dumps slightly different output:
>
> 6c6
> <  total 436
> ---
>> total 428
> 37c37
> <  total 52
> ---
>> total 44
> 394c394
> <  total 252
> ---
>> total 228
> 1408c1408
> <  total 8
> ---
>> total 4
> 1636c1636
> <  total 8
>
> while the data is consistent anyway.
>
>
> 2. 'stat -f' also dumps a slightly different map:
>
> 4,5c4,5
> <  Blocks: Total: 176120528  Free: 170080504  Available: 170080504
> <  Inodes: Total: 22015066   Free: 21260063
> ---
>> Blocks: Total: 176120528  Free: 170088304  Available: 170088304
>> Inodes: Total: 22015066   Free: 21261038
>
> 3. Enabling quota on readonly fs caused kernel oops
>
> 4. Otherwise, everything is fine(xattr,reflink,..etc)
>
>
> Testing script attached.
>
>
> Tristan.
