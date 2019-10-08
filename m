From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 8 Oct 2019 21:18:25 +0200
Subject: [Ocfs2-devel] [PATCH -next] treewide: remove unused argument in
	lock_release()
In-Reply-To: <20191008163351.GR16989@phenom.ffwll.local>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
	<20191008163351.GR16989@phenom.ffwll.local>
Message-ID: <20191008191825.GH2328@hirez.programming.kicks-ass.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>, akpm@linux-foundation.org, mingo@redhat.com, will@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, sean@poorly.run, airlied@linux.ie, dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org, jslaby@suse.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org, tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, tj@kernel.org, mark@fasheh.com, jlbec@evilplan.or, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, davem@davemloft.net, st@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, alexander.levin@microsoft.com

On Tue, Oct 08, 2019 at 06:33:51PM +0200, Daniel Vetter wrote:
> On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> > Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> > in __lock_release"), @nested is no longer used in lock_release(), so
> > remove it from all lock_release() calls and friends.
> > 
> > Signed-off-by: Qian Cai <cai@lca.pw>
> 
> Ack on the concept and for the drm parts (and feel free to keep the ack if
> you inevitably have to respin this later on). Might result in some
> conflicts, but welp we need to keep Linus busy :-)
> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Thanks Daniel!
