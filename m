From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Jul 2009 11:17:27 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/quota: Release lock for error in
 ocfs2_quota_write.
In-Reply-To: <1248941230-9113-1-git-send-email-tao.ma@oracle.com>
References: <1248941230-9113-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090730181726.GC7541@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 30, 2009 at 04:07:10PM +0800, Tao Ma wrote:
> ocfs2_quota_write needs to release the lock if it fails to
> read quota block. So use "goto out" instead of "return err".
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This fix is now in the fixes branch of ocfs2.git.

Joel

-- 

"Copy from one, it's plagiarism; copy from two, it's research."
        - Wilson Mizner

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
