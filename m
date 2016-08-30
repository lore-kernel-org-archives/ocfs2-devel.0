From: David Howells <dhowells@redhat.com>
Date: Tue, 30 Aug 2016 20:36:25 +0100
Subject: [Ocfs2-devel] [PATCH 0/9] Remove deprecated
	create_singlethread_workqueue
In-Reply-To: <cover.1472578959.git.bhaktipriya96@gmail.com>
References: <cover.1472578959.git.bhaktipriya96@gmail.com>
Message-ID: <22296.1472585785@warthog.procyon.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: dhowells@redhat.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Andrew Morton <akpm@linux-foundation.org>, Joseph Qi <joseph.qi@huawei.com>, "Norton.Zhu" <norton.zhu@huawei.com>, Jun Piao <piaojun@huawei.com>, xuejiufei <xuejiufei@huawei.com>, ocfs2-devel@oss.oracle.com, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Bhaktipriya Shridhar <bhaktipriya96@gmail.com> wrote:

> This patch set removes deprecated create_singlethread_workqueue
> usages in fs/.
> 
> Bhaktipriya Shridhar (9):
>   fs/afs/vlocation: Remove deprecated create_singlethread_workqueue
>   fs/afs/rxrpc: Remove deprecated create_singlethread_workqueue
>   fs/afs/callback: Remove deprecated create_singlethread_workqueue
>   fs/afs/flock: Remove deprecated create_singlethread_workqueue

I'm removing the workqueue in fs/afs/rxrpc.c in one of my patches.  Can I take
your other three AFS patches myself and leave someone else to handle the
non-AFS patches?

David
