From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 15:57:21 2008
Subject: [Ocfs2-devel] [PATCH 19/30] ocfs2: Handle missing macro
	is_owner_or_cap()
In-Reply-To: <1199388006-32658-18-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-18-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108235612.GR23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:55AM -0800, Sunil Mushran wrote:
> Commit 3bd858ab1c451725c07a805dcb315215dc85b86e in mainline introduces
> helper macro is_owner_or_cap(). This patch allows one to build ocfs2 with
> kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
