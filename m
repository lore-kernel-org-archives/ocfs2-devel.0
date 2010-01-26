From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 25 Jan 2010 17:17:37 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2/dlm: Handle EAGAIN for
	compatibility
In-Reply-To: <1264467461-1881-4-git-send-email-sunil.mushran@oracle.com>
References: <1264467461-1881-1-git-send-email-sunil.mushran@oracle.com>
	<1264467461-1881-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100126011736.GB15982@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 25, 2010 at 04:57:41PM -0800, Sunil Mushran wrote:
> Mainline commit aad1b15310b9bcd59fa81ab8f2b1513b59553ea8 made
> dlm_begin_reco_handler() return -EAGAIN instead of EAGAIN.
> 
> This patch makes dlm_send_begin_reco_message() handle both
> error numbers for compatibility reasons.

	Oh, foo, was that over the wire?  Please mention that in the
comment.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
