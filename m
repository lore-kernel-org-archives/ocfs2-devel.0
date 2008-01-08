From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:19:58 2008
Subject: [Ocfs2-devel] [PATCH 28/30] ocfs2: Handle missing
	__splice_from_pipe()
In-Reply-To: <1199388006-32658-27-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-27-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109001803.GZ23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:20:04AM -0800, Sunil Mushran wrote:
> Commit c66ab6fa705e1b2887a6d9246b798bdc526839e2 in mainline introduced
> __splice_from_pipe(). This patch allows one to build ocfs2 with kernels
> having/not having this change.
> 
> Note: This patch disables splice io for kernels not providing
> __splice_from_pipe(). We will later add a patch to enable splice
> io with such kernels too.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
