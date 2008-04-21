From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 21 Apr 2008 10:43:58 -0700
Subject: [Ocfs2-devel] [2.6 patch] make struct ocfs2_control_device
	static
In-Reply-To: <20080421084926.GS26897@cs181133002.pp.htv.fi>
References: <20080421084926.GS26897@cs181133002.pp.htv.fi>
Message-ID: <20080421174358.GP31299@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:49:26AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global struct ocfs2_control_device 
> static.

This and the following two patches are in ocfs2.git now, thanks Adrian.
	--Mark

--
Mark Fasheh
