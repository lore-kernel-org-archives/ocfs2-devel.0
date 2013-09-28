From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sat, 28 Sep 2013 09:39:42 -0500
Subject: [Ocfs2-devel] [PATCH 3/7] Differentiate between no_controld and
 with_controld
In-Reply-To: <20130927190232.GD26517@localhost>
References: <20130927170748.GA11716@shrek.lan>
	<20130927190232.GD26517@localhost>
Message-ID: <5246EA2E.3090405@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/27/2013 02:02 PM, Joel Becker wrote:
> On Fri, Sep 27, 2013 at 12:07:53PM -0500, Goldwyn Rodrigues wrote:
>> This is done primarily for backward compatibility. I hope we do
>> away with this sooner than later ;)
>> ---
>>   fs/ocfs2/stack_user.c | 70 ++++++++++++++++++++++++++++++++-------------------
>>   1 file changed, 44 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
>> index 2d4503b..38c69c8 100644
>> --- a/fs/ocfs2/stack_user.c
>> +++ b/fs/ocfs2/stack_user.c
>> @@ -103,6 +103,11 @@
>>   #define OCFS2_CONTROL_MESSAGE_VERNUM_LEN	2
>>   #define OCFS2_CONTROL_MESSAGE_NODENUM_LEN	8
>>
>> +enum ocfs2_connection_type {
>> +	NO_CONTROLD,
>> +	WITH_CONTROLD
>> +};
>> +
>>   /*
>>    * ocfs2_live_connection is refcounted because the filesystem and
>>    * miscdevice sides can detach in different order.  Let's just be safe.
>> @@ -110,6 +115,7 @@
>>   struct ocfs2_live_connection {
>>   	struct list_head		oc_list;
>>   	struct ocfs2_cluster_connection	*oc_conn;
>> +	enum ocfs2_connection_type	oc_type;
>>   };
>>
>>   struct ocfs2_control_private {
>> @@ -199,7 +205,8 @@ static struct ocfs2_live_connection *ocfs2_connection_find(const char *name)
>>    * fill_super(), we can't get dupes here.
>>    */
>>   static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
>> -				     struct ocfs2_live_connection **c_ret)
>> +				     struct ocfs2_live_connection **c_ret,
>> +				     enum ocfs2_connection_type type)
>>   {
>>   	int rc = 0;
>>   	struct ocfs2_live_connection *c;
>> @@ -210,8 +217,9 @@ static int ocfs2_live_connection_new(struct ocfs2_cluster_connection *conn,
>>
>>   	mutex_lock(&ocfs2_control_lock);
>>   	c->oc_conn = conn;
>> +	c->oc_type = type;
>>
>> -	if (atomic_read(&ocfs2_control_opened))
>> +	if ((type == NO_CONTROLD) || atomic_read(&ocfs2_control_opened))
>>   		list_add(&c->oc_list, &ocfs2_live_connection_list);
>>   	else {
>>   		printk(KERN_ERR
>> @@ -833,6 +841,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>>   	dlm_lockspace_t *fsdlm;
>>   	struct ocfs2_live_connection *uninitialized_var(control);
>>   	int rc = 0, ops_rv;
>> +	enum ocfs2_connection_type type = NO_CONTROLD;
>>
>>   	BUG_ON(conn == NULL);
>>
>> @@ -843,38 +852,47 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
>>   	if (rc)
>>   		goto out;
>>
>> -	if (!ops_rv) {
>> -		/* DLM lockspace creation with newer new_lockspace successful */
>> -		goto out;
>> -	} else if (ops_rv != -EOPNOTSUPP) {
>> +	if (ops_rv == -EOPNOTSUPP) {
>> +		type = WITH_CONTROLD;
>> +		printk(KERN_NOTICE "ocfs2: You seem to be using an older "
>> +				"version of dlm_controld and/or ocfs2-tools."
>> +				" Please consider upgrading.\n");
>> +	} else if (ops_rv) {
>>   		rc = ops_rv;
>>   		goto out;
>>   	}
>> -
>>   	conn->cc_lockspace = fsdlm;
>>
>> -	printk(KERN_NOTICE "ocfs2: You seem to be using an older version "
>> -			"of dlm_controld and/or ocfs2-tools. Please consider "
>> -			"upgrading.\n");
>> -
>> -	rc = ocfs2_live_connection_new(conn, &control);
>> +	rc = ocfs2_live_connection_new(conn, &control, type);
>>   	if (rc)
>>   		goto out;
>>
>> -	/*
>> -	 * running_proto must have been set before we allowed any mounts
>> -	 * to proceed.
>> -	 */
>> -	if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
>> -		printk(KERN_ERR
>> -		       "Unable to mount with fs locking protocol version "
>> -		       "%u.%u because the userspace control daemon has "
>> -		       "negotiated %u.%u\n",
>> -		       conn->cc_version.pv_major, conn->cc_version.pv_minor,
>> -		       running_proto.pv_major, running_proto.pv_minor);
>> -		rc = -EPROTO;
>> -		user_cluster_disconnect(conn);
>> -		goto out;
>> +	if (type == WITH_CONTROLD) {
>> +		/*
>> +		 * running_proto must have been set before we allowed any mounts
>> +		 * to proceed.
>> +		 */
>> +		if (fs_protocol_compare(&running_proto, &conn->cc_version)) {
>
> You need to find a way to compare the fs locking protocol in the new
> style.  Otherwise the two ocfs2 versions can't be sure they are using
> the same locks in the same way.
>

What locking protocol is it safeguarding? Is it something to do 
specifically with the OCFS2 fs, or with respect to controld set 
versioning only?

The advantage of eliminating controld is that all inter-node 
communication is handled by fs/dlm. This includes protocol negotiation.

Unfortunately, dlm with fs-controld (v3) is not compatible dlm without 
fs-controld (v4). I think they call different numbers for protocol 
versioning (v5/v6). So, all nodes will have to be upgraded anyways with 
cluster downtime.


-- 
Goldwyn
