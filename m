From: tristan <tristan.ye@oracle.com>
Date: Fri, 10 Sep 2010 10:31:01 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Handle empty list in
 lockres_seq_start() for dlmdebug.c
In-Reply-To: <4C8995A1.3010700@oracle.com>
References: <1284084993-7767-1-git-send-email-tristan.ye@oracle.com>
	<4C8995A1.3010700@oracle.com>
Message-ID: <4C899865.6010909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>
>
> I am assuming you have tested it. ;)

Sure, both in local mode by creating a user dlm domain, and in a cluster.

>
>
> On 09/09/2010 07:16 PM, Tristan Ye wrote:
>> This patch tries to handle the case in which list 
>> 'dlm->tracking_list' is
>> empty, to avoid accessing an invalid pointer. It fixes the following 
>> oops:
>>
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1287
>>
>> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
>> ---
>>   fs/ocfs2/dlm/dlmdebug.c |    9 ++++++++-
>>   1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
>> index 5efdd37..901ca52 100644
>> --- a/fs/ocfs2/dlm/dlmdebug.c
>> +++ b/fs/ocfs2/dlm/dlmdebug.c
>> @@ -636,8 +636,14 @@ static void *lockres_seq_start(struct seq_file 
>> *m, loff_t *pos)
>>       spin_lock(&dlm->track_lock);
>>       if (oldres)
>>           track_list =&oldres->tracking;
>> -    else
>> +    else {
>>           track_list =&dlm->tracking_list;
>> +        if (list_empty(track_list)) {
>> +            dl = NULL;
>> +            spin_unlock(&dlm->track_lock);
>> +            goto bail;
>> +        }
>> +    }
>>
>>       list_for_each_entry(res, track_list, tracking) {
>>           if (&res->tracking ==&dlm->tracking_list)
>> @@ -660,6 +666,7 @@ static void *lockres_seq_start(struct seq_file 
>> *m, loff_t *pos)
>>       } else
>>           dl = NULL;
>>
>> +bail:
>>       /* passed to seq_show */
>>       return dl;
>>   }
>>    
>
