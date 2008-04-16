From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 16 Apr 2008 11:20:21 -0700
Subject: [Ocfs2-devel] dentry locks
In-Reply-To: <48055C53.9090809@oracle.com>
References: <48055C53.9090809@oracle.com>
Message-ID: <20080416182020.GB31299@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 15, 2008 at 06:54:27PM -0700, Sunil Mushran wrote:
> Any reason the dentry lock has parent# in string and block# in binary?

Afair, there were space constraints to printing them both in hex.
	--Mark

--
Mark Fasheh
