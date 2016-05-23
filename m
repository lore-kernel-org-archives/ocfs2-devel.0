From: Gang He <ghe@suse.com>
Date: Sun, 22 May 2016 23:33:52 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a redundant re-initialization
In-Reply-To: <57427598.9060000@huawei.com>
References: <1463970605-18354-1-git-send-email-zren@suse.com>
	<57427598.9060000@huawei.com>
Message-ID: <574306C0020000F900038250@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com




>>> 
> On 2016/5/23 10:30, Eric Ren wrote:
>> Obviously, memset() has zeroed the whole struct locking_max_version.
>> So, it's no need to zero its two fields individually.
>> 
>> Signed-off-by: Eric Ren <zren@suse.com>
> Looks good, thanks.
> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Gang He <ghe@suse.com>

> 
>> ---
>>  fs/ocfs2/stackglue.c | 2 --
>>  1 file changed, 2 deletions(-)
>> 
>> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
>> index 5d965e8..855fb44 100644
>> --- a/fs/ocfs2/stackglue.c
>> +++ b/fs/ocfs2/stackglue.c
>> @@ -734,8 +734,6 @@ static void __exit ocfs2_stack_glue_exit(void)
>>  {
>>  	memset(&locking_max_version, 0,
>>  	       sizeof(struct ocfs2_protocol_version));
>> -	locking_max_version.pv_major = 0;
>> -	locking_max_version.pv_minor = 0;
>>  	ocfs2_sysfs_exit();
>>  	if (ocfs2_table_header)
>>  		unregister_sysctl_table(ocfs2_table_header);
>> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
