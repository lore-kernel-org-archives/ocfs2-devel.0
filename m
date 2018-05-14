From: piaojun <piaojun@huawei.com>
Date: Mon, 14 May 2018 14:26:41 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: submit another bio if current bio
 is full
In-Reply-To: <HK2PR06MB045272ABFAF731E422EEFE29D59C0@HK2PR06MB0452.apcprd06.prod.outlook.com>
References: <1523598667-29401-1-git-send-email-ge.changwei@h3c.com>
	<5AF2C8A5.1020902@huawei.com>
	<HK2PR06MB0452F6BDFA71FABA6084FAA1D5990@HK2PR06MB0452.apcprd06.prod.outlook.com>
	<5AF3912C.6090900@huawei.com>
	<a08ce7e9-82fb-753a-1c6a-840020ff104b@live.cn>
	<HK2PR06MB045272ABFAF731E422EEFE29D59C0@HK2PR06MB0452.apcprd06.prod.outlook.com>
Message-ID: <5AF92C21.40704@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

I got your point, we should let the caller retry if bio is not enough,
right? But some caller like o2hb_issue_node_write() won't retry once error
happens, though the bio will always be enough. I think if we could
calculate the number of bio we need before calling bio_add_page()?

Thanks
Jun

On 2018/5/14 11:21, Changwei Ge wrote:
> Hi Jun,
> 
> Right now, I am afraid that the easiest and fasted way to fix this issue 
> is to revert your patch.
> 
>  From comments before function bio_add_page(), we can see that it only 
> fails if either ::bi_vcnt == ::bi_max_vecs or it's a cloned bio.
> 
> 
> So we can judge if bio is full from its return value is zero or not.
> 
> 
> Thanks,
> 
> Changwei
> 
> 
> On 2018/5/10 9:13, Changwei Ge wrote:
>>
>>
>> On 2018/5/10 8:24, piaojun wrote:
>>>
>>> On 2018/5/9 20:01, Changwei Ge wrote:
>>>> Hi Jun,
>>>>
>>>>
>>>> On 2018/5/9 18:08, piaojun wrote:
>>>>> Hi Changwei,
>>>>>
>>>>> On 2018/4/13 13:51, Changwei Ge wrote:
>>>>>> If cluster scale exceeds 16 nodes, bio will be full and 
>>>>>> bio_add_page()
>>>>>> returns 0 when adding pages to bio. Returning -EIO to 
>>>>>> o2hb_read_slots()
>>>>>> from o2hb_setup_one_bio() will lead to losing chance to allocate more
>>>>>> bios to present all heartbeat region.
>>>>>>
>>>>>> So o2hb_read_slots() fails.
>>>>>>
>>>>>> In my test, making fs fails in starting o2cb service.
>>>>>>
>>>>>> Attach error log:
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 0, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 1, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 2, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 3, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 4, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 5, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 6, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 7, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 8, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 9, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 10, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 11, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 12, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 13, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 14, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 15, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:463 page 16, vec_len = 
>>>>>> 4096, vec_start = 0
>>>>>> (mkfs.ocfs2,27479,2):o2hb_setup_one_bio:471 ERROR: Adding page[16] 
>>>>>> to bio failed, page ffffea0002d7ed40, len 0, vec_len 4096, 
>>>>>> vec_start 0, bi_sector 8192
>>>>>> (mkfs.ocfs2,27479,2):o2hb_read_slots:500 ERROR: status = -5
>>>>>> (mkfs.ocfs2,27479,2):o2hb_populate_slot_data:1911 ERROR: status = -5
>>>>>> (mkfs.ocfs2,27479,2):o2hb_region_dev_write:2012 ERROR: status = -5
>>>>>>
>>>>>> Fixes: ba16ddfbeb9d ("ocfs2/o2hb: check len for bio_add_page() to 
>>>>>> avoid getting incorrect bio"
>>>>>>
>>>>>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>>>>>> ---
>>>>>>    fs/ocfs2/cluster/heartbeat.c | 8 ++++++--
>>>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/cluster/heartbeat.c 
>>>>>> b/fs/ocfs2/cluster/heartbeat.c
>>>>>> index 91a8889abf9b..2809e29d612d 100644
>>>>>> --- a/fs/ocfs2/cluster/heartbeat.c
>>>>>> +++ b/fs/ocfs2/cluster/heartbeat.c
>>>>>> @@ -540,11 +540,12 @@ static struct bio *o2hb_setup_one_bio(struct 
>>>>>> o2hb_region *reg,
>>>>>>        struct bio *bio;
>>>>>>        struct page *page;
>>>>>>    +#define O2HB_BIO_VECS 16
>>>>>>        /* Testing has shown this allocation to take long enough under
>>>>>>         * GFP_KERNEL that the local node can get fenced. It would be
>>>>>>         * nicest if we could pre-allocate these bios and avoid this
>>>>>>         * all together. */
>>>>>> -    bio = bio_alloc(GFP_ATOMIC, 16);
>>>>>> +    bio = bio_alloc(GFP_ATOMIC, O2HB_BIO_VECS);
>>>>>>        if (!bio) {
>>>>>>            mlog(ML_ERROR, "Could not alloc slots BIO!\n");
>>>>>>            bio = ERR_PTR(-ENOMEM);
>>>>>> @@ -570,7 +571,10 @@ static struct bio *o2hb_setup_one_bio(struct 
>>>>>> o2hb_region *reg,
>>>>>>                 current_page, vec_len, vec_start);
>>>>> Should we check the validity of 'current_page' before 
>>>>> bio_add_page()? And
>>>>> that will prevent error happen. Others looks OK.
>>>> If I understand correctly, you mean we should check current page  is
>>>> NULL or not?
>>>> If so I think there is no need since o2hb should guarantee that it has
>>>> already reserved enough pages for disk heartbeat read/write behalf.
>>> I mean we could check if 'current_page' equals O2HB_BIO_VECS before
>>> bio_add_page() to avoid NULL pointer referrence.
>> Yes, that might work.
>> I find another problem within this patch.
>> I will post v2 patch later to fix them all with consideration about 
>> your suggestion.
>>
>> Thanks,
>> Changwei
>>
>>>
>>> thanks,
>>> Jun
>>>
>>>> Thanks,
>>>> Changwei
>>>>> thanks,
>>>>> Jun
>>>>>>            len = bio_add_page(bio, page, vec_len, vec_start);
>>>>>> -        if (len != vec_len) {
>>>>>> +        if (len == 0 && current_page == O2HB_BIO_VECS) {
>>>>>> +            /* bio is full now. */
>>>>>> +            goto bail;
>>>>>> +        } else if (len != vec_len) {
>>>>>>                mlog(ML_ERROR, "Adding page[%d] to bio failed, "
>>>>>>                     "page %p, len %d, vec_len %u, vec_start %u, "
>>>>>>                     "bi_sector %llu\n", current_page, page, len,
>>>>>>
>>>>> _______________________________________________
>>>>> Ocfs2-devel mailing list
>>>>> Ocfs2-devel at oss.oracle.com
>>>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
