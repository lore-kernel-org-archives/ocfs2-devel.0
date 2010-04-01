From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 17:52:07 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: one more warning fix in
 ocfs2_file_aio_write(), v2
In-Reply-To: <4BABD260.4070600@suse.de>
References: <4BABD260.4070600@suse.de>
Message-ID: <20100401005207.GD28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 26, 2010 at 05:15:12AM +0800, Coly Li wrote:
> This patch fixes another compiling warning in ocfs2_file_aio_write() like this,
>     fs/ocfs2/file.c: In function ?ocfs2_file_aio_write?:
>     fs/ocfs2/file.c:2026: warning: suggest parentheses around ?&&? within ?||?
> 
> As Joel suggested, '!ret' is unary, this version removes the wrap from '!ret'.

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
