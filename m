From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 14 Sep 2016 16:25:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock on mmapped page in
 ocfs2_write_begin_nolock()
In-Reply-To: <d1bae3b5-50b3-a79a-8c21-14bc644e7071@suse.com>
References: <1473501335-12519-1-git-send-email-zren@suse.com>
	<57D606EA.5010009@huawei.com>
	<5170a92c-caaf-be47-3ef8-ab9803e7a6c4@suse.com>
	<d1bae3b5-50b3-a79a-8c21-14bc644e7071@suse.com>
Message-ID: <57D90981.4080504@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,
Sorry for the delayed response.
I have got your explanation. So we have to unlock the page only in case
of retry, right?
If so, I think the unlock should be right before "goto try_again".

Thanks,
Joseph

On 2016/9/14 16:04, Eric Ren wrote:
> Hi Joseph,
>>>> In ocfs2_write_begin_nolock(), we first grab the pages and then
>>>> allocate disk space for this write; ocfs2_try_to_free_truncate_log()
>>>> will be called if ENOSPC is turned; if we're lucky to get enough clusters,
>>>> which is usually the case, we start over again. But in ocfs2_free_write_ctxt()
>>>> the target page isn't unlocked, so we will deadlock when trying to grab
>>>> the target page again.
>>> IMO, in ocfs2_grab_pages_for_write, mmap_page is mapping to w_pages and
>>> w_target_locked is set to true, and then will be unlocked by
>>> ocfs2_unlock_pages in ocfs2_free_write_ctxt.
>>> So I'm not getting the case "page isn't unlock". Could you please explain
>>> it in more detail?
>> Thanks for review;-) Follow up the calling chain:
>>
>> ocfs2_free_write_ctxt()
>>  ->ocfs2_unlock_pages()
>>
>> in ocfs2_unlock_pages (https://github.com/torvalds/linux/blob/master/fs/ocfs2/aops.c#L793), we
>> can see the code just put_page(target_page), but not unlock it.
> Did this answer your question?
> 
> Thanks,
> Eric
>>
>> Yeah, I will think this a bit more like:
>> why not unlock the target_page there? Is there other potential problems if the "ret" is not "-ENOSPC" but
>> other possible error code?
>>
>> Thanks,
>> Eric
>>
>>>
>>> Thanks,
>>> Joseph
>>>
>>>> Fix this issue by unlocking the target page after we fail to allocate
>>>> enough space at the first time.
>>>>
>>>> Jan Kara helps me clear out the JBD2 part, and suggest the hint for root cause.
>>>>
>>>> Signed-off-by: Eric Ren <zren@suse.com>
>>>> ---
>>>>   fs/ocfs2/aops.c | 7 +++++++
>>>>   1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>>> index 98d3654..78d1d67 100644
>>>> --- a/fs/ocfs2/aops.c
>>>> +++ b/fs/ocfs2/aops.c
>>>> @@ -1860,6 +1860,13 @@ out:
>>>>            */
>>>>           try_free = 0;
>>>>   +        /*
>>>> +         * Unlock mmap_page because the page has been locked when we
>>>> +         * are here.
>>>> +         */
>>>> +        if (mmap_page)
>>>> +            unlock_page(mmap_page);
>>>> +
>>>>           ret1 = ocfs2_try_to_free_truncate_log(osb, clusters_need);
>>>>           if (ret1 == 1)
>>>>               goto try_again;
>>>>
>>>
>>>
>>
>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
