From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 10 Sep 2014 12:27:09 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] How to unlock a bloked resource?
	Thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA42EC6B020@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA42EC6B020@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <CAEeiSHWgoZG2f9guN3k69z4z9fHozbO4iL=hbUO92OdKo-LACg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

What is the output of the commands? The protocol is supposed to do the
unlocking on its own. See what is it blocked on. It could be that the node
that has the lock cannot unlock it because it cannot flush the journal to
disk.

On Tue, Sep 9, 2014 at 7:55 PM, Guozhonghua <guozhonghua@h3c.com> wrote:

>  Hi All:
>
>
>
> As we test with two node in one OCFS2 cluster.
>
> The cluster is hang up may be for dead lock.
>
> We use the debugfs.ocfs tool founding that one resource is holding by one
> node who has it for long time and another node can still wait for the
> resource.
>
> So the cluster is hang up.
>
>
>
> debugfs.ocfs2 -R "fs_locks -B" /dev/dm-0
>
> debugfs.ocfs2 -R "dlm_locks LOCKID_XXX" /dev/dm-0
>
>
>
> How to unlock the lock held by the node? Is there some commands to unlock
> the resource?
>
>
>
> Thanks.
>
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C,
> which is
> intended only for the person or entity whose address is listed above. Any
> use of the
> information contained herein in any way (including, but not limited to,
> total or partial
> disclosure, reproduction, or dissemination) by persons other than the
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, please
> notify the sender
> by phone or email immediately and delete it!
>
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140910/13bae819/attachment.html 
