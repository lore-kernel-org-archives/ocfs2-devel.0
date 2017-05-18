From: Gang He <ghe@suse.com>
Date: Thu, 18 May 2017 04:43:39 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: give an obvious tip for dismatch
 cluster names
In-Reply-To: <e1f15ab4-c9ad-8f65-95bc-45c05aea6cf9@gmail.com>
References: <1495089336-19312-1-git-send-email-ghe@suse.com>
	<e1f15ab4-c9ad-8f65-95bc-45c05aea6cf9@gmail.com>
Message-ID: <591DEB5B020000F900076CAE@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org, jiangqi903@gmail.com, mfasheh@versity.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Joseph,


>>> 
> Hi Gang,
> 
> How can we confirm EBADR is only because cluster name mismatch?
> Since the cluster stack may be o2cb(o2dlm) or user(fsdlm).
I looked through all the code of OCFS2 (include o2cb), there is not any place which returns this error.
In fact, the function calling patch ocfs2_fill_super -> ocfs2_mount_volume -> ocfs2_dlm_init -> dlm_new_lockspace
is very specific path, we can use this errorno to give the uses a more clear tip, 
since this case looks like a little common during cluster migration, but the customer can quickly
get the failure cause if there is a error printing.
Also, I think there is not possible to add this errorno in o2cb path during ocfs2_dlm_init, since o2cb code has been stable for 
a long time.   

Thanks
Gang

> 
> Thanks,
> Joseph
> 
> On 17/5/18 14:35, Gang He wrote:
>> This patch is used to add an obvious error message, due to
>> dismatch cluster names between on-disk and in the current cluster.
>> We can meet this case during OCFS2 cluster migration, if we can
>> give the user an obvious tip for why they can not mount the file
>> system after migration, they can quickly fix this dismatch problem.
>> Second, also move printing ocfs2_fill_super() errno to the front
>> of ocfs2_dismount_volume() function, since ocfs2_dismount_volume()
>> will also print it's own message.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/super.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index ca1646f..5575918 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -1208,14 +1208,15 @@ static int ocfs2_fill_super(struct super_block *sb, 
> void *data, int silent)
>>  read_super_error:
>>  	brelse(bh);
>>  
>> +	if (status)
>> +		mlog_errno(status);
>> +
>>  	if (osb) {
>>  		atomic_set(&osb->vol_state, VOLUME_DISABLED);
>>  		wake_up(&osb->osb_mount_event);
>>  		ocfs2_dismount_volume(sb, 1);
>>  	}
>>  
>> -	if (status)
>> -		mlog_errno(status);
>>  	return status;
>>  }
>>  
>> @@ -1843,6 +1844,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
>>  	status = ocfs2_dlm_init(osb);
>>  	if (status < 0) {
>>  		mlog_errno(status);
>> +		if (status == -EBADR)
>> +			mlog(ML_ERROR, "couldn't mount because cluster name on"
>> +			" disk does not match the running cluster name.\n");
>>  		goto leave;
>>  	}
>>  
>> 
