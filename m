From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 13:16:41 2008
Subject: [Ocfs2-devel] [PATCH 04/30] ocfs2: Handle macro uninitialized_var
In-Reply-To: <1199388006-32658-3-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108211610.GD23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:40AM -0800, Sunil Mushran wrote:
> Commit 9490991482a2091a828d997adbc088e24c310a4d in mainline introduced
> macro uninitialized_var(). This patch allows one to build ocfs2 with
> kernels having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
