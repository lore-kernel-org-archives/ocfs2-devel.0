From: Jensen <shencanquan@huawei.com>
Date: Thu, 27 Jun 2013 16:56:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek requires to ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <CAEeiSHV=3DBBJ1mweEgyxWRgsA9O8C-25_FTPMxyDbatoX0Fkw@mail.gmail.com>
References: <51C2BC1F.2010106@huawei.com>
	<20130626141803.a67cb8e4ca38a9ef2967a448@linux-foundation.org>
	<51CB9338.3050408@huawei.com>
	<20130626182536.c319334d.akpm@linux-foundation.org>
	<51CB9A81.2000007@huawei.com>
	<CAEeiSHV=3DBBJ1mweEgyxWRgsA9O8C-25_FTPMxyDbatoX0Fkw@mail.gmail.com>
Message-ID: <51CBFE58.1060104@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/27 11:34, Sunil Mushran wrote:

> AFAIR, this behavior has been there since day 1 and changing it will impact performance negatively. I would recommend against making this
> change for one app.
> 

I think it will impact the performance negatively. but I think it is very
very little, because in cluster lock function, the inode size will update
from dlm in lvb. and it don't update by disk (another machine write file
size to disk and this machine read file size from disk to update the inode size)

if the file size update by disk. I think it will impact the performance very much.

> 
> On Wed, Jun 26, 2013 at 6:50 PM, shencanquan <shencanquan at huawei.com <mailto:shencanquan@huawei.com>> wrote:
> 
>     On 2013/6/27 9:25, Andrew Morton wrote:
> 
>     > On Thu, 27 Jun 2013 09:19:52 +0800 shencanquan <shencanquan at huawei.com <mailto:shencanquan@huawei.com>> wrote:
>     >
>     >> On 2013/6/27 5:18, Andrew Morton wrote:
>     >>
>     >>>
>     >>> My guess is that there is some other code path which is modifying
>     >>> inode->i_size without holding inode->i_mutex, and while holding
>     >>> ocfs2_inode_lock().  If so, that code is surely wrong - it should hold
>     >>> i_mutex while modifying i_size.
>     >>
>     >>
>     >> inode->i_mutex lock only protect the inode size on the same machine.
>     >
>     > ah ;)
>     >
>     >>> And all this is only really applicable to 32-bit CPUs, which you
>     >>> probably aren't using.
>     >>
>     >> I don't understand this.
>     >
>     > The i_size_read/i_size_write infrastructure is designed to efficiently
>     > handle the situation where a 32-bit machine reads a 64-bit number which
>     > might be undergoing modification on another CPU.  We don't want the
>     > reading CPU to see an invalid number when the writing CPU is in the
>     > middle of modifying the two 32-bit words.
>     >
>     >
>     >
> 
>     ok. thanks.
> 
> 
>     _______________________________________________
>     Ocfs2-devel mailing list
>     Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
>     https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
