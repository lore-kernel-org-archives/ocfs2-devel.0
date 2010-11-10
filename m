From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Nov 2010 01:41:34 -0800
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: Remove unused truncate
	function from alloc.c
In-Reply-To: <1289357543-2538-1-git-send-email-tao.ma@oracle.com>
References: <4CDA08B6.2070002@oracle.com>
	<1289357543-2538-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20101110094134.GB31158@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 10, 2010 at 10:52:19AM +0800, Tao Ma wrote:
> Tristan Ye has done some refactoring against our truncate
> process, so some functions like ocfs2_prepare_truncate and
> ocfs2_free_truncate_context are no use and we'd better
> remove them.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	Obviously correct.

Joel
 

-- 

"Hell is oneself, hell is alone, the other figures in it, merely projections."
        - T. S. Eliot

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
