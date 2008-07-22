From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 21 Jul 2008 17:07:12 -0700
Subject: [Ocfs2-devel] [PATCH 7/7] fs/ocfs2/file.c: Release mutex in
	error handling code
In-Reply-To: <20080721203608.GB31671@ca-server1.us.oracle.com>
References: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk>
	<20080721203608.GB31671@ca-server1.us.oracle.com>
Message-ID: <20080722000711.GT28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, Jul 21, 2008 at 01:36:08PM -0700, Joel Becker wrote:
> On Mon, Jul 21, 2008 at 09:59:15AM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The mutex is released on a successful return, so it would seem that it
> > should be released on an error return as well.
> 
> 	This patch looks right to me.  Mark?

Yeah, that looks good. Thanks Julia.
	--Mark

--
Mark Fasheh
