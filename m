From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 31 16:49:37 2007
Subject: [Ocfs2-devel] [PATCH 4/7] ocfs2: slot_map I/O based on i_size.
In-Reply-To: <1197004787-15344-5-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
	<1197004787-15344-5-git-send-email-joel.becker@oracle.com>
Message-ID: <20080101004838.GA23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 06, 2007 at 09:19:44PM -0800, Joel Becker wrote:
> The slot map code assumed a slot_map file has one block allocated.
> This changes the code to I/O as many blocks as will cover i_size.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>


--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
