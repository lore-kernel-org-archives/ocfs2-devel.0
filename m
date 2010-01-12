From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 Jan 2010 16:38:03 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix refcnt leak on
 ocfs2_fast_follow_link() error path
In-Reply-To: <87eilwjxmu.fsf@devron.myhome.or.jp>
References: <87eilwjxmu.fsf@devron.myhome.or.jp>
Message-ID: <20100112003803.GC20285@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:37:45AM +0900, OGAWA Hirofumi wrote:
> 
> If ->follow_link handler return the error, it should decrement
> nd->path refcnt. But, ocfs2_fast_follow_link() doesn't decrement.
> 
> This patch fix it by using usual nd_set_link() style error handling,
> instead of playing with nd->path.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
