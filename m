From: piaojun <piaojun@huawei.com>
Date: Thu, 29 Mar 2018 09:12:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/o2hb: check len for bio_add_page()
 to avoid submitting incorrect bio
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2954439@H3CMLB12-EX.srv.huawei-3com.com>
References: <5ABB110A.3050808@huawei.com>
	<9c5f2dca-dc05-c36d-c6ec-24171fe0a94f@gmail.com>
	<5ABB3DEC.5020507@huawei.com>
	<398b95fa-4ed6-bccf-e8f3-b2e118808ea6@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F2954439@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5ABC3D7D.6060500@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei and Joseph,

EIO sounds more reasonable, thanks a lot for your suggestions, and I will
send patch v2 later.

thanks,
Jun

On 2018/3/29 9:09, Changwei Ge wrote:
> Hi Jun,
> 
> On 2018/3/28 17:51, Joseph Qi wrote:
>>
>>
>> On 18/3/28 15:02, piaojun wrote:
>>> Hi Joseph,
>>>
>>> On 2018/3/28 12:58, Joseph Qi wrote:
>>>>
>>>>
>>>> On 18/3/28 11:50, piaojun wrote:
>>>>> We need check len for bio_add_page() to make sure the bio has been set up
>>>>> correctly, otherwise we may submit incorrect data to device.
>>>>>
>>>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>>>> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
>>>>> ---
>>>>>   fs/ocfs2/cluster/heartbeat.c | 11 ++++++++++-
>>>>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
>>>>> index ea8c551..43ad79f 100644
>>>>> --- a/fs/ocfs2/cluster/heartbeat.c
>>>>> +++ b/fs/ocfs2/cluster/heartbeat.c
>>>>> @@ -570,7 +570,16 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
>>>>>   		     current_page, vec_len, vec_start);
>>>>>
>>>>>   		len = bio_add_page(bio, page, vec_len, vec_start);
>>>>> -		if (len != vec_len) break;
>>>>> +		if (len != vec_len) {
>>>>> +			mlog(ML_ERROR, "Adding page[%d] to bio failed, "
>>>>> +			     "page %p, len %d, vec_len %u, vec_start %u, "
>>>>> +			     "bi_sector %llu\n", current_page, page, len,
>>>>> +			     vec_len, vec_start,
>>>>> +			     (unsigned long long)bio->bi_iter.bi_sector);
>>>>> +			bio_put(bio);
>>>>> +			bio = ERR_PTR(-EFAULT);
>>>>
>>>> IMO, EFAULT is not an appropriate error code here.
>>>> If __bio_add_page returns 0, some are caused by bio checking failed.
>>>> Also I've noticed that several other callers just use ENOMEM, so I think
>>>> EINVAL or ENOMEM may be better.
>>>
>>> __bio_add_page has been deleted in patch c66a14d07c13, and I notice that
>>> other callers always use -EFAULT or -EIO. I'm afraid we are not basing on
>>> the same kernel source.
>>>
>>
>> Oops... Yes, I was looking an old kernel...
>> EIO sounds reasonable, but I don't know why EFAULT since it means "Bad address".
> 
> I agree with Joseph that EFAULT seems unreasonable for this exception cached.
> But your trick looks good to me.
> After applying a more appropriate error number, please feel free to add my:
> Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
> 
> Thanks,
> Changwei
> 
> 
>>
>> Thanks,
>> Joseph
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> .
> 
