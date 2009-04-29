From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 29 Apr 2009 11:28:26 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Remove unused variable in
	ocfs2_rename.
In-Reply-To: <1240939255-22590-1-git-send-email-tao.ma@oracle.com>
References: <1240939255-22590-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090429182826.GD4743@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 29, 2009 at 01:20:55AM +0800, Tao Ma wrote:
> With indexed dir enabled, now we use ocfs2_dir_lookup_result to
> wrap all the bh used for dir. So remove the 2 unused variables.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

Thanks Tao, this is added to the fixes branch.

Joel


-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd at loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
