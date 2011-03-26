From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 26 Mar 2011 15:48:36 -0700
Subject: [Ocfs2-devel] [PATCH] fs,
 ocfs2: Move o2net_get_func_run_time under CONFIG_OCFS2_FS_STATS.
In-Reply-To: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
References: <AANLkTi=uysftkFdzEE2Xshg3br_tFB=hhZ4BwX-TzLm0@mail.gmail.com>
Message-ID: <20110326224836.GD8837@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>, Sunil Mushran <sunil.mushran@oracle.com>

On Fri, Mar 18, 2011 at 05:01:08PM +0600, Rakib Mullick wrote:
> When CONFIG_DEBUG_FS=y and CONFIG_OCFS2_FS_STATS=n, we get the
> following warning:
> 
> fs/ocfs2/cluster/tcp.c:213:16: warning: ?o2net_get_func_run_time?
> defined but not used
> 
> Since o2net_get_func_run_time is only called from
> o2net_update_recv_stats, so move it under CONFIG_OCFS2_FS_STATS.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"Here's a nickle -- get yourself a better X server."
	- Keith Packard

			http://www.jlbec.org/
			jlbec at evilplan.org
