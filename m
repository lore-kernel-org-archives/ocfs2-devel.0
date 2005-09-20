From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Sep 20 15:37:40 2005
Subject: [Ocfs2-devel] [PATCH] remove ocfs2_write_blocks
In-Reply-To: <20050920202719.GA8021@lst.de>
References: <20050918103617.GA23648@lst.de>
	<20050920202439.GE18764@ca-server1.us.oracle.com>
	<20050920202719.GA8021@lst.de>
Message-ID: <20050920203744.GF18764@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 20, 2005 at 10:27:19PM +0200, Christoph Hellwig wrote:
> I think you lost the get_bh() that zab added after I submitted the
> patch.
Erf, you're right. Thanks for the catch...
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
