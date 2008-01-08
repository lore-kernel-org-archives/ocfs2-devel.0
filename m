From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 13:24:57 2008
Subject: [Ocfs2-devel] [PATCH 10/30] ocfs2: Add helper inc_nlink
In-Reply-To: <1199388006-32658-9-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-9-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108212344.GJ23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:46AM -0800, Sunil Mushran wrote:
> Commit d8c76e6f45c111c32a4b3e50a2adc9210737b0d8 in mainline introduced
> helper inc_nlink(). This patch allows one to build ocfs2 with kernels
> having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
