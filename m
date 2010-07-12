From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 11:33:27 -0700
Subject: [Ocfs2-devel] [PATCH 2/2 v2] ocfs2: Make xattr reflink work
 with new local alloc reservation.
In-Reply-To: <1278658392-22009-2-git-send-email-tao.ma@oracle.com>
References: <1278658392-22009-1-git-send-email-tao.ma@oracle.com>
	<1278658392-22009-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20100712183327.GE12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 09, 2010 at 02:53:12PM +0800, Tao Ma wrote:
> The new reservation code in local alloc has add the limitation
> that the caller should handle the case that the local alloc
> doesn't give use enough contiguous clusters. It make the old
> xattr reflink code broken.
> 
> So this patch udpate the xattr reflink code so that it can
> handle the case that local alloc give us one cluster at a time.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch, with the gcc warning fixed, is now in the fixes
branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #109

	"Know how to drive a stick shift."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
