From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 2 Mar 2018 01:59:16 +0000
Subject: [Ocfs2-devel] [PATCH] Correct a comment error
References: <20180228101720.20725-1-lchen@suse.com>
	<5A97F88E.4010303@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F292C0FC@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: piaojun <piaojun@huawei.com>, Larry Chen <lchen@suse.com>, "mfasheh@versity.com" <mfasheh@versity.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

Hi Jun,
I think the comments for both two functions are OK.
No need to rework them.
As we know, ocfs2 lock name(lock id) are composed of several parts including 
block number.

Thanks,
Changw2ei

On 2018/3/1 20:58, piaojun wrote:
> Hi Larry,
> 
> There is the same mistake in ocfs2_reflink_inodes_lock(), could you help
> fixing them all?
> 
> thanks,
> Jun
> 
> On 2018/2/28 18:17, Larry Chen wrote:
>> The function ocfs2_double_lock tries to lock the inode with lower
>> blockid first, not lockid.
>>
>> Signed-off-by: Larry Chen <lchen@suse.com>
>> ---
>>   fs/ocfs2/namei.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index c801eddc4bf3..30d454de35a8 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -1133,7 +1133,7 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
>>   	if (*bh2)
>>   		*bh2 = NULL;
>>   
>> -	/* we always want to lock the one with the lower lockid first.
>> +	/* we always want to lock the one with the lower blockid first.
>>   	 * and if they are nested, we lock ancestor first */
>>   	if (oi1->ip_blkno != oi2->ip_blkno) {
>>   		inode1_is_ancestor = ocfs2_check_if_ancestor(osb, oi2->ip_blkno,
>>
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
