From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 15 Aug 2012 09:11:33 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: skip locks in the blocked list
In-Reply-To: <502B4193.5040608@huawei.com>
References: <5029B1E5.4030509@huawei.com>
	<CAEeiSHVJc6pnTcQ8MrLBvQ+GhZ=5P6uG-sBg0VcvK0LWxBjpuA@mail.gmail.com>
	<502B4193.5040608@huawei.com>
Message-ID: <CAEeiSHVFXGQtixne6qNdi3wP4qxk=H3kdhTUvVSaWZAFp5m0JQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 14, 2012 at 11:28 PM, Xue jiufei <xuejiufei@huawei.com> wrote:

>
> Sorry, I haven't described it clearly.
>
> We trigger the BUG() in dlmrecovery.c:1923.
>
> Lockres had copyed lvb from previous valid locks and then meet with
> another lock with the EX level.
>
> 1907                            if (!dlm_lvb_is_empty(res->lvb) &&
> 1908                                (ml->type == LKM_EXMODE ||
> 1909                                 memcmp(res->lvb, mres->lvb,
> DLM_LVB_LEN))) {
>                                                 ......
> 1923                                    BUG();
> 1924                            }
>


Perfect. That is the place it should have oopsed.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120815/ed296cef/attachment.html 
