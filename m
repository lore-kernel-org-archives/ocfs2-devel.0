From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 13:22:52 2008
Subject: [Ocfs2-devel] [PATCH 08/30] ocfs2: Handle struct f_path in
	struct file
In-Reply-To: <1199388006-32658-7-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-7-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080108212209.GH23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:44AM -0800, Sunil Mushran wrote:
> Commit 0f7fc9e4d03987fe29f6dd4aa67e4c56eb7ecb05 in mainline added
> struct path in struct file. This patch allows one to build ocfs2 with
> kernels having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
