From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Aug 2010 17:31:07 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add some trace log for orphan scan.
In-Reply-To: <1275371893-6452-1-git-send-email-tao.ma@oracle.com>
References: <1275371893-6452-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100812003107.GB8985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 01, 2010 at 01:58:13PM +0800, Tao Ma wrote:
> Now orphan scan worker has no trace log, so it is
> very hard to tell whether it is finished or blocked.
> So add 2 mlog trace log so that we can tell whether
> the current orphan scan worker is blocked or not.
> It does help when I analyzed a orphan scan bug.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

        This patch is now in the merge-window branch of ocfs2.git.

Joel


-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
