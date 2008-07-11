From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 11 Jul 2008 13:05:41 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 2/2] configfs: Lock new
	directory inodes	before removing on cleanup after failure
In-Reply-To: <1215183366-17479-3-git-send-email-louis.rilling@kerlabs.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
	<1215183366-17479-3-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080711200541.GB22577@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: joel.becker@hawkmoon.kerlabs.com, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jul 04, 2008 at 04:56:06PM +0200, Louis Rilling wrote:
> Changelog:
>   - Improve comments and braces as requested by Joel

	Also looking good, I want to test them and then send them along.

Joel

-- 

"When I am working on a problem I never think about beauty. I
 only think about how to solve the problem. But when I have finished, if
 the solution is not beautiful, I know it is wrong."
         - Buckminster Fuller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
