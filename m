From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 12 Jun 2009 16:07:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/net: Use wait_event()
	in	o2net_send_message_vec()
In-Reply-To: <1244743323-6949-1-git-send-email-sunil.mushran@oracle.com>
References: <1244743323-6949-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090612230735.GG22662@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 11, 2009 at 11:02:03AM -0700, Sunil Mushran wrote:
> Replace wait_event_interruptible() with wait_event() in o2net_send_message_vec().
> This is because this function is called by the dlm that expects signals to be
> blocked.

	Added to the tree.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
