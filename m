From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 13 May 2010 16:44:53 -0700
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Do not map blocks from local
 quota file on each write
In-Reply-To: <1273780683-3638-3-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<1273780683-3638-3-git-send-email-jack@suse.cz>
Message-ID: <20100513234453.GD13692@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 13, 2010 at 09:57:58PM +0200, Jan Kara wrote:
> There is no need to map offset of local dquot structure to on disk block
> in each quota write. It is enough to map it just once and store the physical
> block number in quota structure in memory. Moreover this simplifies locking
> as we do not have to take ip_alloc_sem from quota write path.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

	Am I correct that quota files cannot be shrunk in a running
filesystem?

Joel

-- 

"Reader, suppose you were and idiot.  And suppose you were a member of
 Congress.  But I repeat myself."
	- Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
