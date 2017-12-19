From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 19 Dec 2017 09:11:28 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fall back to buffer IO when append
 dio is disabled with file hole existing
References: <63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com>
	<5A386F0C.3090501@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F1F5CD64@H3CMLB14-EX.srv.huawei-3com.com>
	<5A388A38.7060809@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F1F5CEE7@H3CMLB14-EX.srv.huawei-3com.com>
	<14cbde8a-cbdb-80c9-b70b-a4af74654b3a@oracle.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F5EA2B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2017/12/19 16:15, Junxiao Bi wrote:
> Hi Changwei,
> 
> On 12/19/2017 02:02 PM, Changwei Ge wrote:
>> On 2017/12/19 11:41, piaojun wrote:
>>> Hi Changwei,
>>>
>>> On 2017/12/19 11:05, Changwei Ge wrote:
>>>> Hi Jun,
>>>>
>>>> On 2017/12/19 9:48, piaojun wrote:
>>>>> Hi Changwei,
>>>>>
>>>>> On 2017/12/18 20:06, Changwei Ge wrote:
>>>>>> Before ocfs2 supporting allocating clusters while doing append-dio, all append
>>>>>> dio will fall back to buffer io to allocate clusters firstly. Also, when it
>>>>>> steps on a file hole, it will fall back to buffer io, too. But for current
>>>>>> code, writing to file hole will leverage dio to allocate clusters. This is not
>>>>>> right, since whether append-io is enabled tells the capability whether ocfs2 can
>>>>>> allocate space while doing dio.
>>>>>> So introduce file hole check function back into ocfs2.
>>>>>> Once ocfs2 is doing dio upon a file hole with append-dio disabled, it will fall
>>>>>> back to buffer IO to allocate clusters.
>>>>>>
>>>>> 1. Do you mean that filling hole can't go with dio when append-dio is disabled?
>>>>
>>>> Yes, direct IO will fall back to buffer IO with _append-dio_ disabled.
>>>
>>> Why does dio need fall back to buffer-io when append-dio disabled?
>>> Could 'common-dio' on file hole go through direct io process? If not,
>>> could you please point out the necessity.
>> Hi Jun,
>>
>> The intention to make dio fall back to buffer io is to provide *an option* to users, which
>> is more stable and even fast.
> More memory will be consumed for some important user cases. Like if
> ocfs2 is using to store vm system image file, the file is highly sparse
> but never extended. If fall back buffer io, more memory will be consumed
> by page cache in dom0, that will cause less VM running on dom0 and
> performance issue.

I admit your point above makes scene.
But, AFAIK, major ocfs2 crash issues comes from direct IO part, especially when file is extremely
sparse. So for the worst case, virtual machine even can't run due to crash again and again.

I think the most benefit DIO brings to VM is that data can be transferred to LUN as soon as possible,
thus no data could be missed.

> 
>>   From my perspective, current ocfs2 dio implementation especially around space allocation during
>> doing dio still needs more test and improvements.
>>
>> Whether to make ocfs2 fall back to buffer io is up to ocfs2 users through toggling append-dio feature.
>> It rather makes ocfs2 configurable and flexible.
>>
>> Besides, do you still remember John's report about dio crash weeks ago?
> Looks like this is a workaround, why not fix the bug directly? If with
> this, people may disable append-dio by default to avoid dio issues. That
> will make it never stable. But it is a useful feature.

Arguably, this patch just provides an extra option to users. It's up to ocfs2 users how to use ocfs2 for
their business. I think we should not limit ocfs2 users.

Moreover, I agree that direct IO is a useful feature, but it is not mature enough yet.
We have to improve it, however, it needs time. I suppose we still have a short or long journey until that.
So before that we could provide a backup way.
This may look like kind of workaround, but I prefer to call it an extra option.

Thanks,
Changwei

> 
> Thanks,
> Junxiao.
> 
>>
>> I managed to reproduce this issue, so for now, I don't trust dio related code one hundred percents.
>> So if something bad happens to dio writing with space allocation, we can still make ocfs2 fall back to buffer io
>> It's an option not a mandatory action.
>>
>> Besides, append-dio feature is key to whether to allocate space with dio writing.
>> So writing to file hole and enlarging file(appending file) should have the same reflection to append-dio feature.
>> :)
>>
>> Thanks,
>> Changwei
>>
>>>
>>>>
>>>>> 2. Is your checking-hole just for 'append-dio' or for 'all-common-dio'?
>>>>
>>>> Just for append-dio
>>>>
>>>
>>> If your patch is just for 'append-dio', I wonder that will have impact
>>> on 'common-dio'.
>>>
>>> thanks,
>>> Jun
>>>
>>>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>>>> ---
>>>>>>      fs/ocfs2/aops.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>>>>>      1 file changed, 42 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>>>>> index d151632..a982cf6 100644
>>>>>> --- a/fs/ocfs2/aops.c
>>>>>> +++ b/fs/ocfs2/aops.c
>>>>>> @@ -2414,6 +2414,44 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>>>>>>      	return ret;
>>>>>>      }
>>>>>>      
>>>>>> +/*
>>>>>> + * Will look for holes and unwritten extents in the range starting at
>>>>>> + * pos for count bytes (inclusive).
>>>>>> + */
>>>>>> +static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
>>>>>> +				       size_t count)
>>>>>> +{
>>>>>> +	int ret = 0;
>>>>>> +	unsigned int extent_flags;
>>>>>> +	u32 cpos, clusters, extent_len, phys_cpos;
>>>>>> +	struct super_block *sb = inode->i_sb;
>>>>>> +
>>>>>> +	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
>>>>>> +	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
>>>>>> +
>>>>>> +	while (clusters) {
>>>>>> +		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
>>>>>> +					 &extent_flags);
>>>>>> +		if (ret < 0) {
>>>>>> +			mlog_errno(ret);
>>>>>> +			goto out;
>>>>>> +		}
>>>>>> +
>>>>>> +		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
>>>>>> +			ret = 1;
>>>>>> +			break;
>>>>>> +		}
>>>>>> +
>>>>>> +		if (extent_len > clusters)
>>>>>> +			extent_len = clusters;
>>>>>> +
>>>>>> +		clusters -= extent_len;
>>>>>> +		cpos += extent_len;
>>>>>> +	}
>>>>>> +out:
>>>>>> +	return ret;
>>>>>> +}
>>>>>> +
>>>>>>      static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>>>>>      {
>>>>>>      	struct file *file = iocb->ki_filp;
>>>>>> @@ -2429,8 +2467,10 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>>>>>      		return 0;
>>>>>>      
>>>>>>      	/* Fallback to buffered I/O if we do not support append dio. */
>>>>>> -	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
>>>>>> -	    !ocfs2_supports_append_dio(osb))
>>>>>> +	if (!ocfs2_supports_append_dio(osb) &&
>>>>>> +			(iocb->ki_pos + iter->count > i_size_read(inode) ||
>>>>>> +			 ocfs2_check_range_for_holes(inode, iocb->ki_pos,
>>>>>> +						     iter->count)))
>>>>> we should check error here, right?
>>>>
>>>> Accept this point.
>>>>
>>>> Thanks,
>>>> Changwei
>>>>
>>>>>
>>>>> thanks,
>>>>> Jun
>>>>>>      		return 0;
>>>>>>      
>>>>>>      	if (iov_iter_rw(iter) == READ)
>>>>>>
>>>>>
>>>>
>>>> .
>>>>
>>>
>>
> 
> 
