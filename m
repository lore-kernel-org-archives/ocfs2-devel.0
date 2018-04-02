From: Changwei Ge <ge.changwei@h3c.com>
Date: Mon, 2 Apr 2018 06:15:30 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: wait for dlm recovery done
 when migrating all lock resources
References: <5AAA6E25.7090303@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F295AB8A@H3CMLB12-EX.srv.huawei-3com.com>
	<5AC1B230.4070409@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F295AD08@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2018/4/2 12:32, piaojun wrote:
> Hi Changwei,
> 
> On 2018/4/2 10:59, Changwei Ge wrote:
>> Hi Jun,
>>
>> It seems that you have ever posted this patch, If I remember correctly.
>> My concern is still if you disable dlm recovery via ::migrate_done. Then flag
>> DLM_LOCK_RES_RECOVERING can't be cleared.
> After I set migrate_done, all lockres had been migrated. So there won't be
> any lockres with DLM_LOCK_RES_RECOVERING. And I have tested this patch for
> a few months.

Oops,
Yes, it makes sense.

> 
> thanks,
> Jun
>>
>> So we can't purge the problematic lock resource since __dlm_lockres_unused()
>> needs to check that flag.
>>
>> Finally, umount will run the while loop in dlm_migrate_all_locks() infinitely.
>> Or if I miss something?
>>
>> Thanks,
>> Changwei
>>
>> On 2018/3/15 21:00, piaojun wrote:

>>>
>>> Fixes: bc9838c4d44a ("dlm: allow dlm do recovery during shutdown")
>>>
>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>> Reviewed-by: Alex Chen <alex.chen@huawei.com>
>>> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Acked-by: Changwei Ge <ge.changwei@h3c.com>

>>> ---
>>>    fs/ocfs2/dlm/dlmcommon.h   |  1 +
>>>    fs/ocfs2/dlm/dlmdomain.c   | 15 +++++++++++++++
>>>    fs/ocfs2/dlm/dlmrecovery.c | 13 ++++++++++---
>>>    3 files changed, 26 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
