From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 24 Jan 2014 14:02:49 -0800
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: fix ocfs2_sync_file() if
	filesystem is	readonly
In-Reply-To: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
References: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20140124220249.GE24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 12:46:59PM -0800, akpm at linux-foundation.org wrote:
> From: Younger Liu <younger.liucn@gmail.com>
> Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
> 
> If filesystem is readonly, there is no need to flush drive's caches or
> force any uncommitted transactions.
> 
> Signed-off-by: Younger Liu <younger.liucn@gmail.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Looks good, thanks for this.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
