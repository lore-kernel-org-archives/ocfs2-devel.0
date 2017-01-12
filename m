From: Gechangwei <ge.changwei@h3c.com>
Date: Thu, 12 Jan 2017 01:45:41 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2/journal: fix umount hang after
 flushing journal failure
References: <63ADC13FD55D6546B7DECE290D39E37342E73E73@H3CMLB12-EX.srv.huawei-3com.com>
	<2e92ef09-08b2-8f34-36c5-bd0a9d4f6578@gmail.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E37342E74B81@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

At the very beginning, I tried to put the quoted string within the log 
in two separated lines.

But I was alerted that:


WARNING: line over 80 characters
#21: FILE: fs/ocfs2/journal.c:2320:
+                               mlog(ML_ERROR, "journal is already abort
and cannot be "

WARNING: quoted string split across lines
#22: FILE: fs/ocfs2/journal.c:2321:
+                               mlog(ML_ERROR, "journal is already abort
and cannot be "
+                                        "flushed any more. So ignore
the pending "

WARNING: quoted string split across lines
#23: FILE: fs/ocfs2/journal.c:2322:
+                                        "flushed any more. So ignore
the pending "
+                                        "transactions to avoid blocking
ocfs2 unmount.\n");

total: 0 errors, 3 warnings, 24 lines checked

So I did like my last patch to make these warning quiet.


And I accept your suggestion that turning logging level from ML_KTHREAD
to ML_ERROR.
Also, let's make the log description like what you proposed. It may
alert system administrator strikingly.

So does this one look fine to you?


From 686b52ee2f06395c53e36e2c7515c276dc7541fb Mon Sep 17 00:00:00 2001
From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 11 Jan 2017 09:05:35 +0800
Subject: [PATCH v3] fix umount hang after journal flushing failure

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/journal.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a244f14..5f3c862 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2315,6 +2315,24 @@ static int ocfs2_commit_thread(void *arg)
                             "commit_thread: %u transactions pending on "
                             "shutdown\n",
                             atomic_read(&journal->j_num_trans));
+
+                       if (status < 0) {
+                               mlog(ML_ERROR, "journal is already abort
and cannot be "
+                                        "flushed any more. So ignore
the pending "
+                                        "transactions to avoid blocking
ocfs2 unmount.\n");
+                               /*
+                                * This may a litte hacky, however, no
chance
+                                * for ocfs2/journal to decrease this
variable
+                                * thourgh commit-thread. I have to do so to
+                                * avoid umount hang after journal flushing
+                                * failure. Since jounral has been
marked ABORT
+                                * within jbd2_journal_flush, commit
cache will
+                                * never do any real work to flush
journal to
+                                * disk.Set it to ZERO so that umount will
+                                * continue during shutting down journal
+                                */
+                               atomic_set(&journal->j_num_trans, 0);
+                       }
                }
        }

--
1.7.9.5

Thanks.
Br.
Changwei



