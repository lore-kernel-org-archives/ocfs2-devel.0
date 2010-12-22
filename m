From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 22 Dec 2010 03:57:43 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix system inodes cache overflow.
In-Reply-To: <1293011430-2376-1-git-send-email-tm@tao.ma>
References: <1293011430-2376-1-git-send-email-tm@tao.ma>
Message-ID: <20101222115743.GA12851@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 22, 2010 at 05:50:30PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we store system inodes cache in ocfs2_super,
> we use a array for global system inodes. But unfortunately,
> the range is calculated wrongly which makes it overflow and
> pollute ocfs2_super->local_system_inodes.
> This patch fix it by setting the range properly.
> 
> The corresponding bug is ossbug1303.
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1303
> 
> Cc: stable at kernel.org
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Viro's Razor:
	Any race condition, no matter how unlikely, will occur just
	often enough to bite you.

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
