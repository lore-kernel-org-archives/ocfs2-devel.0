From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:30:21 2007
Subject: [Ocfs2-devel] [PATCH 03/15] ocfs2: Move directory manipulation
	code into dir.c
In-Reply-To: <200709192012.l8JKCGjS012156@agmgw2.us.oracle.com>
References: <200709192012.l8JKCGjS012156@agmgw2.us.oracle.com>
Message-ID: <20070920182944.GF30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 07, 2007 at 06:21:26PM -0700, Mark Fasheh wrote:
> The code for adding, removing, deleting directory entries was splattered all
> over namei.c. I'd rather have this all centralized, so that it's easier to
> make changes for inline dir data, and eventually indexed directories.
> 
> None of the code in any of the functions was changed. I only removed the
> static keyword from some prototypes so that they could be exported.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>
-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
