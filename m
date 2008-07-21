From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 21 Jul 2008 13:36:08 -0700
Subject: [Ocfs2-devel] [PATCH 7/7] fs/ocfs2/file.c: Release mutex in
	error handling	code
In-Reply-To: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
References: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
Message-ID: <20080721203608.GB31671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, Jul 21, 2008 at 09:59:15AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The mutex is released on a successful return, so it would seem that it
> should be released on an error return as well.

	This patch looks right to me.  Mark?

Joel


-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
