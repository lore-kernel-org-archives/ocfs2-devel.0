From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 1 Apr 2016 08:34:51 +0000
Subject: [Ocfs2-devel] ocfs2_clear_journal_error review
References: <mailman.1.1458759602.8075.ocfs2-devel@oss.oracle.com>
Message-ID: <E3535A62B291B54FBD1D003696CCB5375E18CF7B@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi
    I get a issue while mounting the volume at a time. Missing jbd2_journal_update_sb_errno() may cause this issue.
    So far as i know,  in  jbd2_journal_clear_err,  journal->j_errno = 0, but don't call jbd2_journal_update_sb_errno update sb->s_errno.
? in __journal_abort_soft? journal->j_errno and  sb->s_errno record the abort error status.
    the value of sb->s_errno is always EIO, jbd2_journal_load->load_superblock->journal->j_errno = be32_to_cpu(sb->s_errno);
    the next time mounting the volume, still get the same issues.  so jbd2_journal_update_sb_errno should be called after jbd2_journal_clear_err
     in ocfs2_clear_journal_error.  Anybody ever see this, is it reasonable??Thanks

    ocfs2_journal_load
       --jbd2_journal_load
       -- ocfs2_clear_journal_error
            --jbd2_journal_errno
            --jbd2_journal_ack_err
            --jbd2_journal_clear_err
            -- jbd2_journal_update_sb_errno  --update sb_error

    (mount.ocfs2,7417,38):ocfs2_clear_journal_error:1052 ERROR: File system error -5 recorded in journal 2.
    (mount.ocfs2,7417,38):ocfs2_clear_journal_error:1054 ERROR: File system on device dm-1 needs checking

  Thanks.

________________________________
zhangguanghui

-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160401/1a82de15/attachment.html 
