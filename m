From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 26 Feb 2010 14:50:09 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Only bug out in direct io write
 for reflinked extent.
In-Reply-To: <1267152892-15727-1-git-send-email-tao.ma@oracle.com>
References: <1267152892-15727-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100226225009.GB23730@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 26, 2010 at 10:54:52AM +0800, Tao Ma wrote:
> In ocfs2_direct_IO_get_blocks, we only need to bug out
> in case of we are going to write a recounted extent rec.
> 
> What a silly bug introduced by me!
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the merge-window branch of ocfs2.git

Joel

-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
	- Alexander Viro

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
