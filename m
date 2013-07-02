From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Mon, 1 Jul 2013 18:35:36 -0700
Subject: [Ocfs2-devel] why oracle give up dlm by disk on ocfs2? because
	performance?
In-Reply-To: <51D22B4E.6020406@huawei.com>
References: <51CE541B.4070807@huawei.com>
	<51D22B4E.6020406@huawei.com>
Message-ID: <CAEeiSHWkiEiJCMjvVkAB+AGM9LUVLqw3de-tdU3K+z5=mfSF5w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A general purpose file system requires one to manage over a million locks
concurrently. So performance is the main reason.


On Mon, Jul 1, 2013 at 6:22 PM, Jensen <shencanquan@huawei.com> wrote:

> Hi Mark, sunil, jeff an Joel,
>    Do you know why ? Thanks.
>
> Jensen.
> 2013-7-2
>
> On 2013/6/29 11:27, Jensen wrote:
>
> > Hi all,
> >    I found ocfs1.0 use the Distributed lock manager by disk. on ocfs2
> why give up? because performance or other reason?
> >
> >    Btw:
> >      on the ocfs1.0 why not use scsi-2/3 reservation to protect to
> update the dlm sector data?
> >
> > Thanks,
> > Jensen.
> >
> >
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >
>
>
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130701/0df7a53b/attachment.html 
