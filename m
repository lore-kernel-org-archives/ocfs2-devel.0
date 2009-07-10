From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Jul 2009 16:55:43 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] a fix of logging return value.
In-Reply-To: <200907100528.n6A5Sv4J030693@acsinet15.oracle.com>
References: <200907100528.n6A5Sv4J030693@acsinet15.oracle.com>
Message-ID: <20090710235543.GD20661@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 10, 2009 at 01:26:04PM +0800, Wengang Wang wrote:
> 	in ocfs2_file_aio_write(), log_exit() could don't log the value
> which is really returned. this patch fixes it.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch is now in the fixes branch of ocfs2.git

Joel


-- 

Life's Little Instruction Book #207

	"Swing for the fence."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
