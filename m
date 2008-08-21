From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 12:29:01 +0800
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Add an insertion check to
	ocfs2_extent_tree_operations.
In-Reply-To: <1219286905-28104-10-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-10-git-send-email-joel.becker@oracle.com>
Message-ID: <48ACEF0D.2080304@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> The op eo_sanity_check() was really a check on remove_right_path().
> Let's call it eo_remove_check().  Let's add an eo_insert_check() that
> can be called from ocfs2_insert_extent().
>   
eo_sanity_check is used to check inode, and I don't see there is any 
hint of remove_right_path in this function although it is now only used 
in ocfs2_remove_rightmost_path. And I have said in the previous 
e-mail,it can be used in ocfs2_num_free_extents.
So I'd like to reserve the name and your add for insert_check is OK or 
it can be moved to ocfs2_*_insert_extent.

Regards,
Tao
