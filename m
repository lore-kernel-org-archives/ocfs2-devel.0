From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue, 23 Sep 2008 09:51:59 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: unhash all dentries on a inode.
In-Reply-To: <48D8121C.20503@oracle.com>
References: <200809220948.m8M9mE0T004547@wengang.cn.oracle.com>
	<48D8121C.20503@oracle.com>
Message-ID: <48D84BBF.5060503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil,

d_prune_aliases() unhashes dentries that has 0 reference count, dentries 
with non-zero ref count won't be unhashed.
My code unhashes all no matter there reference counts are 0 or not.

regards,
wengang.

Sunil Mushran wrote:
> NAK.
>
> I fail to understand your logic. The code you've added is pretty
> much what d_prune_aliases() does (the call you have deleted).
>
> wangang wang wrote:
>> In ocfs2_process_delete_request(), we should unhash all dentries on 
>> the inode.
>> --not only the ones with 0 referrence count. so that it's possible 
>> for dput()
>> to drop the stale inode.
>>
>> the patch is against 1.2 svn.
>>
>> Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
>> -- 
>>
>> Index: fs/ocfs2/vote.c
>> ===================================================================
>> --- fs/ocfs2/vote.c    (revision 3101)
>> +++ fs/ocfs2/vote.c    (working copy)
>> @@ -176,6 +176,7 @@
>>                      int deleting_node)
>>  {
>>      int response = OCFS2_RESPONSE_BUSY;
>> +    struct list_head *tmp, *head;
>>  
>>      mlog(0, "DELETE vote on inode %lu, read lnk_cnt = %u, slot = %d\n",
>>           inode->i_ino, inode->i_nlink, *orphaned_slot);
>> @@ -253,9 +254,19 @@
>>      ocfs2_mark_inode_remotely_deleted(inode, deleting_node);
>>      spin_unlock(&OCFS2_I(inode)->ip_lock);
>>  
>> -    /* Not sure this is necessary anymore. */
>> -    d_prune_aliases(inode);
>> +    /* unhash all dentries on this inode */
>> +    spin_lock(&dcache_lock);
>> +    head = &inode->i_dentry;
>> +    tmp = head;
>>  
>> +    while ((tmp = tmp->next) != head) {
>> +        struct dentry *dentry = list_entry(tmp, struct dentry, 
>> d_alias);
>> +        spin_lock(&dentry->d_lock);
>> +        __d_drop(dentry);
>> +        spin_unlock(&dentry->d_lock);
>> +    }
>> +    spin_unlock(&dcache_lock);
>> +
>>      /* If we get here, then we're voting 'yes', so commit the
>>       * delete on our side. */
>>      response = OCFS2_RESPONSE_OK;
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>   
>

-- 
Wengang Wang
Member of Technical Staff
Oracle Asia R&D Center
Open Source Technologies Development

Tel:      +86 10 8278 6265
Mobile:   +86 13381078925
