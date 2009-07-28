From: Jan Kara <jack@suse.cz>
Date: Tue, 28 Jul 2009 10:40:55 +0200
Subject: [Ocfs2-devel] [PATCH 3/8] Implement quota functions to libocfs2
In-Reply-To: <4A6EAEF2.10705@oracle.com>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-4-git-send-email-jack@suse.cz>
	<4A6EAEF2.10705@oracle.com>
Message-ID: <20090728084055.GB5880@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 28-07-09 15:55:30, Tao Ma wrote:
> Hi Jan,
>
> Jan Kara wrote:
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  include/ocfs2/ocfs2.h     |   80 +++
>>  libocfs2/Makefile         |    1 +
>>  libocfs2/feature_string.c |   18 +
>>  libocfs2/ocfs2_err.et     |    6 +
>>  libocfs2/quota.c          | 1208 +++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 1313 insertions(+), 0 deletions(-)
>>  create mode 100644 libocfs2/quota.c
>>
>> diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
>> index ac16823..7f136ca 100644
>> --- a/include/ocfs2/ocfs2.h
>> +++ b/include/ocfs2/ocfs2.h
>> @@ -125,16 +125,36 @@
>>  #define OCFS2_CHB_WAITING	2
>>  #define OCFS2_CHB_COMPLETE	3
>>  +/* Flags for global quotafile info */
>> +#define OCFS2_QF_INFO_DIRTY 1
>> +/* Should be power of two */
>> +#define DEFAULT_QUOTA_HASH_SIZE 8192
>> +#define MAX_QUOTA_HASH_SIZE (1<<21)	/* 16 MB on 64-bit arch*/
> 16MB is 1<<24?
  The comment is meant to say that the hash-table will occupy 16 MB on a
64-bit architecture where each pointer has 8 bytes... I'll expand the
comment a bit.

>> +errcode_t ocfs2_init_local_quota_file(ocfs2_filesys *fs, int type,
>> +				      uint64_t blkno)
>> +{
>> +	ocfs2_cached_inode *ci = NULL;
>> +	struct ocfs2_dinode *di;
>> +	struct ocfs2_disk_dqheader *header;
>> +	struct ocfs2_local_disk_dqinfo *info;
>> +	unsigned int magics[] = OCFS2_LOCAL_QMAGICS;
>> +	int versions[] = OCFS2_LOCAL_QVERSIONS;
>> +	char *buf = NULL;
>> +	unsigned int written;
>> +	errcode_t err;
>> +
>> +	err = ocfs2_read_cached_inode(fs, blkno, &ci);
>> +	if (err)
>> +		goto out;
>> +
>> +	if (!(ci->ci_inode->i_flags & OCFS2_VALID_FL) ||
>> +	    !(ci->ci_inode->i_flags & OCFS2_SYSTEM_FL) ||
>> +	    !(ci->ci_inode->i_flags & OCFS2_QUOTA_FL)) {
>> +		err = OCFS2_ET_INTERNAL_FAILURE;
>> +		goto out;
>> +	}
>> +	di = ci->ci_inode;
>> +
>> +	/* We need at least two blocks */
>> +	err = ocfs2_cached_inode_extend_allocation(ci, (2 * fs->fs_blocksize +
>> +			fs->fs_clustersize - 1) / fs->fs_clustersize);
>> +	if (err)
>> +		goto out;
>> +	di->i_size = 2 * fs->fs_blocksize;
>> +	di->i_mtime = time(NULL);
>> +	err = ocfs2_write_inode(fs, blkno, (char *)di);
>> +	if (err)
>> +		goto out;
>> +
>> +	err = ocfs2_malloc_blocks(fs->fs_io, fs->fs_blocksize * 2, &buf);
>> +	if (err)
>> +		goto out;
>> +	memset(buf, 0, 2 * fs->fs_blocksize);
>> +
>> +	header = (struct ocfs2_disk_dqheader *)buf;
>> +	header->dqh_magic = magics[type];
>> +	header->dqh_version = versions[type];
>> +	ocfs2_swap_quota_header(header);
>> +
>> +	info = (struct ocfs2_local_disk_dqinfo *)(buf + OCFS2_LOCAL_INFO_OFF);
>> +	info->dqi_chunks = 1;
>> +	info->dqi_blocks = 2;
> I see hardcoded "2" so many times in this function while in 
> ocfs2_init_global_quota_file you define "int blocks = 2", so I just wonder 
> if we can change it somehow like that function?
  OK, will do.

>> +	info->dqi_flags = OLQF_CLEAN;
>> +	ocfs2_swap_quota_local_info(info);
>> +
>> +	/* There are no free chunks because there are no blocks allocated for
>> +	 * them yet. So chunk header is all-zero and needs no initialization */
>> +	ocfs2_checksum_quota_block(fs, buf);
>> +	ocfs2_checksum_quota_block(fs, buf + fs->fs_blocksize);
>> +	err = ocfs2_file_write(ci, buf, 2 * fs->fs_blocksize, 0, &written);
>> +	if (!err && written != 2 * fs->fs_blocksize) {
>> +		err = OCFS2_ET_INTERNAL_FAILURE;
>> +		goto out;
>> +	}
> and here in ocfs2_init_global_quota_file you use write_blk which will 
> calculate ocfs2_checksum_quota_block. So we can use that function also 
> here?
  No, we cannot since write_blk() writes to a global quota file. Here we
need to write to a node-local quota file. Since there's only this place,
where we write to local quota file, I'd just leave the code as is.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
