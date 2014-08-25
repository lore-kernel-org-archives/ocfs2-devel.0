From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Sun, 24 Aug 2014 22:00:01 -0700
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient
	memory
In-Reply-To: <53FA99FD.1090008@huawei.com>
References: <53F41CAE.2040204@huawei.com> <53F6FFB7.1090305@huawei.com>
	<CAEeiSHVP60=zNcP-Q2bCD_BdD3g8v1a__Vyn4ZMF_8Z97cpE8g@mail.gmail.com>
	<53FA99FD.1090008@huawei.com>
Message-ID: <CAEeiSHWiPZHKC5gwLTuuZAm3xUeGT48BLNs97qdUgZSMM+AFZQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Functions in dlmdomain.c are only triggered during mount. So they cannot
trigger the deadlock as described above in this thread. I would leave them
as is.
On Aug 24, 2014 7:06 PM, "Xue jiufei" <xuejiufei@huawei.com> wrote:

> Hi Sunil,
> On 2014/8/23 1:08, Sunil Mushran wrote:
> > Allocs made via GFP_NOFS, by definition, should not trigger any reclaim
> from the fs.
> > So this situation should never arise. That's why all allocs in the dlm
> have NOFS.
> >
> Thanks for your reply. I haven't noticed that before. So I think
> dlm_query_region_handler() should also use GFP_NOFS instead of GFP_KERNEL,
> right?
>
> Thanks.
> Xuejiufei
> >
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
>
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140824/430d34df/attachment.html 
