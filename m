From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 20 Oct 2010 14:08:17 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2: Remove j_trans_barrier
Message-ID: <4CBE8751.1060606@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	j_trans_barrier in ocfs2 is used to protect some journal operations in 
ocfs2. So normally, it is used as belows:
1. In journal transaction. When we start a transaction, We will 
down_read it and j_num_trans will be increased accordingly(in case of a 
cluster environment). It will be up_read when we do ocfs2_commit_trans.
2. In ocfs2_commit_cache, we will down_write it and then call 
jbd2_journal_flush, increase j_trans_id, reset j_num_trans and finally 
call up_write. This function is used by thread ocfs2cmt.

So in general, when we do journal flush, no new transaction will be 
started because of it. But it did hold off the system and caused a long 
delay for some file operations. I have met with a bug.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1281

After 30 days of usage of ocfs2, the system becomes slower and 
slower(why the journal commit becomes so slower is still unknown and may 
be related to file system fragmentation) and a tiny open/truncate of a 
file will cause around 10-30 secs. I don't think it is endurable for a 
user. After putting some debug codes in the kernel(great thanks to the 
user), I find that it is the blocked by ocfs2_start_trans. The strace 
log shows:

22955 open("/usr/home/test_io_file_ow", O_WRONLY|O_CREAT|O_TRUNC, 0666) 
= 1 <10.329676>

And from the system log:

Sep 24 17:28:30 192.168.0.4 kernel: 
(dd,22955,5):ocfs2_orphan_for_truncate:354 start transcation for inode 
105572512
Sep 24 17:28:41 192.168.0.4 kernel: 
(dd,22955,5):ocfs2_orphan_for_truncate:362 journal access for inode 
105572512

The code is like this:
	mlog(0, "start transcation for inode %llu\n", OCFS2_I(inode)->ip_blkno);
         handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
         if (IS_ERR(handle)) {
                 status = PTR_ERR(handle);
                 mlog_errno(status);
                 goto out;
         }

         mlog(0, "journal access for inode %llu\n", 
OCFS2_I(inode)->ip_blkno);

So we spent 11 secs in ocfs2_start_trans!

 From what I have investigated, j_trans_barrier is only used in a 
cluster environment(for a local mounted volume, ocfs2cmt isn't started 
and we depends on jbd2 to flush the journal). And it works with 
j_trans_id to make sure all the modifications to the specified 
ocfs2_caching_info are flushed(see ocfs2_ci_fully_checkpointed) when we 
downconvert a cluster lock. And we also call ocfs2_set_ci_lock_trans in 
journal_access so that we know the last trans_id for a specified 
ocfs2_caching_info.

My solution is that:
1. remove j_trans_barrier
2. Add a flag ci_checkpointing in ocfs2_caching_info:
    1) When we find this caching_info needs checkpoint, set this flag 
and start the checkpointing(in ocfs2_ci_checkpointed). And the 
downconvert request will be requeued so that we can check and clear this 
flag next time it is handled.
    2) Clear the flag when there is no need for checkpointing this 
ci(also in ocfs2_ci_checkpointed) during check_downconvert.
3. make sure when we journal_access some blocks, the caching_info can't 
be in the state of checkpointing. I think if we are checkpointing an 
caching_info, we shouldn't be able to journal_access it since it is just 
required to downconvert and we shouldn't have the lock now? So perhaps a 
BUG_ON should work?

So above is the scenario and my solution. Any comments are welcomed.

Regards,
Tao
