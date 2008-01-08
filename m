From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:57:19 2008
Subject: [Ocfs2-devel] [PATCH 20/30] ocfs2: Handle missing iop->fallocate()
In-Reply-To: <1199388006-32658-19-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-19-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108235647.GS23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:56AM -0800, Sunil Mushran wrote:
> Commit 97ac73506c0ba93f30239bb57b4cfc5d73e68a62 in mainline introduces a
> new iop, fallocate(). This patch allows one to build ocfs2 with kernels
> having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
