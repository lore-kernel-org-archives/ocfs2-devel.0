From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 09 Apr 2010 12:28:00 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Optimize punching-hole codes
 v4.
In-Reply-To: <4BBEAA9C.5040408@oracle.com>
References: <1270724553-2621-1-git-send-email-tristan.ye@oracle.com>
	<4BBDEE98.8030005@oracle.com> <4BBE8938.5000305@oracle.com>
	<4BBE917F.5060506@oracle.com> <4BBEAA9C.5040408@oracle.com>
Message-ID: <4BBEACD0.9030103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



tristan wrote:
> Tao Ma wrote:
>> Hi Tristan,
>>
>> tristan wrote:
>>> Tao,
>>>
>>> Thanks a lot for your quick review;)
>>>
>>> Tao Ma wrote:
>>>> Hi Tristan,
>>>> Tristan Ye wrote:
>>>>> Changes from v3 to v4:
>>>>>
>>>>> 1. Fix a bug when crossing extent blocks.
>>>>>
>>>>> 2. Fix a bug when hole exists in the beginning of an extent block.
>>>>>
>>>>> 3. Apply tao's comments.
>>>>>
>>>>>
>>>>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>>>>> ---
>>>>>  fs/ocfs2/file.c |  233 
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>>>>  1 files changed, 206 insertions(+), 27 deletions(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>>>> index db2e0c9..75e087f 100644
>>>>> --- a/fs/ocfs2/file.c
>>>>> +++ b/fs/ocfs2/file.c
>>>>> @@ -1423,18 +1423,154 @@ out:
>>>>>      return ret;
>>>>>  }
>>>>>  
>>>>> +static void ocfs2_find_rec(struct ocfs2_extent_list *el,
>>>>> +               struct ocfs2_extent_rec **rec_found,
>>>>> +               u32 *pos)
>>>>> +{
>>>>> +    int i, found = 0;
>>>>> +    struct ocfs2_extent_rec *rec = NULL;
>>>>> +
>>>>> +    for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>>>>> +
>>>>> +        rec = &el->l_recs[i];
>>>>> +
>>>>> +        if (le32_to_cpu(rec->e_cpos) <= *pos) {
>>>>> +            found = 1;
>>>>> +            break;
>>>>> +        }
>>>>> +    }
>>>>> +
>>>>> +    if (!found)
>>>>> +        *rec_found = NULL;
>>>>> +    else
>>>>> +        *rec_found = &el->l_recs[i];
>>>>> +}
>>>>>   
>>>> This function never returns pos now. So why you want to pass a *pos?
>>>> another issue is that now it seems that you only want to returns a rec?
>>>> then why not change this function to
>>>> static int ocfs2_find_rec(struct ocfs2_extent_list *el, u32 pos)
>>>
>>> Yes, it's confusing to use *pos, thanks for pointing this out.
>>>
>>>> and after the loop, just return i. So if i>=0, you find it, if i < 
>>>> 0, no rec is found. Looks more natural?
>>>
>>> I think returning  a meaty record would be more straightforward.
>> why? actually as I have said below, these 2 functions ocfs2_find_rec 
>> and ocfs2_find_rec_with_holes can be integrated into one function 
>> named ocfs2_find_rec or whatever. You are too nervous about holes 
>> actually.
> 
> Hole still needs to be handled, while I may over-treat this  a little bit.
> 
> I'll try to merge the 2 funcs into one.
>> So
>> static int ocfs2_find_rec(struct ocfs2_extent_list *el, u32 pos)
>> {
>>     int i;
>>     struct ocfs2_extent_rec *rec = NULL;
>>
>>     for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>>         rec = &el->l_recs[i];
>>
>>         if (le32_to_cpu(rec->e_cpos) < pos)
>>             break;
>>     }
>>
>>     return i;
>> }
> 
> Not enough,
> 
> cases about 'we didn't find a rec' and 'we find rec[0]' both return i=0;
what do you mean? If we can't find a rec, i will be set to -1, so we 
will return '-1'. It is the rule of 'for'.

Regards,
Tao
