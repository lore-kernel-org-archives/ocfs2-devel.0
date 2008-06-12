From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Jun 2008 11:45:45 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 2/3] configfs: call drop_link() to
	cleanup after	create_link() failure
In-Reply-To: <20080612152953.667564205@kerlabs.com>
References: <20080612152645.445504681@kerlabs.com>
	<20080612152953.667564205@kerlabs.com>
Message-ID: <20080612184545.GD5377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 05:26:47PM +0200, Louis Rilling wrote:
> When allow_link() succeeds but create_link() fails, the subsystem is not
> informed of the failure.
> 
> This patch fixes this by calling drop_link() on create_link() failures.
> 
> Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>

This looks good.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
