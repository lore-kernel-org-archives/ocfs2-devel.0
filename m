From: Changwei Ge <gechangwei@live.cn>
Date: Tue, 8 May 2018 15:10:22 +0000
Subject: [Ocfs2-devel] [PATCH] fix a compiling warning
In-Reply-To: <eacbbf90-797f-46b6-9f68-1b8f8a67b456@suse.com>
References: <20180506094903.4331-1-lchen@suse.com>
	<5AEFA361.8060400@huawei.com>
	<eacbbf90-797f-46b6-9f68-1b8f8a67b456@suse.com>
Message-ID: <HK2PR06MB045209243B930A228F0100FCD59A0@HK2PR06MB0452.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry,

It would be better for you to paste the compilation warning and gcc version.

So we can justify if it is deserved to be fixed.


Thanks,

Changwei


On 2018/5/7 11:06 AM, Larry Chen wrote:
> Hi Jun
>
> Yeah,I know your logic is right.
> It's just a compile warning that made me feel uncomfortable.
>
> :)
>
>
>
> On 05/07/2018 08:52 AM, piaojun wrote:
>> Hi Larry,
>>
>> 'had_lock' will be initialized by ocfs2_inode_lock_tracker(), and the
>> 'bail' branch above won't use it either as 'inode_locked' is still zero.
>>
>> thanks,
>> Jun
>>
>> On 2018/5/6 17:49, Larry Chen wrote:
>>> The variable had_lock might be used uninitialized.
>>>
>>> Signed-off-by: Larry Chen <lchen@suse.com>
>>> ---
>>>    fs/ocfs2/file.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>> index 6ee94bc23f5b..50f17f56db36 100644
>>> --- a/fs/ocfs2/file.c
>>> +++ b/fs/ocfs2/file.c
>>> @@ -1133,7 +1133,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>>    	handle_t *handle = NULL;
>>>    	struct dquot *transfer_to[MAXQUOTAS] = { };
>>>    	int qtype;
>>> -	int had_lock;
>>> +	int had_lock = 0;
>>>    	struct ocfs2_lock_holder oh;
>>>    
>>>    	trace_ocfs2_setattr(inode, dentry,
>>>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
