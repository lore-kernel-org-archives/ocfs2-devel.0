From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 11:58:46 2007
Subject: [Ocfs2-devel] [PATCH 09/15] ocfs2: Rename cleanups
In-Reply-To: <200709192012.l8JKCG62012197@agmgw2.us.oracle.com>
References: <200709192012.l8JKCG62012197@agmgw2.us.oracle.com>
Message-ID: <20070920185809.GL30391@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 11, 2007 at 05:21:56PM -0700, Mark Fasheh wrote:
> ocfs2_rename() does direct manipulation of the dirent it's gotten back from
> a directory search. Wrap this manipulation inside of a function so that we
> can transparently change directory update behavior in the future. As an
> added bonus, this gets rid of an ugly macro.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>
-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
