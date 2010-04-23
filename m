From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 23 Apr 2010 15:03:42 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: make
	ocfs2_adjust_resv_from_alloc simple.
In-Reply-To: <1270715582-13702-1-git-send-email-tao.ma@oracle.com>
References: <20100407212423.GP11402@wotan.suse.de>
	<1270715582-13702-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100423220342.GC8330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 08, 2010 at 04:33:02PM +0800, Tao Ma wrote:
> When we allocate some bits from the reservation, we always
> allocate from the r_start(see ocfs2_resmap_resv_bits).
> So there should be no sense for checking between r_start
> and start. And I don't think we will change this behaviour
> somehow later by allocating from some bits after r_start.
> Why not make ocfs2_adjust_resv_from_alloc simple now?
> 
> So the only chance we have to adjust the reservation is that
> we haven't reached the end. With this patch, the function is
> more readable.
> 
> Note:
> btw, this patch also fixes an original bug in the function
> which I haven't found before.
> 	if (end < ocfs2_resv_end(resv))
> 		rhs = end - ocfs2_resv_end(resv);
> This code is of course buggy. ;)
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the 'merge-window' branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
