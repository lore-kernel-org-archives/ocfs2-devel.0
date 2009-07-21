From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 20 Jul 2009 17:38:26 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] fails ocfs2_get_block() immediately
 when hit -EIO
In-Reply-To: <200907130340.n6D3eBcx019309@rgminet15.oracle.com>
References: <200907130340.n6D3eBcx019309@rgminet15.oracle.com>
Message-ID: <20090721003826.GD9183@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 13, 2009 at 11:38:58AM +0800, Wengang Wang wrote:
>   fails ocfs2_get_block() immediately when hit -EIO
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This change is in the fixes branch of ocfs2.git.  Again, I modified the
commit message to describe what actually is going on.

Joel


-- 

"To announce that there must be no criticism of them president, or
 that we are to stand by the president, right or wrong, is not only
 unpatriotic and servile, but is morally treasonable to the American
 public."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
