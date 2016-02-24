From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 24 Feb 2016 09:53:36 +0800
Subject: [Ocfs2-devel] Patch for reviews, thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA482934320@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA482934320@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <56CD0D20.5020809@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guozhonghua,
Thanks for pointing this out.
But you should follow the way described in
Documentation/SubmittingPatches to submit your patch.
I'll re-arrange and resend it.

Thanks,
Joseph

On 2016/2/24 9:11, Guozhonghua wrote:
> 
> aops.c, in the function ocfs2_direct_IO_write.
> 
> *************** clean_orphan:
> *** 948,961 ****
> --- 947,963 ----
>                 tmp_ret = ocfs2_inode_lock(inode, &di_bh, 1);
>                 if (tmp_ret < 0) {
>                         ret = tmp_ret;
>                         mlog_errno(ret);
>                         goto out;
>                 }
> 
>                 tmp_ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
>                                 update_isize, end);
>                 if (tmp_ret < 0) {
>                         ret = tmp_ret;
>                         mlog_errno(ret);
> +                       ocfs2_inode_unlock(inode, 1);
>                         brelse(di_bh);
>                         goto out;
>                 }
> 
>                 ocfs2_inode_unlock(inode, 1);
>                 brelse(di_bh);
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
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
