From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 15:04:10 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/dlm: Make o2dlm domain
 join/leave messages KERN_NOTICE
In-Reply-To: <1271206831-3203-1-git-send-email-sunil.mushran@oracle.com>
References: <1271206831-3203-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100423220410.GD8330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 13, 2010 at 06:00:30PM -0700, Sunil Mushran wrote:
> o2dlm join and leave messages are more than informational as they are required
> is debugging locking issues. This patch changes them from KERN_INFO to KERN_NOTICE.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
