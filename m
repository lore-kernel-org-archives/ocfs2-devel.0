From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 17 Jun 2020 13:57:43 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: avoid inode removed while nfsd
	access it
In-Reply-To: <b8f64191-74fc-0f15-affc-e8e518b17bd1@linux.alibaba.com>
References: <20200616183829.87211-1-junxiao.bi@oracle.com>
	<20200616183829.87211-2-junxiao.bi@oracle.com>
	<b8f64191-74fc-0f15-affc-e8e518b17bd1@linux.alibaba.com>
Message-ID: <20200617135743.18d9a4add21acaac12da23d2@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 17 Jun 2020 11:01:12 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> On 2020/6/17 02:38, Junxiao Bi wrote:
> > When nfsd is getting file dentry using handle or parent dentry of some
> > dentry, one cluster lock is used to avoid inode removed from other node,
> > but it still could be removed from local node, so use a rw lock to avoid
> > this.
> > 
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Which kernel version(s) do we think need these four patches?  5.9? 
5.8?  5.8 and -stable?
