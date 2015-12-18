From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 18 Dec 2015 10:15:27 +0800
Subject: [Ocfs2-devel] ocfs2 cannot continue when JBD2 has aborted the
 journal, 
In-Reply-To: <2015121713343524045332@h3c.com>
References: <2015121713343524045332@h3c.com>
Message-ID: <56736C3F.8050203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guanghui,

I think I encounter an problem just like you. But it's not race case.

Every time ocfs2_commit_threadreceive an errorfrom jbd2_journal_flush 
(which may cause by disk io error), it will continue to try commit 
journal. But in this case, journal should run into abort state, so retry 
commit is useless. And even worse, the lock resource hold by this node 
can not be release, so entire cluster hung.

I have write a patch about this, and my solution is just like yours, 
will send it in another email.

Thanks,
Ryan

On 12/17/2015 01:33 PM, Zhangguanghui wrote:
> Hi all,
> A tiny race aboutJBD2has aborted to jbd2_journal_flush,
> because of unstable storagelink and I/O stress.
> whileJBD2state is aborted, have been -EIO error,
> may cause all cluster nodes hung. so I thinks
> JBD2 has aborted the journal, ocfs2 cannot continue andtriggerocfs2_abort.
> Thanks,Any ideas about this patch?
> description:
> ocfs2_commit_thread
>    ocfs2_commit_cache
>      jbd2_journal_flush
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
> ------------------------------------------------------------------------
> zhangguanghui
> -------------------------------------------------------------------------------------------------------------------------------------
> ??????????????????????????,?????????????
> ?????????????????????(??????????????????
> ???)?????????????????,??????????????????
> ??!
> This e-mail and its attachments contain confidential information from 
> H3C, which is
> intended only for the person or entity whose address is listed above. 
> Any use of the
> information contained herein in any way (including, but not limited 
> to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the 
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, 
> please notify the sender
> by phone or email immediately and delete it!
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151218/4252dcb3/attachment.html 
