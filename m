From: Likai <li.kai4@h3c.com>
Date: Mon, 9 Dec 2019 09:37:12 +0000
Subject: [Ocfs2-devel] [PATCH]ocfs2: flush journal to update log tail
 info after journal recovery when mount
Message-ID: <c8c15565f56c4ae19c74d59aa866fcb8@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <chge@linux.alibaba.com>, "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>

Hi, changwei, thanks for your review. My annotation maybe not clear, sorry for that.
the attached file is the version two.

Thanks.


-----Original Message-----
From: Changwei Ge [mailto:chge at linux.alibaba.com]
Sent: Friday, December 06, 2019 5:41 PM
To: likai (Cloud) <li.kai4@h3c.com>; mark at fasheh.com; jlbec at evilplan.org; joseph.qi at linux.alibaba.com
Cc: ocfs2-devel at oss.oracle.com; linux-fsdevel at vger.kernel.org; Jan Kara <jack@suse.cz>
Subject: Re: [PATCH]ocfs2: flush journal to update log tail info after journal recovery when mount

Hi,


I am trying to understand the problem.
Just a few quick questions inline.



On 2019/12/5 11:18 AM, Likai wrote:
> Hi,  I meet a new problem that file may be lost althougth it is
> recorded in the jbd2 journal
>
> with ocfs2 file system in one node scene. Can you give some
> suggestions for this problem
>
> and modification patch?
>
> Test method:
>
> 1. touch some files after mount
>
> 2. emergency restart
>
> 3. mount again, then log tail will not be updated
>
> 4. touch a new file and confirm that it is recorded in the journal
> area
>
> 5.emergency restart again
>
> 6. the new log will not be replayed becasuse its seq and blknum are
> not consistent with journal super block although it is an unbroken commit.

What do you mean by the consistency between jbd2 blocks and jbd2 super block?

Did you ever call fsync(2) to test target file? If not, posix doesn't guarantee the newly created file should be present after a crash. In other words, it's a normal case.

Perhaps, I miss something, better you can give a further elaboration.
If we can ensure this patch helps, we can make this progress :-)

