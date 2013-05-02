From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu, 02 May 2013 13:00:48 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix possible memory leak in
	dlm_process_recovery_data
In-Reply-To: <5181DA05.5020405@huawei.com>
References: <51182BCE12D4834EA8164B99A509EABB32CDA65F@szxeml521-mbs.china.huawei.com>
	<5181DA05.5020405@huawei.com>
Message-ID: <5181F300.6090007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Qijiang,

Thanks for your patch.

On 05/02/2013 11:14 AM, Li Zefan wrote:
> This patch is mangled. Please read Documentation/email-clients.txt and configure
> your email client properly, and then re-send the patch.
> 
> On 2013/5/1 12:06, Qijiang (Joseph) wrote:
>>   We create newlock each time in dlm_process_recovery_data, but we don't free it when it is bad, and then it will lead to memory leak.
> 
> The leading spaces are not need, and please break into lines within 80 characters.
> (or 72 to be more strict)
Yes, it's better to break the description up to 72 bytes per line.
> 
>>
>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>>
>> ---
>>  fs/ocfs2/dlm/dlmrecovery.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index eeac97b..93de2e0 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -1974,6 +1974,12 @@ skip_lvb:
>>                  res->lockname.len, res->lockname.name, ml->node);
>>             dlm_lockres_set_refmap_bit(dlm, res, ml->node);
>>             added++;
>> +       } else {
>> +           /* should free newlock if it is bad */
		/* Free the new lock if it is bad */
>> +           if (newlock) {
Hmm? newlock should must be allocated come to this point, so we don't need to
check it up again. 
>> +               dlm_lock_put(newlock);
>> +               newlock = NULL;
>> +           }
>>         }
>>         spin_unlock(&res->spinlock);
>>     }
Otherwise this patch looks good to me, you can add:
Reviewed-by: Jie Liu <jeff.liu@oracle.com>

BTW, looks your original post was ate by the mailing list somehow
since I can not found it out from OCFS2-DEV archives of May:
https://oss.oracle.com/pipermail/ocfs2-devel/2013-May/thread.html

There should be something wrong with the mailing list but not yours.:)

In order to avoid missing any upstream patch, could you please add
"Andrew Morton <akpm@linux-foundation.org>" as well as OCFS2 maintainers
(Joel & Mark) to the Cc list for the next round?  

Recently we have follow up a new process for syncing up OCFS2 upstream patches:
Andrew will help us merging patch to MM tree once it got an "Acked-by" from
Joel and Mark.

Thanks,
-Jeff
