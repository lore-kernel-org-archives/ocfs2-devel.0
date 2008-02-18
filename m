From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 18 13:04:41 2008
Subject: [Ocfs2-devel] Re: [2.6 patch] ocfs: make dlm_do_assert_master()
	static
In-Reply-To: <20080217082041.GV3848@cs181133002.pp.htv.fi>
References: <20080217082041.GV3848@cs181133002.pp.htv.fi>
Message-ID: <20080218210354.GD22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:20:41AM +0200, Adrian Bunk wrote:
> This patch makes the needlessly global dlm_do_assert_master() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, this is in ocfs2.git now.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
