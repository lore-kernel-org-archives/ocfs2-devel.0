From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 27 Dec 2010 12:52:42 -0800
Subject: [Ocfs2-devel] [PATCH -next] ocfs2: fix build for OCFS2_FS_STATS
	not enabled
In-Reply-To: <20101227115508.8136331b.randy.dunlap@oracle.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	<20101227115508.8136331b.randy.dunlap@oracle.com>
Message-ID: <20101227205242.GA30474@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Fasheh <mfasheh@suse.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Mon, Dec 27, 2010 at 11:55:08AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_OCFS2_FS_STATS is not enabled:
> 
> fs/ocfs2/cluster/tcp.c:1254: error: implicit declaration of function 'o2net_update_recv_stats'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Mark Fasheh <mfasheh@suse.com>
> Cc:	Joel Becker <joel.becker@oracle.com>
> Cc:	ocfs2-devel at oss.oracle.com

Acked-by: Joel Becker <joel.becker@oracle.com>

Do you want to push it or would you like me to?

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
