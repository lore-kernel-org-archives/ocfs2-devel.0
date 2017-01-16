From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 16 Jan 2017 08:50:01 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2/journal: fix umount hang after
 flushing journal failure
In-Reply-To: <9cbdb212-898f-deff-bac8-e3ea7f6ec8f3@suse.com>
References: <63ADC13FD55D6546B7DECE290D39E37342E74EAD@H3CMLB12-EX.srv.huawei-3com.com>
	<9cbdb212-898f-deff-bac8-e3ea7f6ec8f3@suse.com>
Message-ID: <8a3b9067-2b3b-6a34-dcd7-ffe961ef061a@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Ren <zren@suse.com>, Changwei Ge <ge.changwei@h3c.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 17/1/13 20:37, Eric Ren wrote:
> On 01/13/2017 10:52 AM, Changwei Ge wrote:
>> Hi Joseph,
>>
>> Do you think my last version of patch to fix umount hang after journal
>> flushing failure is OK?
>>
>> If so, I 'd like to ask Andrew's help to merge this patch into his test
>> tree.
>>
>>
>> Thanks,
>>
>> Br.
>>
>> Changwei
>
> The message above should not occur in a formal patch.  It should be 
> put in "cover-letter" if
> you want to say something to the other developers. See "git 
> format-patch --cover-letter".
>
>>
>>
>>
>>  From 686b52ee2f06395c53e36e2c7515c276dc7541fb Mon Sep 17 00:00:00 2001
>> From: Changwei Ge <ge.changwei@h3c.com>
>> Date: Wed, 11 Jan 2017 09:05:35 +0800
>> Subject: [PATCH] fix umount hang after journal flushing failure
>
> The commit message is needed here! It should describe what's your 
> problem, how to reproduce it,
> and what's your solution, things like that.
>
>>
>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>   fs/ocfs2/journal.c |   18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index a244f14..5f3c862 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -2315,6 +2315,24 @@ static int ocfs2_commit_thread(void *arg)
>>                               "commit_thread: %u transactions pending 
>> on "
>>                               "shutdown\n",
>> atomic_read(&journal->j_num_trans));
>> +
>> +                       if (status < 0) {
>> +                               mlog(ML_ERROR, "journal is already abort
>> and cannot be "
>> +                                        "flushed any more. So ignore
>> the pending "
>> +                                        "transactions to avoid blocking
>> ocfs2 unmount.\n");
>
> Can you find any example in the kernel source to print out message 
> like that?!
>
> I saw Joseph showed you the right way in previous email:
> "
>
> if (status < 0) {
>
>      mlog(ML_ERROR, "journal is already abort and cannot be "
>
>              "flushed any more. So ignore the pending "
>
>              "transactions to avoid blocking ocfs2 unmount.\n");
>
> "
> So, please be careful and learn from the kernel source and the right 
> way other developers do in
> their patch work. Otherwise, it's meaningless to waste others' time in 
> such basic issues.
>
>> +                               /*
>> +                                * This may a litte hacky, however, no
>> chance
>> +                                * for ocfs2/journal to decrease this
>> variable
>> +                                * thourgh commit-thread. I have to 
>> do so to
>> +                                * avoid umount hang after journal 
>> flushing
>> +                                * failure. Since jounral has been
>> marked ABORT
>> +                                * within jbd2_journal_flush, commit
>> cache will
>> +                                * never do any real work to flush
>> journal to
>> +                                * disk.Set it to ZERO so that umount 
>> will
>> +                                * continue during shutting down journal
>> +                                */
>> + atomic_set(&journal->j_num_trans, 0);
> It's possible to corrupt data doing this way. Why not just crash the 
> kernel when jbd2 aborts?
> and let the other node to do the journal recovery. It's the strength 
> of cluster filesystem.
We shouldn't crash kernel directly, which will enlarge the impact of the
issue. For example, we have mount multiple volumes and only one has this
error occurred.
But I do agree with you that we have to let other nodes know the
abnormal exit and do the recovery, which can ensure the data
consistency.

Thanks,
Joseph
>
> Anyway, it's glad to see you guys making contributions!
>
> Thanks,
> Eric
>
>
>> +                       }
>>                  }
>>          }
>>
>> -- 
>> 1.7.9.5
>>
>> ------------------------------------------------------------------------------------------------------------------------------------- 
>>
>> ???????????????????????????????????????? 
>>
>> ???????????????????????????????????????? 
>>
>> ???????????????????????????????????????? 
>>
>> ???
>> This e-mail and its attachments contain confidential information from 
>> H3C, which is
>> intended only for the person or entity whose address is listed above. 
>> Any use of the
>> information contained herein in any way (including, but not limited 
>> to, total or partial
>> disclosure, reproduction, or dissemination) by persons other than the 
>> intended
>> recipient(s) is prohibited. If you receive this e-mail in error, 
>> please notify the sender
>> by phone or email immediately and delete it!
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
