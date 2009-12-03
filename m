From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 17:37:47 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: refcounttree.c cleanup.
In-Reply-To: <1259564920-9833-1-git-send-email-tao.ma@oracle.com>
References: <1259564920-9833-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20091203013747.GD31647@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 30, 2009 at 03:08:40PM +0800, Tao Ma wrote:
> sparse check finds some endian problem and some other minor issues.
> There is an obsolete function which should be removed.
> So this patch resolve all these.

	This is now in the fixes branch of ocfs2.git

Joel

-- 

"The whole problem with the world is that fools and fanatics are always
 so certain of themselves, and wiser people so full of doubts."
	- Bertrand Russell

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
