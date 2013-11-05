From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 5 Nov 2013 16:20:08 +0800
Subject: [Ocfs2-devel] ocfs2: why not set EROFS when clearing bits multiple
	times
Message-ID: <5278AA38.9050603@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_block_group_clear_bits, when num_bits != bits_cleared, it just
log an error message without setting EROFS.

The code is below:

	/*
	 * If encountered, it means we are clearing bits multiple times. While
	 * we are handling the case, we still need to be alerted to its
	 * occurrence. Hence, marking it as an ERROR and not NOTICE.
	 */
	if (num_bits != bits_cleared) {
		mlog(ML_ERROR, "Trying to clear %u bits at offset %u in group "
		     "descriptor # %llu (device %s), needed to clear %u bits\n",
		     num_bits, bit_off,
		     (unsigned long long)le64_to_cpu(bg->bg_blkno),
		     alloc_inode->i_sb->s_id, bits_cleared);
	}

If this case happens, does it mean the filesystem have already been
inconsistent? If so, why not set EROFS when this case happens?
Or anyone knows which case will casue bits to be cleared multiple times?
Thanks very much.
