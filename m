From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 16 Jun 2010 14:23:54 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Limit default local alloc size
 within bitmap range.
In-Reply-To: <1276072985-7251-1-git-send-email-tao.ma@oracle.com>
References: <1276072985-7251-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100616212354.GC14109@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 04:43:05PM +0800, Tao Ma wrote:
> In commit 6b82021b9e91cd689fdffadbcdb9a42597bbe764, we increase
> our local alloc size and calculate how much megabytes we can
> get according to group size and volume size.
> But we also need to check the maximum bits a local alloc block
> bitmap can have. With a bs=512, cs=32K, local volume with 160G,
> it calculate 96MB while the maximum local alloc size is only
> 76M. So the bitmap will overflow and corrupt the system truncate
> log file. See bug
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1262
> 
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
