From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 05 Nov 2013 15:48:26 -0800
Subject: [Ocfs2-devel] ocfs2: why not set EROFS when clearing bits
 multiple times
In-Reply-To: <5278AA38.9050603@huawei.com>
References: <5278AA38.9050603@huawei.com>
Message-ID: <527983CA.8050403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11/05/2013 12:20 AM, Joseph Qi wrote:
> In ocfs2_block_group_clear_bits, when num_bits != bits_cleared, it just
> log an error message without setting EROFS.
>
> The code is below:
>
> 	/*
> 	 * If encountered, it means we are clearing bits multiple times. While
> 	 * we are handling the case, we still need to be alerted to its
> 	 * occurrence. Hence, marking it as an ERROR and not NOTICE.
> 	 */
> 	if (num_bits != bits_cleared) {
> 		mlog(ML_ERROR, "Trying to clear %u bits at offset %u in group "
> 		     "descriptor # %llu (device %s), needed to clear %u bits\n",
> 		     num_bits, bit_off,
> 		     (unsigned long long)le64_to_cpu(bg->bg_blkno),
> 		     alloc_inode->i_sb->s_id, bits_cleared);
> 	}
>
> If this case happens, does it mean the filesystem have already been
> inconsistent? If so, why not set EROFS when this case happens?
> Or anyone knows which case will casue bits to be cleared multiple times?
in the past we have seen a case where the number of free bits were more 
than actual bits which took fs read only. I think running fsck fixed 
this count but didn't report any other issues. So it appeared there is a 
case where we were trying to free some bits twice. Since there was no 
real corruption we didn't take the fs read only.

My guess is this problem may in code paths of releasing unused 
localalloc bits back to global bitmap.

> Thanks very much.
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
