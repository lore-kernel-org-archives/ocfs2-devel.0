From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 12 Jul 2010 09:49:59 -0700
Subject: [Ocfs2-devel] [patch] ocfs2: tighten up strlen() checking
In-Reply-To: <20100712113006.GA2393@laptop.jp.oracle.com>
References: <20100710143336.GB19184@bicker>
	<20100712113006.GA2393@laptop.jp.oracle.com>
Message-ID: <4C3B47B7.9040108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So o2dlm expects a null terminated domain name. The original
patch is good as it adds the check in o2dlm only.

For userspace, we allow non-null terminating group (domain) name.
That remains unchanged.

On 07/12/2010 04:30 AM, Wengang Wang wrote:
> Hi Dan,
>
> I think O2NM_MAX_NAME_LEN is the max valid length of the domain name.
> Regarding your patch, it changed to be that a domain name with length
> O2NM_MAX_NAME_LEN (NULL character not included) is not permitted.
>
> Though that check seems useless for current calls, we'd better keep it.
>
> Checking the structure,
>
>   99 struct ocfs2_cluster_connection {
> 100         char cc_name[GROUP_NAME_MAX];
> 101         int cc_namelen;
>
> cc_name is not a NULL tailed string. the cc_namelen specifies the length of it.
> There does is misuse of cc_name, such as
>
>
>     7    832  fs/ocfs2/stack_user.c<<user_cluster_connect>>
>               rc = dlm_new_lockspace(conn->cc_name, strlen(conn->cc_name),
>
>     5    308  fs/ocfs2/stack_o2cb.c<<o2cb_cluster_connect>>
>               dlm = dlm_register_domain(conn->cc_name, dlm_key,&fs_version);
>
> Also, the uuid shouldn't be treated as NULL tailed string.
> 142 struct ocfs2_control_message_down {
> 143         char    tag[OCFS2_CONTROL_MESSAGE_OP_LEN];
> 144         char    space1;
> 145         char    uuid[OCFS2_TEXT_UUID_LEN];
> 146         char    space2;
>
> thus,
> the calling of
> fs/ocfs2/stack_user.c:474:      ocfs2_control_send_down(msg->uuid, nodenum);
>     ->ocfs2_connection_find(uuid)
> 	->size_t len = strlen(name);
>
> is suspectable.
>
> Could you please make patch for that instead?
>
> regards,
> wengang.
>
> On 10-07-10 16:33, Dan Carpenter wrote:
>    
>> This function is only called from one place and it's like this:
>> 	dlm_register_domain(conn->cc_name, dlm_key,&fs_version);
>>
>> The "conn->cc_name" is 64 characters long.  If strlen(conn->cc_name)
>> were equal to O2NM_MAX_NAME_LEN (64) that would be a bug because
>> strlen() doesn't count the NULL character.
>>
>> In fact, if you look how O2NM_MAX_NAME_LEN is used, it mostly describes
>> 64 character buffers.  The only exception is nd_name from struct
>> o2nm_node.
>>
>> Anyway I looked into it and in this case the domain string comes from
>> osb->uuid_str in ocfs2_setup_osb_uuid().  That's 32 characters and NULL
>> which easily fits into O2NM_MAX_NAME_LEN.  This patch doesn't change how
>> the code works, but I think it makes the code a little cleaner.
>>
>> Signed-off-by: Dan Carpenter<error27@gmail.com>
>> ---
>> Or we could get rid of check entirely.
>>
>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>> index 6b5a492..084b051 100644
>> --- a/fs/ocfs2/dlm/dlmdomain.c
>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>> @@ -1671,7 +1671,7 @@ struct dlm_ctxt * dlm_register_domain(const char *domain,
>>   	struct dlm_ctxt *dlm = NULL;
>>   	struct dlm_ctxt *new_ctxt = NULL;
>>
>> -	if (strlen(domain)>  O2NM_MAX_NAME_LEN) {
>> +	if (strlen(domain)>= O2NM_MAX_NAME_LEN) {
>>   		ret = -ENAMETOOLONG;
>>   		mlog(ML_ERROR, "domain name length too long\n");
>>   		goto leave;
>>      
