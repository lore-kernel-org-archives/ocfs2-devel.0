From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:45:33 2007
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: Implement ocfs2_empty_dir()
	as a caller of ocfs2_dir_foreach()
In-Reply-To: <200709192012.l8JKCGWI012183@agmgw2.us.oracle.com>
References: <200709192012.l8JKCGWI012183@agmgw2.us.oracle.com>
Message-ID: <20070920184457.GJ30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 12, 2007 at 11:19:00AM -0700, Mark Fasheh wrote:
> We can preserve the behavior of ocfs2_empty_dir(), while getting rid of the
> open coded directory walk by just providing a smart filldir callback. This
> also automatically gets to use the dir readahead code, though in this case
> any advantage is minor at best.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

	The filldir tricks are tasty.

Signed-off-by: Joel Becker <joel.becker@oracle.com>


-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
