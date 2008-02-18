From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 18 13:03:43 2008
Subject: [Ocfs2-devel] Re: [2.6 patch] make ocfs2_downconvert_thread() static
In-Reply-To: <20080217082038.GU3848@cs181133002.pp.htv.fi>
References: <20080217082038.GU3848@cs181133002.pp.htv.fi>
Message-ID: <20080218210337.GC22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrian Bunk <bunk@kernel.org>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:20:38AM +0200, Adrian Bunk wrote:
> This patch makes the needlessly global ocfs2_downconvert_thread() 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, this is in ocfs2.git now.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
