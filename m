From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 16 Apr 2008 12:16:17 -0700
Subject: [Ocfs2-devel] dentry locks
In-Reply-To: <48064F0B.1040900@oracle.com>
References: <48055C53.9090809@oracle.com>
	<20080416182020.GB31299@wotan.suse.de>
	<48064582.5020305@oracle.com>
	<20080416190304.GC31299@wotan.suse.de>
	<48064F0B.1040900@oracle.com>
Message-ID: <20080416191617.GD31299@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 16, 2008 at 12:10:03PM -0700, Sunil Mushran wrote:
> I understand that. I am looking to switch the order in the name.
> As in, N<block# in hex>NULL<parent# in bin>. Maybe change N to T
> to prevent confusion.
> 
> Any harm in the above?

Yeah, it breaks the protocol  ;)

If you're just looking to make a change on your local nodes for debugging
purposes, I see no reason why switching the order should break anything.

What do the tcp dumps look like? Is it raw binary data, is the binary
converted into hex, etc?
	--Mark

--
Mark Fasheh
