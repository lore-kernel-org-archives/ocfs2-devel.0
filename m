From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 18 Dec 2015 09:05:59 +0800
Subject: [Ocfs2-devel] ocfs2 cannot continue when JBD2 has aborted the
 journal, 
In-Reply-To: <2015121713343524045332@h3c.com>
References: <2015121713343524045332@h3c.com>
Message-ID: <56735BF7.2090108@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
