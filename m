From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 17 Dec 2019 18:23:11 -0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: call journal flush to mark
 journal as empty after journal recovery when mount
In-Reply-To: <339c2bfc-fc40-77f1-3515-eb90e34854f6@gmail.com>
References: <20191217020140.2197-1-li.kai4@h3c.com>
	<339c2bfc-fc40-77f1-3515-eb90e34854f6@gmail.com>
Message-ID: <20191217182311.6696bbe6f03b5ea81bc96082@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903@gmail.com>
Cc: Kai Li <li.kai4@h3c.com>, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, chge@linux.alibaba.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, 17 Dec 2019 10:12:14 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> > Due to first commit seq 13 recorded in journal super is not consistent
> > with the value recorded in block 1(seq is 14), journal recovery will be
> > terminated before seq 15 even though it is an unbroken commit, inode
> > 8257802 is a new file and it will be lost.
> > 
> > Signed-off-by: Kai Li <li.kai4@h3c.com>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Do we think this fix should be backported into -stable kernels?
