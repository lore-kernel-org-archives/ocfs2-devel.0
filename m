From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 09 Jun 2010 17:29:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
	inode_setattr.
In-Reply-To: <20100609091604.GX26335@laptop>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
	<20100609091604.GX26335@laptop>
Message-ID: <4C0F5F01.8010807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Piggin <npiggin@suse.de>
Cc: ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Nick,
	Thanks for the quick response.
On 06/09/2010 05:16 PM, Nick Piggin wrote:
> On Wed, Jun 09, 2010 at 04:48:20PM +0800, Tao Ma wrote:
>> Nick has changed the turncate sequence and now inode_setattr
>> is deprecated. ocfs2 has done the most work of i_size change
>> before calling inode_setattr, so we are safe to just call
>> simple_setsize to update the i_size in vfs inode and then
>> generic_setattr.
>>
>> As for dlmfs, we don't allow inode size change, so it is safe
>> for us to just call generic_setattr.
>>
>> Cc: Nick Piggin<npiggin@suse.de>
>> Signed-off-by: Tao Ma<tao.ma@oracle.com>
>> ---
>>   fs/ocfs2/dlmfs/dlmfs.c |    2 +-
>>   fs/ocfs2/file.c        |   18 +++++++++---------
>>   2 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
>> index b83d610..e959b88 100644
>> --- a/fs/ocfs2/dlmfs/dlmfs.c
>> +++ b/fs/ocfs2/dlmfs/dlmfs.c
>> @@ -215,7 +215,7 @@ static int dlmfs_file_setattr(struct dentry *dentry, struct iattr *attr)
>>   	attr->ia_valid&= ~ATTR_SIZE;
>>   	error = inode_change_ok(inode, attr);
>>   	if (!error)
>> -		error = inode_setattr(inode, attr);
>> +		generic_setattr(inode, attr);
>
> This brings up my question again about simply _ignoring_ ATTR_SIZE changes.
> One problem is that truncate calls which send down ATTR_SIZE might also
> be sending down ATTR_MODE or ATTR_?TIME which should not be applied if
> the ATTR_SIZE fails, one would think.
>
> The other thing is that shouldn't we return -EINVAL or somesuch rather
> than silently ignoring?
>
> Anyway, several other pseudo filesystems do other stuff like tihs so
> it's not something to bother with in this patch.
yeah, it looks that we have a little chance to fail out here.
>
>
>>
>>   	return error;
>>   }
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 6a13ea6..06fd85c 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1052,17 +1052,17 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>   	}
>>
>>   	/*
>> -	 * This will intentionally not wind up calling simple_setsize(),
>> -	 * since all the work for a size change has been done above.
>> -	 * Otherwise, we could get into problems with truncate as
>> -	 * ip_alloc_sem is used there to protect against i_size
>> -	 * changes.
>> +	 * Since all the work for a size change has been done above,
>> +	 * we only need to call simple_setsize to update i_size.
>>   	 */
>> -	status = inode_setattr(inode, attr);
>> -	if (status<  0) {
>> -		mlog_errno(status);
>> -		goto bail_commit;
>> +	if (attr->ia_valid&  ATTR_SIZE) {
>> +		status = simple_setsize(inode, attr->ia_size);
>> +		if (status<  0) {
>> +			mlog_errno(status);
>> +			goto bail_commit;
>> +		}
>>   	}
>> +	generic_setattr(inode, attr);
>>
>>   	status = ocfs2_mark_inode_dirty(handle, inode, bh);
>>   	if (status<  0)
>
> simple_setsize of course calls inode_newsize_ok, which may fail. If
> you're committing your on-disk truncates at this point, you will
> prefer to hoist that check as early as possible so you cannot fail
> here.
>
We have a inode_newsize_ok check at the top of ocfs2_setattr when we do 
the real work of truncate(it is far above, so the patch can't have it. 
;) ). So we don't need to worry about that actually.
> Just open code the truncate part of simple_setsize for now.

Regards,
Tao
