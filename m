From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 30 Sep 2019 07:44:43 -0000
Subject: [Ocfs2-devel] [PATCH -next] treewide: remove unused argument in
	lock_release()
In-Reply-To: <1568909380-32199-1-git-send-email-cai@lca.pw>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
Message-ID: <20190930072938.GK4553@hirez.programming.kicks-ass.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, mingo@redhat.com, will@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, jslaby@suse.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, tj@kernel.org, mark@fasheh.com, jlbec@evilplan.or, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, davem@davemloft.net, st@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, alexander.levin@microsoft.com

On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> in __lock_release"), @nested is no longer used in lock_release(), so
> remove it from all lock_release() calls and friends.

Right; I never did this cleanup for not wanting the churn, but as long
as it applies I'll take it.

> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  drivers/gpu/drm/drm_connector.c               |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |  6 +++---
>  drivers/gpu/drm/i915/gt/intel_engine_pm.c     |  2 +-
>  drivers/gpu/drm/i915/i915_request.c           |  2 +-
>  drivers/tty/tty_ldsem.c                       |  8 ++++----
>  fs/dcache.c                                   |  2 +-
>  fs/jbd2/transaction.c                         |  4 ++--
>  fs/kernfs/dir.c                               |  4 ++--
>  fs/ocfs2/dlmglue.c                            |  2 +-
>  include/linux/jbd2.h                          |  2 +-
>  include/linux/lockdep.h                       | 21 ++++++++++-----------
>  include/linux/percpu-rwsem.h                  |  4 ++--
>  include/linux/rcupdate.h                      |  2 +-
>  include/linux/rwlock_api_smp.h                | 16 ++++++++--------
>  include/linux/seqlock.h                       |  4 ++--
>  include/linux/spinlock_api_smp.h              |  8 ++++----
>  include/linux/ww_mutex.h                      |  2 +-
>  include/net/sock.h                            |  2 +-
>  kernel/bpf/stackmap.c                         |  2 +-
>  kernel/cpu.c                                  |  2 +-
>  kernel/locking/lockdep.c                      |  3 +--
>  kernel/locking/mutex.c                        |  4 ++--
>  kernel/locking/rtmutex.c                      |  6 +++---
>  kernel/locking/rwsem.c                        | 10 +++++-----
>  kernel/printk/printk.c                        | 10 +++++-----
>  kernel/sched/core.c                           |  2 +-
>  lib/locking-selftest.c                        | 24 ++++++++++++------------
>  mm/memcontrol.c                               |  2 +-
>  net/core/sock.c                               |  2 +-
>  tools/lib/lockdep/include/liblockdep/common.h |  3 +--
>  tools/lib/lockdep/include/liblockdep/mutex.h  |  2 +-
>  tools/lib/lockdep/include/liblockdep/rwlock.h |  2 +-
>  tools/lib/lockdep/preload.c                   | 16 ++++++++--------
>  33 files changed, 90 insertions(+), 93 deletions(-)

Thanks!