>
> After analizing the codes, its cause is as follow:
>
> Journal->j_flags will be set JBD2_ABORT in journal_init_common first.
>
> if this flag is not cleared before journal_reset in journal recovery
>
> scene, super log tail cannot be updated, then the new commit trans in
>
> the journal may not be replayed because new commits recover old trans
>
> area.
>
> This exception happens when this lun is used by only one node. If it
>
> is used by multi-nodes, other node will replay its journal and its
>
> log tail info will be updated after recovery.
>
> To fix this problem, use jbd2_journal_flush to update log tail as
>
> ocfs2_replay_journal has done.
>
> logdump:
>
> Block 0: Journal Superblock
>
> Seq: 0   Type: 4 (JBD2_SUPERBLOCK_V2)
>
> Blocksize: 4096   Total Blocks: 32768   First Block: 1
>
> First Commit ID: 13   Start Log Blknum: 1
>
> Error: 0
>
> Feature Compat: 0
>
> Feature Incompat: 2 block64
>
> Feature RO compat: 0
>
> Journal UUID: 4ED3822C54294467A4F8E87D2BA4BC36
>
> FS Share Cnt: 1   Dynamic Superblk Blknum: 0
>
> Per Txn Block Limit    Journal: 0    Data: 0
>
> Block 1: Journal Commit Block
>
> Seq: 14   Type: 2 (JBD2_COMMIT_BLOCK)
>
> Block 2: Journal Descriptor
>
> Seq: 15   Type: 1 (JBD2_DESCRIPTOR_BLOCK)
>
> No. Blocknum        Flags
>
> 0. 587             none
>
> UUID: 00000000000000000000000000000000
>
> 1. 8257792         JBD2_FLAG_SAME_UUID
>
> 2. 619             JBD2_FLAG_SAME_UUID
>
> 3. 24772864        JBD2_FLAG_SAME_UUID
>
> 4. 8257802         JBD2_FLAG_SAME_UUID
>
> 5. 513             JBD2_FLAG_SAME_UUID JBD2_FLAG_LAST_TAG
>
> ...
>
> Block 7: Inode
>
> Inode: 8257802   Mode: 0640   Generation: 57157641 (0x3682809)
>
> FS Generation: 2839773110 (0xa9437fb6)
>
> CRC32: 00000000   ECC: 0000
>
> Type: Regular   Attr: 0x0   Flags: Valid
>
> Dynamic Features: (0x1) InlineData
>
> User: 0 (root)   Group: 0 (root)   Size: 7
>
> Links: 1   Clusters: 0
>
> ctime: 0x5de5d870 0x11104c61 -- Tue Dec  3 11:37:20.286280801 2019
>
> atime: 0x5de5d870 0x113181a1 -- Tue Dec  3 11:37:20.288457121 2019
>
> mtime: 0x5de5d870 0x11104c61 -- Tue Dec  3 11:37:20.286280801 2019
>
> dtime: 0x0 -- Thu Jan  1 08:00:00 1970
>
> ...
>
> Block 9: Journal Commit Block
>
> Seq: 15   Type: 2 (JBD2_COMMIT_BLOCK)
>
> syslog:
>
> Dec  3 11:41:05 cvknode02 kernel: [ 2265.648622] ocfs2: File system on
> device (252,1) was not unmounted cleanly, recovering it.
>
> Dec  3 11:41:05 cvknode02 kernel: [ 2265.649695]
> fs/jbd2/recovery.c:(do_one_pass, 449): Starting recovery pass 0
>
> Dec  3 11:41:05 cvknode02 kernel: [ 2265.650407]
> fs/jbd2/recovery.c:(do_one_pass, 449): Starting recovery pass 1
>
> Dec  3 11:41:05 cvknode02 kernel: [ 2265.650409]
> fs/jbd2/recovery.c:(do_one_pass, 449): Starting recovery pass 2
>
> Dec  3 11:41:05 cvknode02 kernel: [ 2265.650410]
> fs/jbd2/recovery.c:(jbd2_journal_recover, 278): JBD2: recovery, exit
> status 0, recovered transactions 13 to 13
>
> Seq 15 is an unbroken commit, but it cannot be replayed, inode 8257802


I think all the ever committed transactions are kept in the journal area until it's overwritten.

>
> is a new file and it will be lost. After test, it is ok now.
>
> Signed-off-by: Kai Li <li.kai4@h3c.com>
>
> ---
>
> fs/ocfs2/journal.c | 8 ++++++++
>
> 1 file changed, 8 insertions(+)
>
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>
> index 1afe57f425a0..b8b9d26fa731 100644
>
> --- a/fs/ocfs2/journal.c
>
> +++ b/fs/ocfs2/journal.c
>
> @@ -1066,6 +1066,14 @@ int ocfs2_journal_load(struct ocfs2_journal
> *journal, int local, int replayed)
>
>          ocfs2_clear_journal_error(osb->sb, journal->j_journal,
> osb->slot_num);
>
> +       if (replayed) {
>
> +                /* wipe the journal */
>
> +                jbd2_journal_lock_updates(journal->j_journal);
>
> +                status = jbd2_journal_flush(journal->j_journal);
>
> +                jbd2_journal_unlock_updates(journal->j_journal);

As now it's under mounting progress, I don't figure out how can we get running jbd2 transactions? If no *running* transactions around, does
jbd2_journal_flush() really have effect to jbd2?

-Changwei

>
> +                mlog(ML_NOTICE, "journal recovery complete,
> +status=%d",
> status);
>
> +       }
>
> +
>
>         status = ocfs2_journal_toggle_dirty(osb, 1, replayed);
>
>         if (status < 0) {
>
>                  mlog_errno(status);
>
-------------------------------------------------------------------------------------------------------------------------------------
?????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from New H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-call-journal-flush-to-mark-journal-as-empty-af.patch
Type: application/octet-stream
Size: 4266 bytes
Desc: 0001-ocfs2-call-journal-flush-to-mark-journal-as-empty-af.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20191209/5d1538f3/attachment.obj 
