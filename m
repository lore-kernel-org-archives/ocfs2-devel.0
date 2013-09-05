From: Rui Xiang <rui.xiang@huawei.com>
Date: Thu, 5 Sep 2013 09:18:20 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: return ENOMEM while sb_getblk
	failing
In-Reply-To: <20130904211611.GW31381@wotan.suse.de>
References: <1378120550-7216-1-git-send-email-rui.xiang@huawei.com>
	<20130904211611.GW31381@wotan.suse.de>
Message-ID: <5227DBDC.9040805@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/9/5 5:16, Mark Fasheh wrote:
> On Mon, Sep 02, 2013 at 07:15:49PM +0800, Rui Xiang wrote:
>> The only reason for sb_getblk() failing is if it can't allocate
>> the buffer_head. So return ENOMEM instead when it fails.
>>
>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>> ---
>>  fs/ocfs2/alloc.c        | 2 +-
>>  fs/ocfs2/aops.c         | 1 +
>>  fs/ocfs2/dir.c          | 8 ++++----
>>  fs/ocfs2/namei.c        | 2 +-
>>  fs/ocfs2/refcounttree.c | 6 +++---
>>  fs/ocfs2/suballoc.c     | 4 ++--
>>  fs/ocfs2/super.c        | 4 ++--
>>  fs/ocfs2/xattr.c        | 2 +-
>>  8 files changed, 15 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 17e6bdd..dc7411f 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -1025,7 +1025,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
>>  		for(i = count;  i < (num_got + count); i++) {
>>  			bhs[i] = sb_getblk(osb->sb, first_blkno);
>>  			if (bhs[i] == NULL) {
>> -				status = -EIO;
>> +				status = -ENOMEM;
>>  				mlog_errno(status);
>>  				goto bail;
>>  			}
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 2abf97b..ffcddfd 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -80,6 +80,7 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>>  
>>  	if ((u64)iblock >= ocfs2_clusters_to_blocks(inode->i_sb,
>>  						    le32_to_cpu(fe->i_clusters))) {
>> +		err = -ENOMEM;
>>  		mlog(ML_ERROR, "block offset is outside the allocated size: "
>>  		     "%llu\n", (unsigned long long)iblock);
>>  		goto bail;
> 
> This chunk looks out of place in this patch - it would be best to resend
> without it. Otherwise the patch looks pretty good, thanks.
> 	--Mark

Sorry for my carelessness. I'll resend it later.


Thanks.
