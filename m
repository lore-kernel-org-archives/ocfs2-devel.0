From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 27 Feb 2010 20:11:19 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new filesize
 exceeds limit -v2
In-Reply-To: <201002261020.o1Q7k5dF028352@acsinet15.oracle.com>
References: <201002261020.o1Q7k5dF028352@acsinet15.oracle.com>
Message-ID: <20100228041119.GD20343@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 06:18:25PM +0800, Wengang Wang wrote:
> This patch makes ocfs2 send SIGXFSZ if new file size exceeds limit and abort the
> operation.
> No suprise that processes get SIGXFSZ on one node(in the cluster) while they
> don't on another if file size limits are different on the two nodes.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
