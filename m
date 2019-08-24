From: Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 24 Aug 2019 13:50:58 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs/ocfs2/namei.c: remove set but not
	used variables
In-Reply-To: <1566522588-63786-2-git-send-email-joseph.qi@linux.alibaba.com>
References: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
	<1566522588-63786-2-git-send-email-joseph.qi@linux.alibaba.com>
Message-ID: <20190824135058.abbb4a84e92b560941e68474@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 23 Aug 2019 09:09:46 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> From: zhengbin <zhengbin13@huawei.com>
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> fs/ocfs2/namei.c: In function ocfs2_create_inode_in_orphan:
> fs/ocfs2/namei.c:2503:23: warning: variable di set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Reviewed-by: Changwei Ge <chge@linux.alibaba.com>

Thanks.  I added your Signed-off-by: to these, as you were on the patch
delivery path.
