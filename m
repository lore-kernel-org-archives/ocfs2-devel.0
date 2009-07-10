From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 10 Jul 2009 14:51:25 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] a fix of logging return value.
In-Reply-To: <4A56E259.2030903@oracle.com>
References: <200907100528.n6A5Sv4J030693@acsinet15.oracle.com>	<3A2AA175-B34E-4A01-8B9E-45361846B18C@oracle.com>	<4A56DE0F.3050009@oracle.com>
	<4A56E259.2030903@oracle.com>
Message-ID: <4A56E4ED.60101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi wengang,

Wengang Wang wrote:
> Sunil,
> 
> in the src, I see both mlog(ML_ERROR...)(finally printk(KERN_ERR...)) 
> and ocfs2_error()(finally printk(KERN_CRIT...).
> could you tell me in what case one should be used?
mlog(ML_ERROR...) only print errors. But ocfs2_error does other things, 
sometimes make the volume readonly. Please check ocfs2_handle_error for 
details.

Regards,
Tao
> 
> regards,
> wengang.
> 
> Wengang Wang wrote:
>> Hi Sunil,
>>
>> Ok. I will post patche(s) for it later.
>>
>> regards,
>> wengang.
>>
>> Sunil Mushran wrote:
>>> sob
>>>
>>> Hi Wengang, functions is aops.c are missing mlogs. Do you have the 
>>> bandwidth to help out?
>>>
>>> On Jul 9, 2009, at 10:26 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
>>>
>>>>    in ocfs2_file_aio_write(), log_exit() could don't log the value
>>>> which is really returned. this patch fixes it.
>>>>
>>>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>>>> ---
>>>> fs/ocfs2/file.c |    4 +++-
>>>> 1 files changed, 3 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>>> index 62442e4..a49fa44 100644
>>>> --- a/fs/ocfs2/file.c
>>>> +++ b/fs/ocfs2/file.c
>>>> @@ -1918,8 +1918,10 @@ out_sems:
>>>>
>>>>    mutex_unlock(&inode->i_mutex);
>>>>
>>>> +    if (written)
>>>> +        ret = written;
>>>>    mlog_exit(ret);
>>>> -    return written ? written : ret;
>>>> +    return ret;
>>>> }
>>>>
>>>> static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
>>>> -- 
>>>> 1.6.2.5
>>>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
