From: Jan Kara <jack@suse.cz>
Date: Tue, 20 Oct 2009 10:26:06 +0200
Subject: [Ocfs2-devel] [PATCH 2/5] Implement support for quota changes
	in libocfs2
In-Reply-To: <4ADD5D64.4020200@oracle.com>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
	<1255543739-23844-3-git-send-email-jack@suse.cz>
	<4ADD5D64.4020200@oracle.com>
Message-ID: <20091020082606.GA1553@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 20-10-09 14:49:08, Tristan wrote:
> Jan Kara wrote:
>> Implement some common functions for changing quotas in libocfs2
>> so that they don't have to be reimplemented in several users.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
...
>>  +errcode_t ocfs2_init_quota_change(ocfs2_filesys *fs,
>> +				  ocfs2_quota_hash **usrhash,
>> +				  ocfs2_quota_hash **grphash)
>> +{
>> +	errcode_t err;
>> +
>> +	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
>> +					OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
>> +		err = ocfs2_new_quota_hash(usrhash);
>> +		if (err)
>> +			return err;
>>   
> no need to free 'usrhash' as well as following 'grphash'?
>> +	}
>> +	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
>> +					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
>> +		err = ocfs2_new_quota_hash(grphash);
>> +		if (err) {
>> +			ocfs2_free_quota_hash(*usrhash);
>>   
> shouldn't it be:
>
> ocfs2_free_quota_hash(*grphash);
  ocfs2_new_quota_hash fails when it cannot allocate memory. Thus there's
nothing to cleanup in that hash. But if we failed to allocate the second
hash, we have to free the first one. So the code is correct in this regard.
  But there's a bug that *usrhash and *grphash should be initialized to
NULL. Fixed now.

>> +errcode_t ocfs2_finish_quota_change(ocfs2_filesys *fs,
>> +				    ocfs2_quota_hash *usrhash,
>> +				    ocfs2_quota_hash *grphash)
>> +{
>> +	errcode_t ret = 0, err;
>> +
>> +	if (usrhash) {
>> +		err = ocfs2_write_release_dquots(fs, USRQUOTA, usrhash);
>> +		if (!ret)
>> +			ret = err;
>>   
> There is no need to judge 'ret' here since it was always zero without any 
> re-assignment. the same goes for other 'if' statement in this function.
  Well, it was there to make the code more symmetric but ok, changed that.

  I'll wait whether someone has other comments and post the updated series
next week. Thanks for the review.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
