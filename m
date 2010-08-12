From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Aug 2010 17:32:55 -0700
Subject: [Ocfs2-devel] [PATCH 2/2 v3] ocfs2: Remove ocfs2_sync_inode()
In-Reply-To: <1281033166-12485-3-git-send-email-jack@suse.cz>
References: <1281033166-12485-1-git-send-email-jack@suse.cz>
	<1281033166-12485-3-git-send-email-jack@suse.cz>
Message-ID: <20100812003255.GF8985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 05, 2010 at 08:32:46PM +0200, Jan Kara wrote:
> ocfs2_sync_inode() is used only from ocfs2_sync_file(). But all data has
> already been written before calling ocfs2_sync_file() and ocfs2 doesn't use
> inode's private_list for tracking metadata buffers thus sync_mapping_buffers()
> is superfluous as well.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>


        This patch is now in the merge-window branch of ocfs2.git

Joel
 

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
