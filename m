From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 08 Jun 2009 14:40:09 +0800
Subject: [Ocfs2-devel] [SUGGESSTION 1/1] OCFS2: automatic dlm hash table
 size
In-Reply-To: <4A2CAE87.6070605@oracle.com>
References: <200906080515.n585F9Mu012898@rgminet15.oracle.com>
	<4A2CA7CC.7020407@oracle.com> <4A2CAE87.6070605@oracle.com>
Message-ID: <4A2CB249.5050304@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hi wengang,

Wengang Wang wrote:
> Hi Tao,
> 
> pls check inline.
> 
> Tao Ma wrote:
>> Hi Wengang,
>>
>> Regards,
>> Tao
>>
>> wengang wang wrote:
>>> backgroud:
>>>     ocfs2 dlm uses a hash table to store dlm_lock_resource objects. 
>>> the often used lookup is performed on the hash table.
>>>
>>> problem:
>>>     for usages that there are huge number of inodes(thus huge number 
>>> of dlm_lock_resource objects) in a ocfs2 volume, the lookup 
>>> performance becomes a problem. the lookup holds spin_lock which could 
>>> put all others cpus into the state of aquring the spinlock. if the 
>>> lock is held long enough by the lookup process, some hardware 
>>> watchdog  could reboot box since it's not fed in a time(the fed has 
>>> no change to be scheduled).        Why do you think a dlm res lookup 
>>> can lock up cpu for such a long time 
>> that can lead to hardware watchdog reboot?
>>     I am not object to this. But do you have any test statistics that 
>> demonstrate your suggestion? I think people are more easy to be 
>> convinced if they see some exciting numbers.
>>
> 
> There is such a bug. there are more than 100,0000 inodes in a single 
> ocfs2 volume. the system was suddenly rebooted. fortunately we got the 
> vmcore, checking the processes currently running on all cpus that time,
> they are either running in the hash lookup or trying to aquire the spin 
> lock. Srini and I suspect it's rebooted by the hardware watchdog.
> 
> it is ocfs2 1.2 and the hash table is in size of 14 shift bits. I back 
> ported the patches which enlarges hash table size to 17 and customer 
> didn't get the same problem.
> 
> however, I can't say I have statistics for this.
got it. But I just checked 1.2, it use PAGE_SIZE, so it should be 12?
And the mainline kernel use 14. So are you writing some typo?
> 
>>>
>>>     enlarging the hash table is the way to speed up the lookup. but 
>>> we don't know how large is a good size. --too small, performance is 
>>> bad; too large, there is a memory waste.
>>>
>>> suggestion:
>>>     so I suggest a automatic resizing the dlm_lock_resource hash 
>>> table feature. that means it can increase the size of the hash table 
>>> per the number of dlm_lock_resource objects which are already in the 
>>> hash table.
>>>     the default(smallest) size is 16 in shift bits. when the number 
>>> of dlm_lock_resource rearches 250,0000, auto-resizing is triggered 
>>> and the destination size is 17. and when rearches 500,0000, resize to 
>>> 18, for 1000,0000, resize to 19... though the numbers need to be 
>>> discussed yet.
>>>     with this we can use proper sized memory for runtime usage and 
>>> keep good enough lookup performance.
>> So concerning the autosize, do you think of the process of rehash?
>>
>> I think if you have reached 250,000 dlm entries, the rehash must hold 
>> the spin lock for quite a long time. And as you said above, if the 
>> hardware watchdog can even reboot for just one lock's lookup, it 
>> surely can't wait for your rehash.
>>
> 
> Yes, I have a thought on it. maybe we can accomplish the rehash in 
> several cycles, each cycle we takes the spinlock and between the cycles, 
> we use cond_schedule() to release cpu when needed(how many dlm entries 
> should be deal with in one cycle needs to be discussed). per this, 
> during rehash progress, the lookup needs to be performed on 2 
> hash_table, the old one and the new one(if not found in old one).
It is a bit complicated from your description. So why not just increase 
it as what you did for the bug above? It is easier and straightforward. 
What's more, even with 18, there are only 256K, as we now have such a 
large memory, 256K is almost nothing. ;)

Regards,
Tao
