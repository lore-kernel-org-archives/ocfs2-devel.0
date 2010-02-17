From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 16 Feb 2010 22:16:08 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a refcount condition checking
 -v2
In-Reply-To: <201002090658.o195naM8009406@rcsinet15.oracle.com>
References: <201002090658.o195naM8009406@rcsinet15.oracle.com>
Message-ID: <20100217061608.GK13798@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 09, 2010 at 02:57:45PM +0800, Wengang Wang wrote:
> We disable DIO write if the inode has reflink. The way to determine if the inode
> has reflink is wrong in case (!has_refcount && direct_io). The patch fixes it.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

This patch, with a modified description, is now in the 'merge-window'
branch of ocfs2.git.

Joel

-- 

"There is a country in Europe where multiple-choice tests are
 illegal."
        - Sigfried Hulzer

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
