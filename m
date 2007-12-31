From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 31 11:36:58 2007
Subject: [Ocfs2-devel] Re: [PATCH] ocfs2: convert byte order of constant
	instead of variable
In-Reply-To: <20071225145256.GD24373@joi>
References: <20071225145256.GD24373@joi>
Message-ID: <20071231193542.GR13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Tue, Dec 25, 2007 at 03:52:59PM +0100, Marcin Slusarz wrote:
> convert byte order of constant instead of variable
> it will be done at compile time (vs run time)
> remove unused le32_and_cpu

Ok, this looks good. I'll put it in ocfs2.git later today.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
