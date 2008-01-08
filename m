From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:43:00 2008
Subject: [Ocfs2-devel] [PATCH 14/30] ocfs2: Handle enum value FS_OCFS2
In-Reply-To: <1199388006-32658-13-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-13-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108234103.GN23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:50AM -0800, Sunil Mushran wrote:
> Commit 0e03036c97b70b2602f7dedaa3a223ed7563c2c9 in mainline registers
> ocfs2 sysctl (FS_OCFS2) number under CTL_FS. This patch allows one to
> build ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
