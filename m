From: Jan Kara <jack@suse.cz>
Date: Mon, 3 Aug 2009 15:14:49 +0200
Subject: [Ocfs2-devel] [PATCH 3/9] Implement quota functions to libocfs2
In-Reply-To: <4A725AEA.5050107@oracle.com>
References: <1248974064-29462-1-git-send-email-jack@suse.cz>
	<1248974064-29462-4-git-send-email-jack@suse.cz>
	<4A725AEA.5050107@oracle.com>
Message-ID: <20090803131449.GF21712@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 31-07-09 10:46:02, Tao Ma wrote:
>> +	/* We need at least two blocks */
>> +	err = ocfs2_cached_inode_extend_allocation(ci,
>> +		ocfs2_clusters_in_blocks(fs, OCFS2_LOCAL_QF_INIT_BLOCKS));
>> +	if (err)
>> +		goto out;
>> +	di->i_size = bytes;
>> +	di->i_mtime = time(NULL);
>> +	err = ocfs2_write_inode(fs, blkno, (char *)di);
>> +	if (err)
>> +		goto out;
>> +
>> +	err = ocfs2_malloc_blocks(fs->fs_io, bytes, &buf);
> hey, ocfs2_malloc_blocks need num_blocks, not "bytes". so maybe 
> OCFS2_LOCAL_QF_INIT_BLOCKS?
  Argh, right. I don't know why I thought it takes bytes. Will fix it
and resend the series. Thanks for catching this.

> Oh, I just checked your v1, it was there. I am so sorry for not finding it 
> earlier. And please change all of them in this patch.
>> +/* Get free block in file (either from free list or create new one) */
>> +static errcode_t ocfs2_get_free_dqblk(ocfs2_filesys *fs, int type,
>> +				      unsigned int *blk)
>> +{
>> +	errcode_t err;
>> +	char *buf;
>> +	struct qt_disk_dqdbheader *dh;
>> +	struct ocfs2_global_disk_dqinfo *info = &(fs->qinfo[type].qi_info);
>> +	ocfs2_cached_inode *ci = fs->qinfo[type].qi_inode;
>> +
>> +	err = ocfs2_malloc_block(fs->fs_io, &buf);
>> +	if (err)
>> +		return err;
>> +	dh = (struct qt_disk_dqdbheader *)buf;
>> +	if (info->dqi_free_blk) {
>> +		*blk = info->dqi_free_blk;
>> +		err = read_blk(fs, type, *blk, buf);
>> +		if (err)
>> +			goto bail;
>> +		info->dqi_free_blk = le32_to_cpu(dh->dqdh_next_free);
>> +	}
>> +	else {
>> +		if (info->dqi_blocks ==
>> +		    ocfs2_clusters_to_blocks(fs, ci->ci_inode->i_clusters)) {
>> +			err = ocfs2_cached_inode_extend_allocation(ci, 1);
>> +			if (err)
>> +				goto bail;
>> +		}
>> +		*blk = info->dqi_blocks++;
>> +		ci->ci_inode->i_size =
>> +				ocfs2_blocks_to_bytes(fs, info->dqi_blocks);
> I am interested in this part. I read the kernel part yesterday. There you 
> often check whether we need to add a chunk header in which case we need to 
> extend the file by 2 blocks actually. But here we just extend 1 cluster? Is 
> this a little different from the kernel part or we just simplify the case 
> in the userspace? Please help me clarify it. Thanks.
  This code takes care of extending global quota file - in kernel this
corresponds to a handling in ocfs2_quota_write(). Userspace code never
needs to extend local quota files, it only initializes them.

>> +	}
>> +	mark_quotafile_info_dirty(fs, type);
>> +bail:
>> +	ocfs2_free(&buf);
>> +	return err;
>> +}

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
