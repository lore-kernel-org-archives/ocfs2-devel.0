From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 8 Feb 2010 13:04:48 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: Make o2net connect
	messages KERN_NOTICE
In-Reply-To: <1265413284-17330-1-git-send-email-sunil.mushran@oracle.com>
References: <1265413284-17330-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100208210448.GC1832@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 03:41:23PM -0800, Sunil Mushran wrote:
> Connect and disconnect messages are more than informational as they are required
> during root cause analysis for failures. This patch changes them from KERN_INFO
> to KERN_NOTICE.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
