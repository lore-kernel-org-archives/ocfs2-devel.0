From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Jun 2009 16:32:12 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Update atime in splice read if
	necessary.
In-Reply-To: <1245397012-20648-1-git-send-email-tao.ma@oracle.com>
References: <1245397012-20648-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090619233212.GP29140@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 03:36:52PM +0800, Tao Ma wrote:
> We should call ocfs2_inode_lock_atime instead of ocfs2_inode_lock
> in ocfs2_file_splice_read like we do in ocfs2_file_aio_read so
> that we can update atime in splice read if necessary.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This is now in the fixes branch of ocfs2.git.

Joel

-- 

"Heav'n hath no rage like love to hatred turn'd, nor Hell a fury,
 like a woman scorn'd."
        - William Congreve

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
