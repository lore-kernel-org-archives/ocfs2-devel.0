From: Jensen <shencanquan@huawei.com>
Date: Tue, 2 Jul 2013 10:07:52 +0800
Subject: [Ocfs2-devel] why oracle give up dlm by disk on ocfs2? because
 performance?
In-Reply-To: <CAEeiSHWkiEiJCMjvVkAB+AGM9LUVLqw3de-tdU3K+z5=mfSF5w@mail.gmail.com>
References: <51CE541B.4070807@huawei.com> <51D22B4E.6020406@huawei.com>
	<CAEeiSHWkiEiJCMjvVkAB+AGM9LUVLqw3de-tdU3K+z5=mfSF5w@mail.gmail.com>
Message-ID: <51D235F8.1040503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/7/2 9:35, Sunil Mushran wrote:

> A general purpose file system requires one to manage over a million locks concurrently. So performance is the main reason.
> 

Thanks for your comments.

Has Oracle compared the performance between ocfs2 and ocfs1?

> 
> On Mon, Jul 1, 2013 at 6:22 PM, Jensen <shencanquan at huawei.com <mailto:shencanquan@huawei.com>> wrote:
> 
>     Hi Mark, sunil, jeff an Joel,
>        Do you know why ? Thanks.
> 
>     Jensen.
>     2013-7-2
> 
>     On 2013/6/29 11:27, Jensen wrote:
> 
>     > Hi all,
>     >    I found ocfs1.0 use the Distributed lock manager by disk. on ocfs2 why give up? because performance or other reason?
>     >
>     >    Btw:
>     >      on the ocfs1.0 why not use scsi-2/3 reservation to protect to update the dlm sector data?
>     >
>     > Thanks,
>     > Jensen.
>     >
>     >
>     > _______________________________________________
>     > Ocfs2-devel mailing list
>     > Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
>     > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>     >
>     >
> 
> 
> 
> 
