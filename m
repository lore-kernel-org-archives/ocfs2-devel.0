From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Fri, 18 Dec 2015 04:58:39 +0000
Subject: [Ocfs2-devel] ocfs2 cannot continue when JBD2 has aborted the
 journal, 
References: <2015121713343524045332@h3c.com>, <56735BF7.2090108@huawei.com>
Message-ID: <20151218125949277021131@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi  Joseph<mailto:joseph.qi@huawei.com>

The following locking order can cause a deadlock.
 Node  A                                                                                                           Node B                                                              Node C
     Super lock  EX
        ocfs2_commit_thread
             ocfs2_commit_cache
              jbd2_journal_flush  while  journal is aborted , have been -EIO error.
     do not wake_up(&osb->dc_event)
     do not  downconvert EX->NL

while Node B required EX lock or PR lock, may cause nodes hung.
So reset Node A,  Node B and Node C will be normal.
Thanks a lot
________________________________
zhangguanghui

From: Joseph Qi<mailto:joseph.qi@huawei.com>
Date: 2015-12-18 09:05
To: zhangguanghui 10102 (CCPL)<mailto:zhang.guanghui@h3c.com>
CC: ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] ocfs2 cannot continue when JBD2 has aborted the journal,

Hi Guanghui,
Could you please describe the problem you encountered more specifically?
I don't think this change is in a fair way.

On 2015/12/17 13:33, Zhangguanghui wrote:
> Hi all,
>
> A tiny race about JBD2 has aborted to jbd2_journal_flush,
>
> because of unstable storage link and I/O stress.
>
> while JBD2 state is aborted, have been -EIO error,
>
> may cause all cluster nodes hung. so I thinks
>
> JBD2 has aborted the journal, ocfs2 cannot continue and trigger ocfs2_abort.
>
> Thanks, Any ideas about this patch?
>
>
> description:
>
> ocfs2_commit_thread
>   ocfs2_commit_cache
>     jbd2_journal_flush
>
>
> --- journal.c 2015-12-17 11:36:39.140542941 +0800
> +++ journal.c.diff 2015-12-17 11:39:21.308542922 +0800
> @@ -328,6 +328,9 @@
> if (status < 0) {
> up_write(&journal->j_trans_barrier);
> mlog_errno(status);
> + if (is_journal_aborted(journal)) {
> + ocfs2_abort(osb->sb, "Detect aborted journal,while committing cache.");
> + }
> goto finally;
> }
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------!
---
> zhangguanghui
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>


-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151218/daea7981/attachment-0001.html 
