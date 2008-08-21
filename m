From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 11:47:29 +0800
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Prefix the extent tree
	operations structure.
In-Reply-To: <1219286905-28104-2-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-2-git-send-email-joel.becker@oracle.com>
Message-ID: <48ACE551.404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> The ocfs2_extent_tree_operations structure gains a field prefix on its
> members.  The ->eo_sanity_check() operation gains a wrapper function for
> completeness.  All of the extent tree operation wrappers gain a
> consistent name (ocfs2_et_*()).
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>   
Signed-off-by: Tao Ma <tao.ma@oracle.com>
