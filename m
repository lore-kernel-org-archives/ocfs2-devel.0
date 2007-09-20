From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:43:34 2007
Subject: [Ocfs2-devel] [PATCH 06/15] ocfs2: Remove open coded readdir()
In-Reply-To: <200709192012.l8JKCGEE029300@rgmgw2.us.oracle.com>
References: <200709192012.l8JKCGEE029300@rgmgw2.us.oracle.com>
Message-ID: <20070920184257.GI30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 10, 2007 at 05:50:51PM -0700, Mark Fasheh wrote:
> ocfs2_queue_orphans() has an open coded readdir loop which can easily just
> use a directory accessor function.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

	Nice cleanup.

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

"Drake!  We're LEAVING!"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
