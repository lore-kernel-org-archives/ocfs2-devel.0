From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:13:47 2008
Subject: [Ocfs2-devel] [PATCH 25/30] ocfs2: Handle missing const s_op
	in struct super_block
In-Reply-To: <1199388006-32658-24-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-24-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109001339.GW23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:20:01AM -0800, Sunil Mushran wrote:
> Commit ee9b6d61a2a43c5952eb43283f8db284a4e70b8a in mainline marks
> struct super_operations as a const in struct super_block. This patch
> allows one to build with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
