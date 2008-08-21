From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 11:46:58 +0800
Subject: [Ocfs2-devel] [PATCH 02/10] ocfs2: Prefix the ocfs2_extent_tree
	structure.
In-Reply-To: <1219286905-28104-3-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-3-git-send-email-joel.becker@oracle.com>
Message-ID: <48ACE532.7000003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> The members of the ocfs2_extent_tree structure gain a prefix of 'et_'.
> All users are updated.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>   
Signed-off-by: Tao Ma <tao.ma@oracle.com>
