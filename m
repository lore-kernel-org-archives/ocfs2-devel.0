From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 21 Feb 2011 22:09:13 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <1298350792-6734-1-git-send-email-tristan.ye@oracle.com>
References: <1298350792-6734-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20110222060913.GA30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 12:59:51PM +0800, Tristan Ye wrote:
> +	oifi = kzalloc(sizeof(struct ocfs2_info_freeinode), GFP_NOFS);

	Why NOFS?  Are we under any filesystem locks?  I'm pretty sure
this is the first thing you do for this operation, so why wouldn't
GFP_KERNEL work?

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

			http://www.jlbec.org/
			jlbec at evilplan.org
