From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:01:27 2008
Subject: [Ocfs2-devel] [PATCH 21/30] ocfs2: Handle splice.h
In-Reply-To: <1199388006-32658-20-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-20-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109000053.GT23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:57AM -0800, Sunil Mushran wrote:
> Commit d6b29d7cee064f28ca097e906de7453541351095 in mainline moves the splice
> structures from pipe_fs_i.h to splice.h. This patch allows one to build
> ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
