From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 15:53:56 -0700
Subject: [Ocfs2-devel] [PATCH 4/8] Write out quota info changes on
	ocfs2_close()
In-Reply-To: <1248717216-26617-5-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-5-git-send-email-jack@suse.cz>
Message-ID: <20090728225356.GB20595@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 27, 2009 at 07:53:32PM +0200, Jan Kara wrote:
> We don't write out change of information in quota file header on each change,
> we rather cache it in ocfs2_filesys structure. So write out all the
> information when ocfs2_close() is called.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This looks good as long as all quota ops keep those ocfs2_cached_inodes
up to date.

Joel

-- 

"In the beginning, the universe was created. This has made a lot 
 of people very angry, and is generally considered to have been a 
 bad move."
        - Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
