From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 28 Jun 2013 14:38:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix readonly issue in
	ocfs2_unlink()
In-Reply-To: <51CD2494.8070300@huawei.com>
References: <51CBAC04.6010805@huawei.com>
	<20130627145855.6ed028022d3a63fa97dcee13@linux-foundation.org>
	<51CD2494.8070300@huawei.com>
Message-ID: <51CD2F6B.8010503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/28/2013 01:52 PM, Younger Liu wrote:

> On 2013/6/28 5:58, Andrew Morton wrote:
>> On Thu, 27 Jun 2013 11:05:40 +0800 Younger Liu <younger.liu@huawei.com> wrote:
>>
>>> While deleting a file with ocfs2_unlink(), there is a bug in this 
>>> function. This bug will result in filesystem read-only.
>>>
>>> After calling ocfs2_orphan_add(), the file which will be deleted 
>>> is added into orphan dir. If ocfs2_delete_entry() fails, 
>>> the file still exists in the parent dir. 
>>> And this scenario introduces a conflict of metadata.
>>>
>>> If a file is added into orphan dir, when we put inode of the file 
>>> with iput(), the inode i_flags is setted (~OCFS2_VALID_FL) in 
>>> ocfs2_remove_inode(), and then write back to disk. 
>>>
>>> But as previously mentioned, the file still exists in the parent dir.
>>> On other nodes, the file can be still accessed. When first read the file 
>>> with ocfs2_read_blocks() from disk, It will check and avalidate inode 
>>> using ocfs2_validate_inode_block(). 
>>> So File system will be readonly because the inode is invalid.
>>> In other words, the inode i_flags has been setted (~OCFS2_VALID_FL).
>>>
>>> ...
>>>
>>> --- a/fs/ocfs2/namei.c
>>> +++ b/fs/ocfs2/namei.c
>>> @@ -790,7 +790,7 @@ static int ocfs2_unlink(struct inode *dir,
>>>  			struct dentry *dentry)
>>>  {
>>>  	int status;
>>> -	int child_locked = 0;
>>> +	int child_locked = 0, is_unlinkable = 0;
>>
>> Please note that the surrounding code was carful to use the
>> one-definition-per-line convention.  That's a good convention - more
>> readable, less patch rejects during code evolution, leaves room for a
>> nice little comment.
>>
>> Also, type `bool' would have been appropraite here.
>>
>>>  	struct inode *inode = dentry->d_inode;
>>>  	struct inode *orphan_dir = NULL;
>>>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>>> @@ -873,6 +873,7 @@ static int ocfs2_unlink(struct inode *dir,
>>>  			mlog_errno(status);
>>>  			goto leave;
>>>  		}
>>> +		is_unlinkable = 1;
>>>  	}
>>>  
>>>  	handle = ocfs2_start_trans(osb, ocfs2_unlink_credits(osb->sb));
>>> @@ -892,15 +893,6 @@ static int ocfs2_unlink(struct inode *dir,
>>>  
>>>  	fe = (struct ocfs2_dinode *) fe_bh->b_data;
>>>  
>>> -	if (inode_is_unlinkable(inode)) {
>>> -		status = ocfs2_orphan_add(osb, handle, inode, fe_bh, orphan_name,
>>> -					  &orphan_insert, orphan_dir);
>>> -		if (status < 0) {
>>> -			mlog_errno(status);
>>> -			goto leave;
>>> -		}
>>> -	}
>>> -
>>>  	/* delete the name from the parent dir */
>>>  	status = ocfs2_delete_entry(handle, dir, &lookup);
>>>  	if (status < 0) {
>>> @@ -923,6 +915,14 @@ static int ocfs2_unlink(struct inode *dir,
>>>  		mlog_errno(status);
>>>  		if (S_ISDIR(inode->i_mode))
>>>  			inc_nlink(dir);
>>> +		goto leave;
>>> +	}
>>> +
>>> +	if (is_unlinkable) {
>>> +		status = ocfs2_orphan_add(osb, handle, inode, fe_bh, orphan_name,
>>> +					  &orphan_insert, orphan_dir);
>>> +		if (status < 0)
>>> +			mlog_errno(status);
>>>  	}
>>
>> This is yet another ocfs2 function which reports the same error two
>> times.  ho hum.
>>
> Thanks for your review.
> 
>> Please review:
>>
>> --- a/fs/ocfs2/namei.c~ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix
>> +++ a/fs/ocfs2/namei.c
>> @@ -790,7 +790,8 @@ static int ocfs2_unlink(struct inode *di
>>  			struct dentry *dentry)
>>  {
>>  	int status;
>> -	int child_locked = 0, is_unlinkable = 0;
>> +	int child_locked = 0;
>> +	bool is_unlinkable = false;
>>  	struct inode *inode = dentry->d_inode;
>>  	struct inode *orphan_dir = NULL;
>>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>> @@ -873,7 +874,7 @@ static int ocfs2_unlink(struct inode *di
>>  			mlog_errno(status);
>>  			goto leave;
>>  		}
>> -		is_unlinkable = 1;
>> +		is_unlinkable = true;
>>  	}
>>  
>>  	handle = ocfs2_start_trans(osb, ocfs2_unlink_credits(osb->sb));
>> @@ -919,8 +920,8 @@ static int ocfs2_unlink(struct inode *di
>>  	}
>>  
>>  	if (is_unlinkable) {
>> -		status = ocfs2_orphan_add(osb, handle, inode, fe_bh, orphan_name,
>> -					  &orphan_insert, orphan_dir);
>> +		status = ocfs2_orphan_add(osb, handle, inode, fe_bh,
>> +				orphan_name, &orphan_insert, orphan_dir);
>>  		if (status < 0)
>>  			mlog_errno(status);
>>  	}
>> _
>>
> ...
> 
> This patch looks fine to me. I also test it, and the result is fine. 
> You can consider to add:
> Reviewed-by: Younger Liu <younger.liu@huawei.com>

I'd like to have a minor change for the naming conventions of inode_is_unlinkable()
to avoid any possible conflicts to the VFS exported methods in the future, i.e,
s/inode_is_unlinkable/ocfs2_inode_is_unlinkable/

How about below changes in addition to above fix up?

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d11cf81..6708d29 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -773,7 +773,7 @@ static int ocfs2_remote_dentry_delete(struct dentry *dentry)
        return ret;
 }
 
-static inline int inode_is_unlinkable(struct inode *inode)
+static inline int ocfs2_inode_is_unlinkable(struct inode *inode)
 {
        if (S_ISDIR(inode->i_mode)) {
                if (inode->i_nlink == 2)
@@ -866,7 +866,7 @@ static int ocfs2_unlink(struct inode *dir,
                goto leave;
        }
 
-       if (inode_is_unlinkable(inode)) {
+       if (ocfs2_inode_is_unlinkable(inode)) {
                status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
                                                  OCFS2_I(inode)->ip_blkno,
                                                  orphan_name, &orphan_insert);


Thanks,
-Jeff
