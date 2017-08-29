From: Gang He <ghe@suse.com>
Date: Mon, 28 Aug 2017 22:52:37 -0600
Subject: [Ocfs2-devel] [Ocfs2-tools-devel] fsck.ocfs2 does not write
 back block data corrected with hamming code
In-Reply-To: <1fb7bf43-b4cd-9b7b-d812-df483577ddcb@suse.com>
References: <1fb7bf43-b4cd-9b7b-d812-df483577ddcb@suse.com>
Message-ID: <59A56395020000F900089D64@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Guys,

This is a little tricky problem.
When the user modifies a character in a meta-block, the hamming code can repair this block when reading this block in fsck tool, 
so fsck tool can not detect this disk block inconsistent problem.
But debugfs tool reads meta blocks without using meta-ecc mechanism, that means debugfs can see this corrupted block.
We need to discuss if we should aware this problem in fsck and rewrite the corrected block in memory to disk in this case.

Thanks
Gang 


>>> 
> Recently I found that fsck.ocfs2 does not write back block data 
> corrected with hamming code.
> 
> The following is how to reproduce my occasion.
> 1.  Using debugfs.ocfs2 to find block number of index root of a dir
> 2.  Change the signature of this block from "DXDIR01" to "EXDIR01"
> 3.  fsck.ocfs2 does not repair or rebuild the index of this dir, as if 
> the change can not be detected
> 4.  Using dx_dump <dir inode #>command in debugfs.ocfs2, nothing can be 
> seen.
> 
> Then I try to find how all of this happened.
> 
> Then I found that for block data that could be corrected by hamming code 
> won't be written back
> to disk. And the validated data lies only in memory.
> 
> This is the function back trace:
> fix_dirent_index
>      ocfs2_lookup
>          ocfs2_find_entry_dx
>              ocfs2_read_dx_root
>                  ocfs2_read_blocks
> ocfs2_validate_meta_ecc
> 
> 
> In last function ocfs2_validate_meta_ecc, the data could be corrected 
> and function returns success.
> Without being written back, data differs between memory and disk. This 
> could result in another side
> effect, i.e., if this portion of data read from disk is not validated by 
> hamming code, it will be somewhere
> wrong.
> 
> Unfortunately, the bad occasion happens in debugfs.ocfs2 when dx_dump 
> command is used to read index information.
> 
> The following is how dx_dump works.
> do_dx_dump
>      dump_dx_entries
>          ocfs2_read_dx_root
>              ocfs2_read_blocks
> ocfs2_validate_meta_ecc
>              memcmp(dx_root->dr_signature, "DXDIR01")
> 
> Although ocfs2_validate_meta_ecc is invoked, actually it does not work 
> as expected.
> Because one of file system flags(OCFS2_FLAG_NO_ECC_CHECKS) has already 
> been set.
> 
> 
> errcode_t ocfs2_validate_meta_ecc(ocfs2_filesys *fs, void *data,
>                    struct ocfs2_block_check *bc)
> {
>      errcode_t err = 0;
> 
>      if (ocfs2_meta_ecc(OCFS2_RAW_SB(fs->fs_super)) &&
>          !(fs->fs_flags & OCFS2_FLAG_NO_ECC_CHECKS))
>          err = ocfs2_block_check_validate(data, fs->fs_blocksize, bc);
> 
>      return err;
> }
> 
> 
> 
> This flag has been set explicitly during the initial function do_open 
> was being called.
> static void do_open(char **args)
> {
>      ...
>      flags |= OCFS2_FLAG_HEARTBEAT_DEV_OK|OCFS2_FLAG_NO_ECC_CHECKS;
>      ...
> }
> 
> To summary, validated data in memory and corrupted data on disk lead to 
> the result that
> debugfs.ocfs2 misfunctions.
> 
> Maybe, this behavior is not proper for fsck.ocfs2.
> 
> To solve this problem, I thought about two solutions.
> 
> S1. Add a error code to indicate that data read from disk is valid, 
> however, it has already be corrected.
> Once ocfs2_read_blocks returns, check the return code to decide whether 
> or not write it back.
> 
> S2. Keep ocfs2_read_blocks  as it is, and just clear 
> OCFS2_FLAG_NO_ECC_CHECKS for debugfs.ocfs2.
