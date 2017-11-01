From: alex chen <alex.chen@huawei.com>
Date: Wed, 1 Nov 2017 17:47:06 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: unlock the o2hb_live_lock
	before the o2nm_depend_item()
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED73664@H3CMLB14-EX.srv.huawei-3com.com>
References: <59F86F83.7010501@huawei.com>
	<2581fe81-0b89-0385-a8e2-b82ca66ec114@gmail.com>
	<59F97160.9000506@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373CED73664@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <59F9981A.6090503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

Thanks for you reply.

On 2017/11/1 16:28, Changwei Ge wrote:
> Hi Alex,
> 
> On 2017/11/1 15:05, alex chen wrote:
>> Hi Joseph and Changwei,
>>
>> It's our basic principle that the function in which may sleep can't be called
>> within spinlock hold.
> 
> I suppose this principle is a suggestion not a restriction.
> 

It is a very very bad idea to sleep while holding a spin lock.
If a process grabs a spinlock and goes to sleep before releasing it.
Then this process yields the control of the CPU to a second process.
Unfortunately the second process also need to grab the spinlock and it will
busy wait. On an uniprocessor machine the second process will lock the CPU not
allowing the first process to wake up and release the spinlock so the second
process can't continue, it is basically a deadlock.

>>
>> On 2017/11/1 9:03, Joseph Qi wrote:
>>> Hi Alex,
>>>
>>> On 17/10/31 20:41, alex chen wrote:
>>>> In the following situation, the down_write() will be called under
>>>> the spin_lock(), which may lead a soft lockup:
>>>> o2hb_region_inc_user
>>>>   spin_lock(&o2hb_live_lock)
>>>>    o2hb_region_pin
>>>>     o2nm_depend_item
>>>>      configfs_depend_item
>>>>       inode_lock
>>>>        down_write
>>>>        -->here may sleep and reschedule
>>>>
>>>> So we should unlock the o2hb_live_lock before the o2nm_depend_item(), and
>>>> get item reference in advance to prevent the region to be released.
>>>>
>>>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>>>> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
>>>> Reviewed-by: Jun Piao <piaojun@huawei.com>
>>>> ---
>>>>   fs/ocfs2/cluster/heartbeat.c | 8 ++++++++
>>>>   1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
>>>> index d020604..f1142a9 100644
>>>> --- a/fs/ocfs2/cluster/heartbeat.c
>>>> +++ b/fs/ocfs2/cluster/heartbeat.c
>>>> @@ -2399,6 +2399,9 @@ static int o2hb_region_pin(const char *region_uuid)
>>>>   		if (reg->hr_item_pinned || reg->hr_item_dropped)
>>>>   			goto skip_pin;
>>>>
>>>> +		config_item_get(&reg->hr_item);
>>>> +		spin_unlock(&o2hb_live_lock);
>>>> +
>>> If unlock here, the iteration of o2hb_all_regions is no longer safe.
>>>
>>> Thanks,
>>> Joseph
>>>
>>
>> In local heartbeat mode, here we already found the region and will break the loop after
>> depending item, we get the item reference before spin_unlock(), that means the region will
>> never be released by the o2hb_region_release() until we put the item reference after
>> spin_lock(&o2hb_live_lock), so we can safely iterate over the list.
>> In global heartbeat mode, it doesn't matter that some regions may be deleted after
>> spin_unlock(), because we just pin all the active regions.
> 
> But we are still iterating elements on global list  *o2hb_all_regions*, 
> right? How can we guarantee that no more elements will be attached or 
> detached while the lock is unlocked.
> 

In global heartbeat mode, we pin all regions if there is the first dependent user and
unpin all regions if the number of dependent users falls to zero.
So there is not exist another region will be attached or detached after spin_unlock().

Thank,
Alex
>>
>> Thanks,
>> Alex
>>
>>>>   		/* Ignore ENOENT only for local hb (userdlm domain) */
>>>>   		ret = o2nm_depend_item(&reg->hr_item);
>>>>   		if (!ret) {
>>>> @@ -2410,9 +2413,14 @@ static int o2hb_region_pin(const char *region_uuid)
>>>>   			else {
>>>>   				mlog(ML_ERROR, "Pin region %s fails with %d\n",
>>>>   				     uuid, ret);
>>>> +				config_item_put(&reg->hr_item);
>>>> +				spin_lock(&o2hb_live_lock);
>>>>   				break;
>>>>   			}
>>>>   		}
>>>> +
>>>> +		config_item_put(&reg->hr_item);
>>>> +		spin_lock(&o2hb_live_lock);
>>>>   skip_pin:
>>>>   		if (found)
>>>>   			break;
>>>> -- 1.9.5.msysgit.1
>>>>
>>>>
>>>
>>> .
>>>
>>
>>
> 
> 
> .
> 
