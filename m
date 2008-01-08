From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 13:18:43 2008
Subject: [Ocfs2-devel] [PATCH 05/30] ocfs2: Handle macro zero_user_page()
In-Reply-To: <1199388006-32658-4-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108211648.GE23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:41AM -0800, Sunil Mushran wrote:
> Commit 01f2705daf5a36208e69d7cf95db9c330f843af6 in mainline introduced
> macro zero_user_page(). This patch allows one to build ocfs2 with
> kernels having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
