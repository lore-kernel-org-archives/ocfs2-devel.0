From: jeff.liu <jeff.liu@oracle.com>
Date: Thu, 31 Mar 2011 19:31:05 +0800
Subject: [Ocfs2-devel] Tiny patch for cached ACLs support
In-Reply-To: <4D9449FF.7050900@oracle.com>
References: <4D943B4B.8010206@oracle.com>
	<4D943CF1.6040207@tao.ma>	<4D944097.1050903@oracle.com>
	<4D944184.9000304@tao.ma> <4D944686.6030308@oracle.com>
	<4D9449FF.7050900@oracle.com>
Message-ID: <4D9465F9.3000204@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan Ye wrote:
> jeff.liu wrote:
>> Tao Ma wrote:
>>> On 03/31/2011 04:51 PM, jeff.liu wrote:
>>>> Hi Tao,
>>>>
>>>> Tao Ma wrote:
>>>>> Hi Jeff,
>>>>> On 03/31/2011 04:28 PM, jeff.liu wrote:
>>>>>> Hello,
>>>>>>
>>>>>> Below is a tiny patch for adding cached ACLs support to OCFS2, I have run a few simple tests like
>>>>>> getacl/setacl/chacl on my single node OCFS2, it works for me.
>>>>> Your codes seem to not handle the case of cross node update? See node A
>>>>> updates ACL, node B should abandon the old one.
>>>> IMHO, cached ACLs are stored at VFS for each node instead of being synchronized among multiple
>>>> nodes, hence it doesn't need to take care of that.
>>> yes, it is stored in VFS, so we have to synchronize it like i_size and
>>> other inode stuff and that's why the user need a cluster file system.;)
>>> cached ACLs is used to speed up acl read, but not to have different acls
>>> from different nodes.
>> You are right, I'll figure out a way for the synchronization.
> 
> Hi Jeff,
> 
> 	Maybe we can do this in downconverting thread like other caches(dentry,
> file-data etc), take the 'ocfs2_refcount_convert_worker' as a reference.
Yes, I have spoke to Tao about that, downcoverting thread is a good candidate to call
forget_cached_acl().


Thanks,
-Jeff
> 
> Tristan
> 
> 
>> Thanks,
>> -Jeff
>>> Regards,
>>> Tao
>>>> Thanks,
>>>> -Jeff
>>>>> Regards,
>>>>> Tao
>>>>>> Any comments and testing are appreciated.
>>>>>>
>>>>>> Thanks,
>>>>>> -Jeff
>>>>>>
>>>>>>
>>>>>> Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
>>>>>> ---
>>>>>>  fs/ocfs2/acl.c   |   12 +++++++++++-
>>>>>>  fs/ocfs2/inode.c |    4 ++++
>>>>>>  2 files changed, 15 insertions(+), 1 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
>>>>>> index 704f6b1..13c58b0 100644
>>>>>> --- a/fs/ocfs2/acl.c
>>>>>> +++ b/fs/ocfs2/acl.c
>>>>>> @@ -152,6 +152,10 @@ static struct posix_acl *ocfs2_get_acl(struct inode *inode, int type)
>>>>>>  	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
>>>>>>  		return NULL;
>>>>>>
>>>>>> +	acl = get_cached_acl(inode, type);
>>>>>> +	if (acl != ACL_NOT_CACHED)
>>>>>> +		return acl;
>>>>>> +
>>>>>>  	ret = ocfs2_inode_lock(inode, &di_bh, 0);
>>>>>>  	if (ret < 0) {
>>>>>>  		mlog_errno(ret);
>>>>>> @@ -286,6 +290,9 @@ static int ocfs2_set_acl(handle_t *handle,
>>>>>>  	else
>>>>>>  		ret = ocfs2_xattr_set(inode, name_index, "", value, size, 0);
>>>>>>
>>>>>> +	if (!ret)
>>>>>> +		set_cached_acl(inode, type, acl);
>>>>>> +
>>>>>>  	kfree(value);
>>>>>>
>>>>>>  	return ret;
>>>>>> @@ -348,9 +355,12 @@ int ocfs2_acl_chmod(struct inode *inode)
>>>>>>  	if (!clone)
>>>>>>  		return -ENOMEM;
>>>>>>  	ret = posix_acl_chmod_masq(clone, inode->i_mode);
>>>>>> -	if (!ret)
>>>>>> +	if (!ret) {
>>>>>>  		ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
>>>>>>  				    clone, NULL, NULL);
>>>>>> +		set_cached_acl(inode, ACL_TYPE_ACCESS, clone);
>>>>>> +	}
>>>>>> +
>>>>>>  	posix_acl_release(clone);
>>>>>>  	return ret;
>>>>>>  }
>>>>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>>>>>> index 4068c6c..80deac8 100644
>>>>>> --- a/fs/ocfs2/inode.c
>>>>>> +++ b/fs/ocfs2/inode.c
>>>>>> @@ -28,6 +28,7 @@
>>>>>>  #include <linux/highmem.h>
>>>>>>  #include <linux/pagemap.h>
>>>>>>  #include <linux/quotaops.h>
>>>>>> +#include <linux/posix_acl.h>
>>>>>>
>>>>>>  #include <asm/byteorder.h>
>>>>>>
>>>>>> @@ -783,6 +784,9 @@ static int ocfs2_wipe_inode(struct inode *inode,
>>>>>>  		goto bail_unlock_dir;
>>>>>>  	}
>>>>>>
>>>>>> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL)
>>>>>> +		forget_all_cached_acls(inode);
>>>>>> +
>>>>>>  	status = ocfs2_remove_refcount_tree(inode, di_bh);
>>>>>>  	if (status < 0) {
>>>>>>  		mlog_errno(status);
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
