From: Eric Ren <zren@suse.com>
Date: Mon, 12 Sep 2016 11:06:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix deadlock on mmapped page in
 ocfs2_write_begin_nolock()
In-Reply-To: <5170a92c-caaf-be47-3ef8-ab9803e7a6c4@suse.com>
References: <1473501335-12519-1-git-send-email-zren@suse.com>
	<57D606EA.5010009@huawei.com>
	<5170a92c-caaf-be47-3ef8-ab9803e7a6c4@suse.com>
Message-ID: <ec1e0839-e1d7-57e2-a349-491236edfb59@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
>> IMO, in ocfs2_grab_pages_for_write, mmap_page is mapping to w_pages and
>> w_target_locked is set to true, and then will be unlocked by
>> ocfs2_unlock_pages in ocfs2_free_write_ctxt.
>> So I'm not getting the case "page isn't unlock". Could you please explain
>> it in more detail?
> Thanks for review;-) Follow up the calling chain:
>
> ocfs2_free_write_ctxt()
>  ->ocfs2_unlock_pages()
>
> in ocfs2_unlock_pages 
> (https://github.com/torvalds/linux/blob/master/fs/ocfs2/aops.c#L793), we
> can see the code just put_page(target_page), but not unlock it.
>
> Yeah, I will think this a bit more like:
> why not unlock the target_page there? Is there other potential problems if the "ret" is 
> not "-ENOSPC" but
> other possible error code?
1. ocfs2_unlock_pages() will be called in ocfs2_write_end_nolock(), in this case, we 
definitely want to return a locked mmaped page
to VM code (do_page_mkwrite) when VM_FAULT_LOCKED is set.

2. But there's indeed a potential existing deadlock situation:
                                ocfs2_grab_pages_for_write()  ==> return -ENOMEM and with 
the mmaped page locked
                                ocfs2_free_write_ctxt() ==> leave the mmapped page locked
                          ocfs2_write_begin_nolock() ==> return -ENOMEM
                    __ocfs2_page_mkwrite() ==> return VM_FAULT_OMM
              __do_page_mkwrite() ==> deadlock here 
(https://github.com/torvalds/linux/blob/master/mm/memory.c#L2054)
This is another corner case, right?

Anyway, I think this patch is good for the -ENOSPC case. And another patch should be 
proposed for -ENOMEM case?

Thanks,
Eric

>
> Thanks,
> Eric
>
>>
>> Thanks,
>> Joseph
>>
>>> Fix this issue by unlocking the target page after we fail to allocate
>>> enough space at the first time.
>>>
>>> Jan Kara helps me clear out the JBD2 part, and suggest the hint for root cause.
>>>
>>> Signed-off-by: Eric Ren <zren@suse.com>
>>> ---
>>>   fs/ocfs2/aops.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index 98d3654..78d1d67 100644
>>> --- a/fs/ocfs2/aops.c
>>> +++ b/fs/ocfs2/aops.c
>>> @@ -1860,6 +1860,13 @@ out:
>>>            */
>>>           try_free = 0;
>>>   +        /*
>>> +         * Unlock mmap_page because the page has been locked when we
>>> +         * are here.
>>> +         */
>>> +        if (mmap_page)
>>> +            unlock_page(mmap_page);
>>> +
>>>           ret1 = ocfs2_try_to_free_truncate_log(osb, clusters_need);
>>>           if (ret1 == 1)
>>>               goto try_again;
>>>
>>
>>
>
>