On 2017/1/11 11:22, Joseph Qi wrote:
> The patch is malformed...
>
> BTW, I'd like ML_ERROR level log rather ML_KTHREAD, because journal
>
> abort at least should alert filesystem administrator, also this will discard
>
> some transactions.
>
> So how about:
>
> if (status < 0) {
>
>      mlog(ML_ERROR, "journal is already abort and cannot be "
>
>              "flushed any more. So ignore the pending "
>
>              " transactions to avoid blocking ocfs2 unmount.\n");
>
>      atomic_set(&journal->j_num_trans, 0);
>
> }
>
> Thanks,
> Joseph
>
> On 17/1/11 10:16, Gechangwei wrote:
>> Hi,
>>
>> As prior e-mail described, umount would hang after journal flushing failure.
>>
>> When journal flushing in ocfs2_commit_cache() fails, following umount
>> procedure at stage of shutting journal may be blocked due to non-zero
>> transactions number.
>>
>> Once jbd2_journal_flush() fails, the journal will be marked as ABORT
>> state within JBD2. There is no way to come back afterwards.
>>
>> So there is no chance to set transactions number to zero, thus, shutting
>> journal may be blocked .
>>
>> ocfs2_commit_thread()
>>
>>      ocfs2_commit_cache()
>>
>>          jbd2_journal_flush() -> failure takes journal into ABORT state,
>> thus, transaction number will never set to zero
>>
>>
>>
>> The back trace is cited blow:
>>
>> [<ffffffff8109de0c>] kthread_stop+0x4c/0x150
>> [<ffffffffc056a887>] ocfs2_journal_shutdown+0xa7/0x400 [ocfs2]
>> [<ffffffffc059fbde>] ocfs2_dismount_volume+0xbe/0x4a0 [ocfs2]
>> [<ffffffffc059fff7>] ocfs2_put_super+0x37/0xb0 [ocfs2]
>> [<ffffffff8120534e>] generic_shutdown_super+0x7e/0x110
>> [<ffffffff81205410>] kill_block_super+0x30/0x80
>> [<ffffffff81205669>] deactivate_locked_super+0x59/0x90
>> [<ffffffff812062ee>] deactivate_super+0x4e/0x70
>> [<ffffffff81222423>] cleanup_mnt+0x43/0x90
>> [<ffffffff812224c2>] __cleanup_mnt+0x12/0x20
>> [<ffffffff8109c247>] task_work_run+0xb7/0xf0
>> [<ffffffff81016f7c>] do_notify_resume+0x8c/0xa0
>> [<ffffffff817f8384>] int_signal+0x12/0x17
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>>
>> To solve this issue, I propose an improved version of patch referring to
>> Andrew's and Joseph's  comments.
>>
>> Any more comments is welcomed as always.
>>
>>
>>  From f3315307dd2a30da138383340689a81708134a44 Mon Sep 17 00:00:00 2001
>> From: Changwei Ge <ge.changwei@h3c.com>
>> Date: Wed, 11 Jan 2017 09:05:35 +0800
>> Subject: [PATCH v2] fix umount hang after journal flushing failure
>>
>> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
>> ---
>>   fs/ocfs2/journal.c |   18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index a244f14..9a6b234 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -2315,6 +2315,24 @@ static int ocfs2_commit_thread(void *arg)
>>                               "commit_thread: %u transactions pending on "
>>                               "shutdown\n",
>>                               atomic_read(&journal->j_num_trans));
>> +
>> +                       if (status < 0) {
>> +                               mlog(ML_KTHREAD,
>> +                                    "Although %u transactions left,
>> journal must be shut down right now.\n",
>> +                                    atomic_read(&journal->j_num_trans));
>> +                               /*
>> +                                * This may a litte hacky, however, no
>> chance
>> +                                * for ocfs2/journal to decrease this
>> variable
>> +                                * thourgh commit-thread. I have to do so to
>> +                                * avoid umount hang after journal flushing
>> +                                * failure. Since jounral has been
>> marked ABORT
>> +                                * within jbd2_journal_flush, commit
>> cache will
>> +                                * never do any real work to flush
>> journal to
>> +                                * disk.Set t to ZERO so that umount will
>> +                                * continue during shutting downjournal
>> +                                */
>> +                               atomic_set(&journal->j_num_trans, 0);
>> +                       }
>>                  }
>>          }
>>
>> --
>> 1.7.9.5
>>
>>
>> Thanks.
>>
>> Br.
>>
>> Changwei
>>
>>
>>
>> -------------------------------------------------------------------------------------------------------------------------------------
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ???
>> This e-mail and its attachments contain confidential information from H3C, which is
>> intended only for the person or entity whose address is listed above. Any use of the
>> information contained herein in any way (including, but not limited to, total or partial
>> disclosure, reproduction, or dissemination) by persons other than the intended
>> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
>> by phone or email immediately and delete it!
>
