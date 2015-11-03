From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 03 Nov 2015 15:12:35 +0800
Subject: [Ocfs2-devel] [PATCH v2 4/4] ocfs2: check/fix inode block for
	online file check
In-Reply-To: <1446013561-22121-5-git-send-email-ghe@suse.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<1446013561-22121-5-git-send-email-ghe@suse.com>
Message-ID: <56385E63.80808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, mfasheh@suse.com, rgoldwyn@suse.de
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Hi Gang,

This is not like a right patch.
First, online file check only checks inode's block number, valid flag,
fs generation value, and meta ecc. I never see a real corruption
happened only on this field, if these fields are corrupted, that means
something bad may happen on other place. So fix this field may not help
and even cause corruption more hard.
Second, the repair way is wrong. In
ocfs2_filecheck_repair_inode_block(), if these fields in disk don't
match the ones in memory, the ones in memory are used to update the disk
fields. The question is how do you know these field in memory are
right(they may be the real corrupted ones)?

Thanks,
Junxiao.
On 10/28/2015 02:26 PM, Gang He wrote:
> +static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
> +			       struct buffer_head *bh)
> +{
> +	int rc;
> +	int changed = 0;
> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
> +
> +	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
> +	/* Can't fix invalid inode block */
> +	if (!rc || rc == -OCFS2_FILECHECK_ERR_INVALIDINO)
> +		return rc;
> +
> +	trace_ocfs2_filecheck_repair_inode_block(
> +		(unsigned long long)bh->b_blocknr);
> +
> +	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
> +		ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
> +		mlog(ML_ERROR,
> +			"Filecheck: try to repair dinode #%llu on readonly filesystem\n",
> +			(unsigned long long)bh->b_blocknr);
> +		return -OCFS2_FILECHECK_ERR_READONLY;
> +	}
> +
> +	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
> +		di->i_blkno = cpu_to_le64(bh->b_blocknr);
> +		changed = 1;
> +		mlog(ML_ERROR,
> +			"Filecheck: reset dinode #%llu: i_blkno to %llu\n",
> +			(unsigned long long)bh->b_blocknr,
> +			(unsigned long long)le64_to_cpu(di->i_blkno));
> +	}
> +
> +	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
> +		di->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
> +		changed = 1;
> +		mlog(ML_ERROR,
> +			"Filecheck: reset dinode #%llu: OCFS2_VALID_FL is set\n",
> +			(unsigned long long)bh->b_blocknr);
> +	}
> +
> +	if (le32_to_cpu(di->i_fs_generation) !=
> +	    OCFS2_SB(sb)->fs_generation) {
> +		di->i_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
> +		changed = 1;
> +		mlog(ML_ERROR,
> +			"Filecheck: reset dinode #%llu: fs_generation to %u\n",
> +			(unsigned long long)bh->b_blocknr,
> +			le32_to_cpu(di->i_fs_generation));
> +	}
> +
> +	if (changed ||
> +		ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
> +		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
> +		mark_buffer_dirty(bh);
> +		mlog(ML_ERROR,
> +			"Filecheck: reset dinode #%llu: compute meta ecc\n",
> +			(unsigned long long)bh->b_blocknr);
> +	}
> +
> +	return 0;
> +}
