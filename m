From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 15:18:54 -0700
Subject: [Ocfs2-devel] [PATCH 08/20] ocfs2/dlm: Add message
 DLM_QUERY_NODEINFO
In-Reply-To: <1284504656-2434-9-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-9-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923221854.GB803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:44PM -0700, Sunil Mushran wrote:
> Adds new dlm message DLM_QUERY_NODEINFO that sends the attributes of all
> registered nodes. This message is sent if the negotiated dlm protocol is
> 1.1 or higher. If the information of the joining node does not match
> that of any existing nodes, the join domain request is rejected.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	I don't think you should be bumping the actual protocol before
all 1.1 messages are in the code.  Otherwise, someone bisecting between
the QUERY_REGION and QUEYR_NODEINFO patches might have real problems.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
