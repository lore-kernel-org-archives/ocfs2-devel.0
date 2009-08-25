From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 25 Aug 2009 11:58:39 -0700
Subject: [Ocfs2-devel] [PATCH 05/17] ocfs2: Use __generic_file_aio_write
 instead of generic_file_aio_write_nolock
In-Reply-To: <1250875447-15622-6-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-6-git-send-email-jack@suse.cz>
Message-ID: <20090825185839.GB9812@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Fri, Aug 21, 2009 at 07:23:55PM +0200, Jan Kara wrote:
> Use the new helper. We have to submit data pages ourselves in case of O_SYNC
> write because __generic_file_aio_write does not do it for us. OCFS2 developpers
> might think about moving the sync out of i_mutex which seems to be easily
> possible but that's out of scope of this patch.
> 
> CC: ocfs2-devel at oss.oracle.com
> CC: Joel Becker <joel.becker@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <joel.becker@oracle.com>
 

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd at loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
