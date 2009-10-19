From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Oct 2009 08:55:55 +0200
Subject: [Ocfs2-devel] [PATCH 4/5] Convert disabling of sparse feature
	to use new	code in libocfs2
In-Reply-To: <4AD82BF6.4030802@oracle.com>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
	<1255543739-23844-5-git-send-email-jack@suse.cz>
	<4AD82BF6.4030802@oracle.com>
Message-ID: <20091019065555.GA31860@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 16-10-09 16:16:54, Tristan wrote:
> Jan Kara wrote:
>> Make code handling update of quota information when disabling
>> sparse feature use new generic code in libocfs2.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  tunefs.ocfs2/feature_sparse_files.c |  100 ++++++----------------------------
>>  1 files changed, 18 insertions(+), 82 deletions(-)
>>
>> diff --git a/tunefs.ocfs2/feature_sparse_files.c b/tunefs.ocfs2/feature_sparse_files.c
>> index d4dff34..4f8c0db 100644
>> --- a/tunefs.ocfs2/feature_sparse_files.c
>> +++ b/tunefs.ocfs2/feature_sparse_files.c
>> @@ -448,8 +448,6 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
>>  	struct list_head *pos;
>>  	struct sparse_file *file;
>>  	struct tools_progress *prog;
>>   
>
>> -	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
>>   
> Please don't remove this variable though it will not be used in this patch 
> anymore, your following patch(patch5) however will use this structure 
> again, see:
>
> [PATCH 5/5] Don't account space used for system files when disabling sparse 
> feature
  Thanks for spotting this. Fixed. Since I've got no further comments I'm
reposting the series and hopefully it can be merged.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
