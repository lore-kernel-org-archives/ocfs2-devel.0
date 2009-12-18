From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Dec 2009 21:11:46 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Handle O_DIRECT when writing to a
 refcounted cluster.
In-Reply-To: <1259848505-8049-1-git-send-email-tao.ma@oracle.com>
References: <1259848505-8049-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20091218051145.GD20149@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 03, 2009 at 09:55:05PM +0800, Tao Ma wrote:
> In case of writing to a refcounted cluster with O_DIRECT,
> we need to fall back to buffer write. And when it is finished,
> we need to flush the page and the journal as we did for other
> O_DIRECT writes.
> 
> This patch fix oss bug 1191.
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1191

	This patch is now in the 'fixes' branch of ocfs2.git.

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
