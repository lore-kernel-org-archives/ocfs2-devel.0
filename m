From: tristan <tristan.ye@oracle.com>
Date: Fri, 10 Sep 2010 09:42:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Handle invalid lock_res in
 lockres_seq_start() for dlmdebug.c
In-Reply-To: <4C898952.20705@oracle.com>
References: <1284023819-3883-1-git-send-email-tristan.ye@oracle.com>
	<4C891255.8060307@oracle.com> <4C8987F2.8070001@oracle.com>
	<4C898952.20705@oracle.com>
Message-ID: <4C898CF5.7000903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> On 09/09/2010 06:20 PM, tristan wrote:
>>>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
>>>> index 5efdd37..06d668a 100644
>>>> --- a/fs/ocfs2/dlm/dlmdebug.c
>>>> +++ b/fs/ocfs2/dlm/dlmdebug.c
>>>> @@ -639,6 +639,12 @@ static void *lockres_seq_start(struct seq_file 
>>>> *m, loff_t *pos)
>>>>       else
>>>>           track_list =&dlm->tracking_list;
>>>>
>>>> +    if (list_empty(track_list)) {
>>>> +        dl = NULL;
>>>> +        spin_unlock(&dlm->track_lock);
>>>> +        goto bail;
>>>> +    }
>>>> +
>>>
>>> You should add this check as part of the else block above so
>>> that we check for empty list only at the start.
>>   fs/ocfs2/dlm/dlmdebug.c |    7 +++++++
>>
>> So we just don't need to check list 'oldres->tracking'?
>
> If you see how it works, it prints one lock resource at a time. As in,
> each time _start is called, it fetches the next lock resource in the 
> tracking
> list. So the empty list should be checked only at the very beginning.
>
> To be fair, your code should also work. If the list has even one lockres,
> it cannot, by definition, be empty. But adding it in the if block 
> makes the
> check explicit and clean. IMHO.

That makes pretty sense, we just need to check the list at the time of 
getting its head:)

My check was making the logic clumsy, thanks for correction.
