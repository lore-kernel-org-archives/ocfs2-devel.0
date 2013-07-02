From: Jensen <shencanquan@huawei.com>
Date: Tue, 2 Jul 2013 09:22:22 +0800
Subject: [Ocfs2-devel] why oracle give up dlm by disk on ocfs2? because
 performance?
In-Reply-To: <51CE541B.4070807@huawei.com>
References: <51CE541B.4070807@huawei.com>
Message-ID: <51D22B4E.6020406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark, sunil, jeff an Joel,
   Do you know why ? Thanks.

Jensen.
2013-7-2

On 2013/6/29 11:27, Jensen wrote:

> Hi all,
>    I found ocfs1.0 use the Distributed lock manager by disk. on ocfs2 why give up? because performance or other reason?
> 
>    Btw:
>      on the ocfs1.0 why not use scsi-2/3 reservation to protect to update the dlm sector data?
> 
> Thanks,
> Jensen.
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
