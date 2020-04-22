From: Wu Bo <wubo40@huawei.com>
Date: Wed, 22 Apr 2020 15:59:49 +0800
Subject: [Ocfs2-devel] [PATCH] fs:ocfs2:remove unneeded variable
	'o2dlm_flags'
In-Reply-To: <7214599d-3bd2-96b7-59f9-d731bb27f744@linux.alibaba.com>
References: <1587539521-461177-1-git-send-email-wubo40@huawei.com>
	<7214599d-3bd2-96b7-59f9-d731bb27f744@linux.alibaba.com>
Message-ID: <9bf0798a-7dd5-4328-68f5-8bc2cd2ffa99@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, liuzhiqiang26@huawei.com, linfeilong@huawei.com

On 2020/4/22 15:52, Joseph Qi wrote:
> 
> 
> On 2020/4/22 15:12, Wu Bo wrote:
>> Fix the following coccicheck warning:
>> fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: "o2dlm_flags".
>> Return "0" on line 84
>>
> Umm... This is not right, NAK.
> Something tricky is in map_flag() so that coccicheck doesn't recognize.
> 
> Thanks,
> Joseph

You are right. Did not notice that map_flag is a macro, Please ignore 
this patch.

Thanks,
Wu Bo

> 
>> Signed-off-by: Wu Bo <wubo40@huawei.com>
>> ---
>>   fs/ocfs2/stack_o2cb.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
>> index dbf8b57..2da9633 100644
>> --- a/fs/ocfs2/stack_o2cb.c
>> +++ b/fs/ocfs2/stack_o2cb.c
>> @@ -66,8 +66,6 @@ static inline int mode_to_o2dlm(int mode)
>>   	}
>>   static int flags_to_o2dlm(u32 flags)
>>   {
>> -	int o2dlm_flags = 0;
>> -
>>   	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
>>   	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
>>   	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
>> @@ -81,7 +79,7 @@ static int flags_to_o2dlm(u32 flags)
>>   	/* map_flag() should have cleared every flag passed in */
>>   	BUG_ON(flags != 0);
>>   
>> -	return o2dlm_flags;
>> +	return 0;
>>   }
>>   #undef map_flag
>>   
>>
> 
> .
> 
