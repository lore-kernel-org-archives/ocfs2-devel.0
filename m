From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 23 Mar 2010 12:52:25 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100323195224.GA31783@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2010 at 04:04:44PM +0800, Tristan Ye wrote:
> Fast symlink can be treated the same way as inline file for truncating
> and hole punching, since the mechanism is quite simliar per se.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	The patch looks good, with perhaps a bit over-zealous
parentheses ;-)  Is this fixing a bug someone has hit?

Joel


-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
